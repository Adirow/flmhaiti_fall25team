import 'package:flmhaiti_fall25team/models/form_template.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_config.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_utils.dart';
import 'package:flmhaiti_fall25team/services/form_service.dart';

class FormRepository {
  static final FormRepository _instance = FormRepository._();
  factory FormRepository() => _instance;
  FormRepository._();
  
  bool _isTempId(String? id) {
    return id == null || id.isEmpty || id.startsWith('temp_');
  }
  
  // ============================================
  // FORM TEMPLATES
  // ============================================

  /// Get all templates for a department
  Future<List<FormTemplate>> getTemplatesByDepartment(
    Department department, {
    bool? isActive,
  }) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      
      var queryBuilder = SupabaseConfig.client
          .from('form_templates')
          .select('*')
          .eq('department', department.name)
          .eq('clinic_id', clinicId);

      if (isActive != null) {
        queryBuilder = queryBuilder.eq('is_active', isActive);
      }

      final data = await queryBuilder.order('created_at', ascending: false);
      return data.map<FormTemplate>((json) => FormTemplate.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load templates: $e');
    }
  }

  /// Search templates by name
  Future<List<FormTemplate>> searchTemplates(
    String query, {
    Department? department,
    bool? isActive,
  }) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      
      var queryBuilder = SupabaseConfig.client
          .from('form_templates')
          .select('*')
          .eq('clinic_id', clinicId)
          .ilike('name', '%$query%');

      if (department != null) {
        queryBuilder = queryBuilder.eq('department', department.name);
      }

      if (isActive != null) {
        queryBuilder = queryBuilder.eq('is_active', isActive);
      }

      final data = await queryBuilder.order('created_at', ascending: false);
      return data.map<FormTemplate>((json) => FormTemplate.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search templates: $e');
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

  /// Create or update template
  Future<FormTemplate> upsertTemplate(FormTemplate template) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      final userId = await SupabaseUtils.getCurrentUserId();
      final templateData = template.toJson();
      templateData['clinic_id'] = clinicId;
      templateData['created_by'] = userId;

      // Remove auto-generated fields for new templates
      if (_isTempId(template.id)) {
        templateData.remove('id');
        templateData.remove('created_at');
        templateData['created_by'] = userId;
      } else {
        if ((templateData['created_by'] as String?)?.isEmpty ?? true) {
        templateData['created_by'] = userId;
        }
      }
      templateData.remove('updated_at');

      final result = await SupabaseConfig.client
          .from('form_templates')
          .upsert(templateData)
          .select()
          .single();

      return FormTemplate.fromJson(result);
    } catch (e) {
      throw Exception('Failed to save template: $e');
    }
  }

  /// Archive template (set is_active = false)
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

  /// Duplicate template with new version
  Future<FormTemplate> duplicateTemplate(String templateId) async {
    try {
      // Get original template
      final original = await getTemplateById(templateId);
      if (original == null) {
        throw Exception('Template not found');
      }

      // Create new template with incremented version
      final newTemplate = original.copyWith(
        id: '', // Will be generated
        version: original.version + 1,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      // Save new template
      final savedTemplate = await upsertTemplate(newTemplate);

      // Get and duplicate sections
      final sections = await getSectionsByTemplateId(templateId);
      for (final section in sections) {
        final newSection = section.copyWith(
          id: '', // Will be generated
          templateId: savedTemplate.id,
          createdAt: DateTime.now(),
        );
        final savedSection = await upsertSection(newSection);

        // Get and duplicate questions
        final questions = await getQuestionsBySectionId(section.id);
        for (final question in questions) {
          final newQuestion = question.copyWith(
            id: '', // Will be generated
            sectionId: savedSection.id,
            createdAt: DateTime.now(),
          );
          await upsertQuestion(newQuestion);
        }
      }

      return savedTemplate;
    } catch (e) {
      throw Exception('Failed to duplicate template: $e');
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

  /// Create or update section
  Future<FormSection> upsertSection(FormSection section) async {
    try {
      final sectionData = section.toJson();

      // Remove auto-generated fields for new sections
      if (_isTempId(section.id)) {
        sectionData.remove('id');
        sectionData.remove('created_at');
      }

      final result = await SupabaseConfig.client
          .from('form_sections')
          .upsert(sectionData)
          .select()
          .single();

      return FormSection.fromJson(result);
    } catch (e) {
      throw Exception('Failed to save section: $e');
    }
  }

  /// Delete section
  Future<void> deleteSection(String id) async {
    try {
      // First delete all questions in this section
      await SupabaseConfig.client
          .from('form_questions')
          .delete()
          .eq('section_id', id);

      // Then delete the section
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
          .order('sort_order');

      return data.map<FormQuestion>((json) => FormQuestion.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  /// Get questions by template ID (across all sections)
  Future<Map<String, List<FormQuestion>>> getQuestionsByTemplateId(String templateId) async {
    try {
      final sections = await getSectionsByTemplateId(templateId);
      final Map<String, List<FormQuestion>> result = {};

      for (final section in sections) {
        final questions = await getQuestionsBySectionId(section.id);
        result[section.id] = questions;
      }

      return result;
    } catch (e) {
      throw Exception('Failed to load template questions: $e');
    }
  }

  /// Search existing questions by logical_id (for reuse)
  Future<List<FormQuestion>> searchQuestionsByLogicalId(String logicalId) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      
      final data = await SupabaseConfig.client
          .from('form_questions')
          .select('*, form_sections!inner(form_templates!inner(clinic_id))')
          .eq('logical_id', logicalId)
          .eq('form_sections.form_templates.clinic_id', clinicId)
          .eq('is_active', true)
          .limit(10);

      return data.map<FormQuestion>((json) => FormQuestion.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search questions: $e');
    }
  }

  /// Check if a logicalId already exists within current clinic
  /// Delegates to FormService for improved stability
  Future<FormQuestion?> checkDuplicateLogicalId(String logicalId) async {
    return FormService().checkDuplicateLogicalId(logicalId);
  }

  /// Create or update question
  Future<FormQuestion> upsertQuestion(FormQuestion question) async {
    try {
      final questionData = question.toJson();

      // Remove auto-generated fields for new questions
      if (_isTempId(question.id)) {
        questionData.remove('id');
        questionData.remove('created_at');
      }

      final result = await SupabaseConfig.client
          .from('form_questions')
          .upsert(questionData)
          .select()
          .single();

      return FormQuestion.fromJson(result);
    } catch (e) {
      throw Exception('Failed to save question: $e');
    }
  }

  /// Soft delete question (set is_active = false)
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

  /// Hard delete question
  Future<void> deleteQuestion(String id) async {
    try {
      await SupabaseConfig.client
          .from('form_questions')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete question: $e');
    }
  }

  // ============================================
  // BATCH OPERATIONS
  // ============================================

  /// Save entire template structure (template + sections + questions)
  Future<FormTemplate> saveTemplateStructure({
    required FormTemplate template,
    required List<FormSection> sections,
    required Map<String, List<FormQuestion>> questionsBySection,
  }) async {
    try {
      // Save template first
      final savedTemplate = await upsertTemplate(template);

      // Save sections and questions
      for (int i = 0; i < sections.length; i++) {
        final section = sections[i].copyWith(
          templateId: savedTemplate.id,
          sortOrder: i,
        );
        final savedSection = await upsertSection(section);

        // Save questions for this section
        final questions = questionsBySection[sections[i].id] ?? [];
        for (int j = 0; j < questions.length; j++) {
          final question = questions[j].copyWith(
            sectionId: savedSection.id,
            sortOrder: j,
          );
          await upsertQuestion(question);
        }
      }

      return savedTemplate;
    } catch (e) {
      throw Exception('Failed to save template structure: $e');
    }
  }
}
