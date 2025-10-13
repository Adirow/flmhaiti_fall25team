import 'package:dental_roots/models/form_template.dart';
import 'package:dental_roots/supabase/supabase_config.dart';
import 'package:dental_roots/supabase/supabase_utils.dart';

/// Simplified form service for MVP implementation
class FormService {
  static final FormService _instance = FormService._();
  factory FormService() => _instance;
  FormService._();

  // ============================================
  // FORM TEMPLATES
  // ============================================

  /// Get all templates for current clinic
  Future<List<FormTemplate>> getAllTemplates() async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      
      final data = await SupabaseConfig.client
          .from('form_templates')
          .select('*')
          .eq('clinic_id', clinicId)
          .order('created_at', ascending: false);

      return data.map<FormTemplate>((json) => FormTemplate.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load templates: $e');
    }
  }

  /// Get templates by department
  Future<List<FormTemplate>> getTemplatesByDepartment(Department department) async {
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

  /// Get template by ID
  Future<FormTemplate?> getTemplateById(String id) async {
    try {
      final data = await SupabaseConfig.client
          .from('form_templates')
          .select('*')
          .eq('id', id)
          .maybeSingle();

      return data != null ? FormTemplate.fromJson(data) : null;
    } catch (e) {
      throw Exception('Failed to load template: $e');
    }
  }

  /// Create new template
  Future<FormTemplate> createTemplate(FormTemplate template) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      final currentUser = SupabaseConfig.client.auth.currentUser;
      
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final templateData = template.toJson();
      templateData['clinic_id'] = clinicId;
      templateData['created_by'] = currentUser.id;
      templateData.remove('id');
      templateData.remove('created_at');
      templateData.remove('updated_at');

      final result = await SupabaseConfig.client
          .from('form_templates')
          .insert(templateData)
          .select()
          .single();

      return FormTemplate.fromJson(result);
    } catch (e) {
      throw Exception('Failed to create template: $e');
    }
  }

  /// Update template
  Future<FormTemplate> updateTemplate(FormTemplate template) async {
    try {
      final templateData = template.toJson();
      templateData.remove('created_at');
      templateData.remove('updated_at');
      templateData.remove('clinic_id');
      templateData.remove('created_by');

      final result = await SupabaseConfig.client
          .from('form_templates')
          .update(templateData)
          .eq('id', template.id)
          .select()
          .single();

      return FormTemplate.fromJson(result);
    } catch (e) {
      throw Exception('Failed to update template: $e');
    }
  }

  /// Archive template
  Future<void> archiveTemplate(String id) async {
    try {
      await SupabaseConfig.client
          .from('form_templates')
          .update({'is_active': false})
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to archive template: $e');
    }
  }

  // ============================================
  // FORM SECTIONS
  // ============================================

  /// Get sections by template ID
  Future<List<FormSection>> getSectionsByTemplateId(String templateId) async {
    try {
      final data = await SupabaseConfig.client
          .from('form_sections')
          .select('*')
          .eq('template_id', templateId)
          .order('sort_order');

      return data.map<FormSection>((json) => FormSection.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load sections: $e');
    }
  }

  /// Create section
  Future<FormSection> createSection(FormSection section) async {
    try {
      final sectionData = section.toJson();
      sectionData.remove('id');
      sectionData.remove('created_at');

      final result = await SupabaseConfig.client
          .from('form_sections')
          .insert(sectionData)
          .select()
          .single();

      return FormSection.fromJson(result);
    } catch (e) {
      throw Exception('Failed to create section: $e');
    }
  }

  /// Update section
  Future<FormSection> updateSection(FormSection section) async {
    try {
      final sectionData = section.toJson();
      sectionData.remove('created_at');

      final result = await SupabaseConfig.client
          .from('form_sections')
          .update(sectionData)
          .eq('id', section.id)
          .select()
          .single();

      return FormSection.fromJson(result);
    } catch (e) {
      throw Exception('Failed to update section: $e');
    }
  }

  /// Delete section
  Future<void> deleteSection(String id) async {
    try {
      await SupabaseConfig.client
          .from('form_sections')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete section: $e');
    }
  }

  // ============================================
  // FORM QUESTIONS
  // ============================================

  /// Get questions by section ID
  Future<List<FormQuestion>> getQuestionsBySectionId(String sectionId) async {
    try {
      final data = await SupabaseConfig.client
          .from('form_questions')
          .select('*')
          .eq('section_id', sectionId)
          .eq('is_active', true)
          .order('sort_order');

      return data.map<FormQuestion>((json) => FormQuestion.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  /// Create question
  Future<FormQuestion> createQuestion(FormQuestion question) async {
    try {
      final questionData = question.toJson();
      questionData.remove('id');
      questionData.remove('created_at');

      final result = await SupabaseConfig.client
          .from('form_questions')
          .insert(questionData)
          .select()
          .single();

      return FormQuestion.fromJson(result);
    } catch (e) {
      throw Exception('Failed to create question: $e');
    }
  }

  /// Update question
  Future<FormQuestion> updateQuestion(FormQuestion question) async {
    try {
      final questionData = question.toJson();
      questionData.remove('created_at');

      final result = await SupabaseConfig.client
          .from('form_questions')
          .update(questionData)
          .eq('id', question.id)
          .select()
          .single();

      return FormQuestion.fromJson(result);
    } catch (e) {
      throw Exception('Failed to update question: $e');
    }
  }

  /// Delete question (soft delete)
  Future<void> deactivateQuestion(String id) async {
    try {
      await SupabaseConfig.client
          .from('form_questions')
          .update({'is_active': false})
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to deactivate question: $e');
    }
  }

  // ============================================
  // LOGICAL ID DUPLICATE CHECK
  // ============================================

  /// Search existing questions by logical_id (for reuse)
  Future<List<FormQuestion>> searchQuestionsByLogicalId(String logicalId) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      
      // Step 1: Find questions with matching logicalId
      final questions = await SupabaseConfig.client
          .from('form_questions')
          .select('*')
          .eq('logical_id', logicalId.trim())
          .eq('is_active', true)
          .limit(10); // Limit for safety

      if (questions.isEmpty) return [];

      // Step 2: Filter questions that belong to current clinic
      final List<FormQuestion> validQuestions = [];
      
      for (final questionData in questions) {
        try {
          final sectionId = questionData['section_id'] as String?;
          if (sectionId == null) continue;

          // Get section
          final sections = await SupabaseConfig.client
              .from('form_sections')
              .select('template_id')
              .eq('id', sectionId)
              .limit(1);

          if (sections.isEmpty) continue;

          final templateId = sections.first['template_id'] as String?;
          if (templateId == null) continue;

          // Check if template belongs to current clinic
          final templates = await SupabaseConfig.client
              .from('form_templates')
              .select('clinic_id')
              .eq('id', templateId)
              .eq('clinic_id', clinicId)
              .limit(1);

          if (templates.isNotEmpty) {
            validQuestions.add(FormQuestion.fromJson(questionData));
          }
        } catch (e) {
          // Log error but continue with other questions
          print('Error checking question ${questionData['id']}: $e');
          continue;
        }
      }

      return validQuestions;
    } catch (e) {
      throw Exception('Failed to search questions: $e');
    }
  }

  /// Check if a logical ID already exists within current clinic
  /// Uses separate queries to avoid join exceptions and improve stability
  Future<FormQuestion?> checkDuplicateLogicalId(String logicalId) async {
    try {
      if (logicalId.trim().isEmpty) return null;

      final clinicId = await SupabaseUtils.getCurrentClinicId();

      // Step 1: Find all questions with matching logicalId (with limit for safety)
      final questions = await SupabaseConfig.client
          .from('form_questions')
          .select('''id, label, logical_id, section_id,type, required, sort_order,is_active, options, visible_if, created_at''')
          .eq('logical_id', logicalId.trim())
          .eq('is_active', true)
          .limit(50); // Safety limit to prevent excessive queries

      if (questions.isEmpty) return null;

      // Step 2: Check each question to see if it belongs to current clinic
      for (final questionData in questions) {
        try {
          final sectionId = questionData['section_id'] as String?;
          if (sectionId == null) continue;

          // Get section with limit for safety
          final sections = await SupabaseConfig.client
              .from('form_sections')
              .select('id, template_id')
              .eq('id', sectionId)
              .limit(1);

          if (sections.isEmpty) continue;

          final templateId = sections.first['template_id'] as String?;
          if (templateId == null) continue;

          // Get template with limit for safety
          final templates = await SupabaseConfig.client
              .from('form_templates')
              .select('id, name, clinic_id')
              .eq('id', templateId)
              .eq('clinic_id', clinicId)
              .limit(1);

          if (templates.isNotEmpty) {
            // Found duplicate in current clinic
            final templateName = templates.first['name'] as String?;
            
            // Add template info to question data for better error reporting
            final enrichedQuestionData = Map<String, dynamic>.from(questionData);
            enrichedQuestionData['template_name'] = templateName;
            
            return FormQuestion.fromJson(enrichedQuestionData);
          }
        } catch (e) {
          // Log individual question check error but continue
          print('Error checking question ${questionData['id']}: $e');
          continue;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Failed to check duplicate logical ID: $e');
    }
  }
}
