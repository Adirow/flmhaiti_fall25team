import 'package:dental_roots/models/form_template.dart';
import 'package:dental_roots/models/questionnaire_session.dart';
import 'package:dental_roots/supabase/supabase_config.dart';
import 'package:dental_roots/supabase/supabase_utils.dart';

class QuestionnaireRepository {
  static final QuestionnaireRepository _instance = QuestionnaireRepository._();
  factory QuestionnaireRepository() => _instance;
  QuestionnaireRepository._();

  // ============================================
  // TEMPLATE LOADING
  // ============================================

  /// Get available departments (from active templates)
  Future<List<Department>> getAvailableDepartments() async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      
      final data = await SupabaseConfig.client
          .from('form_templates')
          .select('department')
          .eq('clinic_id', clinicId)
          .eq('is_active', true);

      final departments = data
          .map((row) => row['department'] as String)
          .toSet()
          .map((dept) => Department.values.firstWhere((e) => e.name == dept))
          .toList();

      return departments;
    } catch (e) {
      throw Exception('Failed to load available departments: $e');
    }
  }

  /// Get active templates by department
  Future<List<FormTemplate>> getActiveTemplatesByDepartment(Department department) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      
      final data = await SupabaseConfig.client
          .from('form_templates')
          .select('*')
          .eq('clinic_id', clinicId)
          .eq('department', department.name)
          .eq('is_active', true)
          .order('version', ascending: false);

      return data.map<FormTemplate>((json) => FormTemplate.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load templates: $e');
    }
  }

  /// Load complete template structure (sections + questions)
  Future<Map<String, dynamic>> loadTemplateStructure(String templateId) async {
    try {
      // Load sections
      final sectionsData = await SupabaseConfig.client
          .from('form_sections')
          .select('*')
          .eq('template_id', templateId)
          .order('sort_order');

      final sections = sectionsData.map<FormSection>((json) => FormSection.fromJson(json)).toList();

      // Load questions for all sections
      final sectionIds = sections.map((s) => s.id).toList();
      if (sectionIds.isEmpty) {
        return {'sections': sections, 'questionsBySection': <String, List<FormQuestion>>{}};
      }

      final questionsData = await SupabaseConfig.client
          .from('form_questions')
          .select('*')
          .inFilter('section_id', sectionIds)
          .eq('is_active', true)
          .order('sort_order');

      final questions = questionsData.map<FormQuestion>((json) => FormQuestion.fromJson(json)).toList();

      // Group questions by section
      final Map<String, List<FormQuestion>> questionsBySection = {};
      for (final section in sections) {
        questionsBySection[section.id] = questions
            .where((q) => q.sectionId == section.id)
            .toList();
      }

      return {
        'sections': sections,
        'questionsBySection': questionsBySection,
      };
    } catch (e) {
      throw Exception('Failed to load template structure: $e');
    }
  }

  // ============================================
  // SESSION MANAGEMENT
  // ============================================

  /// Get patient's questionnaire sessions
  Future<List<QuestionnaireSessionSummary>> getPatientSessions(String patientId) async {
    try {
      // Get sessions first
      final sessionsData = await SupabaseConfig.client
          .from('questionnaire_sessions')
          .select('*')
          .eq('patient_id', patientId)
          .order('started_at', ascending: false);

      if (sessionsData.isEmpty) {
        return [];
      }

      // Get patient info
      final patientData = await SupabaseConfig.client
          .from('patients')
          .select('name, phone')
          .eq('id', patientId)
          .maybeSingle();

      final patientName = patientData?['name'] as String?;
      final patientPhone = patientData?['phone'] as String?;

      // Convert sessions and calculate stats
      final List<QuestionnaireSessionSummary> summaries = [];
      
      for (final sessionJson in sessionsData) {
        final session = QuestionnaireSession.fromJson(sessionJson);
        
        // Get answer count for this session
        final answersData = await SupabaseConfig.client
            .from('questionnaire_answers')
            .select('answer_value')
            .eq('session_id', session.id);

        final answeredQuestions = answersData.length;
        final completedQuestions = answersData
            .where((answer) => answer['answer_value'] != null && 
                              answer['answer_value'].toString() != 'null')
            .length;

        // Create summary with calculated stats
        final summary = QuestionnaireSessionSummary(
          session: session,
          answeredQuestions: answeredQuestions,
          completedQuestions: completedQuestions,
          patientName: patientName,
          patientPhone: patientPhone,
        );
        
        summaries.add(summary);
      }

      return summaries;
    } catch (e) {
      throw Exception('Failed to load patient sessions: $e');
    }
  }

  /// Get session by ID
  Future<QuestionnaireSession?> getSessionById(String sessionId) async {
    try {
      final data = await SupabaseConfig.client
          .from('questionnaire_sessions')
          .select('*')
          .eq('id', sessionId)
          .maybeSingle();

      return data != null ? QuestionnaireSession.fromJson(data) : null;
    } catch (e) {
      throw Exception('Failed to load session: $e');
    }
  }

  /// Create new questionnaire session
  Future<QuestionnaireSession> createSession({
    required String patientId,
    required FormTemplate template,
  }) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      final userId = await SupabaseUtils.getCurrentUserId();

      final sessionData = {
        'patient_id': patientId,
        'template_id': template.id,
        'template_name': template.name,
        'template_version': template.version,
        'department': template.department.name,
        'status': 'in_progress',
        'created_by': userId,
        'clinic_id': clinicId,
      };

      final result = await SupabaseConfig.client
          .from('questionnaire_sessions')
          .insert(sessionData)
          .select()
          .single();

      return QuestionnaireSession.fromJson(result);
    } catch (e) {
      throw Exception('Failed to create session: $e');
    }
  }

  /// Update session status
  Future<QuestionnaireSession> updateSessionStatus(String sessionId, SessionStatus status) async {
    try {
      String statusString;
      switch (status) {
        case SessionStatus.inProgress:
          statusString = 'in_progress';
          break;
        case SessionStatus.submitted:
          statusString = 'submitted';
          break;
        case SessionStatus.archived:
          statusString = 'archived';
          break;
      }

      final result = await SupabaseConfig.client
          .from('questionnaire_sessions')
          .update({'status': statusString})
          .eq('id', sessionId)
          .select()
          .single();

      return QuestionnaireSession.fromJson(result);
    } catch (e) {
      throw Exception('Failed to update session status: $e');
    }
  }

  /// Submit session (mark as completed)
  Future<QuestionnaireSession> submitSession(String sessionId) async {
    return updateSessionStatus(sessionId, SessionStatus.submitted);
  }

  /// Archive session
  Future<QuestionnaireSession> archiveSession(String sessionId) async {
    return updateSessionStatus(sessionId, SessionStatus.archived);
  }

  // ============================================
  // ANSWER MANAGEMENT
  // ============================================

  /// Get all answers for a session
  Future<Map<String, QuestionnaireAnswer>> getSessionAnswers(String sessionId) async {
    try {
      final data = await SupabaseConfig.client
          .from('questionnaire_answers')
          .select('*')
          .eq('session_id', sessionId);

      final answers = data.map<QuestionnaireAnswer>((json) => 
          QuestionnaireAnswer.fromJson(json)).toList();

      // Convert to map keyed by logical_id for easy lookup
      final Map<String, QuestionnaireAnswer> answerMap = {};
      for (final answer in answers) {
        answerMap[answer.questionLogicalId] = answer;
      }

      return answerMap;
    } catch (e) {
      throw Exception('Failed to load session answers: $e');
    }
  }

  /// Get answers as simple value map (for form initialization)
  Future<Map<String, dynamic>> getSessionAnswerValues(String sessionId) async {
    try {
      final answers = await getSessionAnswers(sessionId);
      final Map<String, dynamic> valueMap = {};
      
      for (final entry in answers.entries) {
        valueMap[entry.key] = entry.value.answerValue;
      }
      
      return valueMap;
    } catch (e) {
      throw Exception('Failed to load session answer values: $e');
    }
  }

  /// Upsert single answer
  Future<QuestionnaireAnswer> upsertAnswer({
    required String sessionId,
    required String questionLogicalId,
    required String questionLabel,
    required QuestionType questionType,
    required dynamic answerValue,
  }) async {
    try {
      final answerData = {
        'session_id': sessionId,
        'question_logical_id': questionLogicalId,
        'question_label': questionLabel,
        'question_type': questionType.name,
        'answer_value': answerValue,
      };

      final result = await SupabaseConfig.client
          .from('questionnaire_answers')
          .upsert(answerData)
          .select()
          .single();

      return QuestionnaireAnswer.fromJson(result);
    } catch (e) {
      throw Exception('Failed to save answer: $e');
    }
  }

  /// Batch upsert multiple answers
  Future<List<QuestionnaireAnswer>> upsertAnswers({
    required String sessionId,
    required Map<String, dynamic> answers,
    required Map<String, FormQuestion> questionMap,
  }) async {
    try {
      final List<Map<String, dynamic>> answerDataList = [];
      
      for (final entry in answers.entries) {
        final question = questionMap[entry.key];
        if (question != null && entry.value != null) {

          dynamic value = entry.value;

          if (value is DateTime) {
            value = value.toIso8601String();
          }

          answerDataList.add({
            'session_id': sessionId,
            'question_logical_id': entry.key,
            'question_label': question.label,
            'question_type': question.type.name,
            'answer_value': value,
          });
        }
      }

      if (answerDataList.isEmpty) return [];

      final results = await SupabaseConfig.client
          .from('questionnaire_answers')
          .upsert(
            answerDataList,
            onConflict: 'session_id,question_logical_id',
          )
          .select();

      return results.map<QuestionnaireAnswer>((json) => 
          QuestionnaireAnswer.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to batch save answers: $e');
    }
  }

  /// Delete answer
  Future<void> deleteAnswer(String sessionId, String questionLogicalId) async {
    try {
      await SupabaseConfig.client
          .from('questionnaire_answers')
          .delete()
          .eq('session_id', sessionId)
          .eq('question_logical_id', questionLogicalId);
    } catch (e) {
      throw Exception('Failed to delete answer: $e');
    }
  }

  // ============================================
  // UTILITY METHODS
  // ============================================

  /// Check if patient has incomplete sessions for template
  Future<QuestionnaireSession?> getIncompleteSession(String patientId, String templateId) async {
    try {
      final data = await SupabaseConfig.client
          .from('questionnaire_sessions')
          .select('*')
          .eq('patient_id', patientId)
          .eq('template_id', templateId)
          .eq('status', 'in_progress')
          .order('started_at', ascending: false)
          .limit(1)
          .maybeSingle();

      return data != null ? QuestionnaireSession.fromJson(data) : null;
    } catch (e) {
      throw Exception('Failed to check incomplete sessions: $e');
    }
  }

  /// Get session completion statistics
  Future<Map<String, int>> getSessionStats(String sessionId) async {
    try {
      final data = await SupabaseConfig.client
          .from('questionnaire_session_summary')
          .select('answered_questions, completed_questions')
          .eq('id', sessionId)
          .single();

      return {
        'answered': data['answered_questions'] as int? ?? 0,
        'completed': data['completed_questions'] as int? ?? 0,
      };
    } catch (e) {
      throw Exception('Failed to get session stats: $e');
    }
  }

  /// Create question map for easy lookup
  Map<String, FormQuestion> createQuestionMap(Map<String, List<FormQuestion>> questionsBySection) {
    final Map<String, FormQuestion> questionMap = {};
    
    for (final questions in questionsBySection.values) {
      for (final question in questions) {
        questionMap[question.logicalId] = question;
      }
    }
    
    return questionMap;
  }
}
