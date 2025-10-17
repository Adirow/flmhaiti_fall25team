import 'package:flmhaiti_fall25team/models/form_template.dart';
import 'package:flmhaiti_fall25team/models/questionnaire_session.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_config.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_utils.dart';

/// Debug version of QuestionnaireRepository with simplified queries
class QuestionnaireRepositoryDebug {
  static final QuestionnaireRepositoryDebug _instance = QuestionnaireRepositoryDebug._();
  factory QuestionnaireRepositoryDebug() => _instance;
  QuestionnaireRepositoryDebug._();

  /// Simple test to check if basic queries work
  Future<void> testConnection() async {
    try {
      print('Testing database connection...');
      
      // Test 1: Check if we can get current user
      final userId = await SupabaseUtils.getCurrentUserId();
      print('✓ Current user ID: $userId');
      
      // Test 2: Check if we can get clinic ID
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      print('✓ Current clinic ID: $clinicId');
      
      // Test 3: Check if form_templates table exists and has data
      final templatesData = await SupabaseConfig.client
          .from('form_templates')
          .select('id, name, department, is_active')
          .limit(5);
      print('✓ Found ${templatesData.length} templates');
      
      // Test 4: Check if patients table exists
      final patientsData = await SupabaseConfig.client
          .from('patients')
          .select('id, name')
          .limit(5);
      print('✓ Found ${patientsData.length} patients');
      
      // Test 5: Check if questionnaire tables exist
      final sessionsData = await SupabaseConfig.client
          .from('questionnaire_sessions')
          .select('id')
          .limit(1);
      print('✓ questionnaire_sessions table exists (${sessionsData.length} records)');
      
      final answersData = await SupabaseConfig.client
          .from('questionnaire_answers')
          .select('id')
          .limit(1);
      print('✓ questionnaire_answers table exists (${answersData.length} records)');
      
      print('All tests passed!');
    } catch (e) {
      print('❌ Test failed: $e');
      rethrow;
    }
  }

  /// Get patient sessions with minimal processing
  Future<List<QuestionnaireSession>> getPatientSessionsSimple(String patientId) async {
    try {
      print('Loading sessions for patient: $patientId');
      
      final sessionsData = await SupabaseConfig.client
          .from('questionnaire_sessions')
          .select('*')
          .eq('patient_id', patientId)
          .order('started_at', ascending: false);

      print('Found ${sessionsData.length} sessions');
      
      final sessions = <QuestionnaireSession>[];
      for (final sessionJson in sessionsData) {
        try {
          final session = QuestionnaireSession.fromJson(sessionJson);
          sessions.add(session);
          print('✓ Parsed session: ${session.templateName} (${session.status})');
        } catch (e) {
          print('❌ Failed to parse session: $e');
          print('Session data: $sessionJson');
        }
      }

      return sessions;
    } catch (e) {
      print('❌ Failed to load patient sessions: $e');
      throw Exception('Failed to load patient sessions: $e');
    }
  }

  /// Get available departments with error handling
  Future<List<Department>> getAvailableDepartmentsSimple() async {
    try {
      print('Loading available departments...');
      
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      print('Using clinic ID: $clinicId');
      
      final data = await SupabaseConfig.client
          .from('form_templates')
          .select('department')
          .eq('clinic_id', clinicId)
          .eq('is_active', true);

      print('Found ${data.length} active templates');
      
      final departments = data
          .map((row) => row['department'] as String)
          .toSet()
          .map((dept) {
            try {
              return Department.values.firstWhere((e) => e.name == dept);
            } catch (e) {
              print('❌ Unknown department: $dept');
              return null;
            }
          })
          .where((dept) => dept != null)
          .cast<Department>()
          .toList();

      print('Available departments: ${departments.map((d) => d.name).join(', ')}');
      return departments;
    } catch (e) {
      print('❌ Failed to load departments: $e');
      throw Exception('Failed to load available departments: $e');
    }
  }

  /// Get templates by department with error handling
  Future<List<FormTemplate>> getActiveTemplatesByDepartmentSimple(Department department) async {
    try {
      print('Loading templates for department: ${department.name}');
      
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      
      final data = await SupabaseConfig.client
          .from('form_templates')
          .select('*')
          .eq('clinic_id', clinicId)
          .eq('department', department.name)
          .eq('is_active', true)
          .order('version', ascending: false);

      print('Found ${data.length} templates for ${department.name}');
      
      final templates = <FormTemplate>[];
      for (final templateJson in data) {
        try {
          final template = FormTemplate.fromJson(templateJson);
          templates.add(template);
          print('✓ Parsed template: ${template.name} v${template.version}');
        } catch (e) {
          print('❌ Failed to parse template: $e');
          print('Template data: $templateJson');
        }
      }

      return templates;
    } catch (e) {
      print('❌ Failed to load templates: $e');
      throw Exception('Failed to load templates: $e');
    }
  }
}
