import 'package:flmhaiti_fall25team/models/patient.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_config.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_utils.dart';

class PatientService {
  static final PatientService _instance = PatientService._();
  factory PatientService() => _instance;
  PatientService._();

  /// Get all patients for a specific clinic
  Future<List<Patient>> getAllPatients() async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();

      final data = await SupabaseService.select(
        'patients',
        filters: {'clinic_id': clinicId},
        orderBy: 'name',
        ascending: true,
      );

      return data.map((json) => Patient.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load patients: $e');
    }
  }

  /// Get a specific patient by ID
  Future<Patient?> getPatientById(String id) async {
    try {
      final data = await SupabaseService.selectSingle(
        'patients',
        filters: {'id': id},
      );

      return data != null ? Patient.fromJson(data) : null;
    } catch (e) {
      throw Exception('Failed to load patient: $e');
    }
  }

  /// Search patients by name or phone
  Future<List<Patient>> searchPatients(String query) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();

      if (query.trim().isEmpty) {
        return await getAllPatients();
      }

      final data = await SupabaseConfig.client
          .from('patients')
          .select('*') // ✅ includes numeric_id automatically
          .eq('clinic_id', clinicId)
          .or('name.ilike.%$query%,phone.ilike.%$query%')
          .order('name');

      return data.map<Patient>((json) => Patient.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search patients: $e');
    }
  }

  /// Create a new patient
  Future<Patient> createPatient(Patient patient) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      final patientData = patient.toJson();
      patientData['clinic_id'] = clinicId;

      // Remove auto-generated fields
      patientData.remove('id');
      patientData.remove('created_at');
      patientData.remove('updated_at');

      if (patientData['numeric_id'] == 0) {
        patientData.remove('numeric_id');
      }

      final result = await SupabaseService.insert('patients', patientData);
      return Patient.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to create patient: $e');
    }
  }

  /// Update an existing patient
  Future<Patient> updatePatient(Patient patient) async {
    try {
      final patientData = patient.toJson();

      // Remove fields that shouldn't be updated
      patientData.remove('id');
      patientData.remove('created_at');
      patientData.remove('updated_at');

      patientData.remove('numeric_id');

      final result = await SupabaseService.update(
        'patients',
        patientData,
        filters: {'id': patient.id},
      );

      return Patient.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to update patient: $e');
    }
  }

  /// Delete a patient
  Future<void> deletePatient(String id) async {
    try {
      await SupabaseService.delete(
        'patients',
        filters: {'id': id},
      );
    } catch (e) {
      throw Exception('Failed to delete patient: $e');
    }
  }

  /// Get patients count for a clinic
  Future<int> getPatientsCount(String clinicId) async {
    try {
      final data = await SupabaseConfig.client
          .from('patients')
          .select('id')
          .eq('clinic_id', clinicId);

      return data.length;
    } catch (e) {
      throw Exception('Failed to get patients count: $e');
    }
  }

  /// Get recent patients (last 10)
  Future<List<Patient>> getRecentPatients(String clinicId) async {
    try {
      final data = await SupabaseService.select(
        'patients',
        filters: {'clinic_id': clinicId},
        orderBy: 'created_at',
        ascending: false,
        limit: 10,
      );

      return data.map((json) => Patient.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load recent patients: $e');
    }
  }
}
