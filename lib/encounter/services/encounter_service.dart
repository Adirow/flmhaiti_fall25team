import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/encounter.dart';
import 'department_service.dart';
import 'tool_data_service.dart';

class EncounterService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DepartmentService _departmentService = DepartmentService();
  final ToolDataService _toolDataService = ToolDataService();

  // 创建问诊
  Future<Encounter> createEncounter({
    required String patientId,
    required String providerId,
    required String clinicId,
    String? departmentId,
    required String examType,
    required String chiefComplaint,
    String notes = '',
    DateTime? visitDate,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _supabase
          .from('encounters')
          .insert({
            'patient_id': patientId,
            'provider_id': providerId,
            'clinic_id': clinicId,
            'department_id': departmentId,
            'exam_type': examType,
            'chief_complaint': chiefComplaint,
            'notes': notes,
            'visit_date': (visitDate ?? DateTime.now()).toIso8601String(),
            'status': 'active',
            'metadata': metadata ?? {},
          })
          .select()
          .single();

      return Encounter.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create encounter: $e');
    }
  }

  // 获取问诊详情
  Future<Encounter?> getEncounter(String encounterId) async {
    try {
      final response = await _supabase
          .from('encounters')
          .select()
          .eq('id', encounterId)
          .maybeSingle();

      return response != null ? Encounter.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to get encounter: $e');
    }
  }

  // 获取问诊列表
  Future<List<Encounter>> getEncounters({
    String? patientId,
    String? providerId,
    String? clinicId,
    String? departmentId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      var query = _supabase.from('encounters').select();

      if (patientId != null) query = query.eq('patient_id', patientId);
      if (providerId != null) query = query.eq('provider_id', providerId);
      if (clinicId != null) query = query.eq('clinic_id', clinicId);
      if (departmentId != null) query = query.eq('department_id', departmentId);
      if (status != null) query = query.eq('status', status);
      if (fromDate != null) {
        query = query.gte('visit_date', fromDate.toIso8601String());
      }
      if (toDate != null) {
        query = query.lte('visit_date', toDate.toIso8601String());
      }

      final response = await query
          .order('visit_date', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => Encounter.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get encounters: $e');
    }
  }

  // 更新问诊
  Future<Encounter> updateEncounter({
    required String encounterId,
    String? departmentId,
    String? examType,
    String? chiefComplaint,
    String? notes,
    String? status,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (departmentId != null) updateData['department_id'] = departmentId;
      if (examType != null) updateData['exam_type'] = examType;
      if (chiefComplaint != null) updateData['chief_complaint'] = chiefComplaint;
      if (notes != null) updateData['notes'] = notes;
      if (status != null) updateData['status'] = status;
      if (metadata != null) updateData['metadata'] = metadata;

      final response = await _supabase
          .from('encounters')
          .update(updateData)
          .eq('id', encounterId)
          .select()
          .single();

      return Encounter.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update encounter: $e');
    }
  }

  // 完成问诊
  Future<Encounter> completeEncounter(String encounterId) async {
    return await updateEncounter(
      encounterId: encounterId,
      status: 'completed',
    );
  }

  // 取消问诊
  Future<Encounter> cancelEncounter(String encounterId) async {
    return await updateEncounter(
      encounterId: encounterId,
      status: 'cancelled',
    );
  }

  // 删除问诊
  Future<void> deleteEncounter(String encounterId) async {
    try {
      await _supabase
          .from('encounters')
          .delete()
          .eq('id', encounterId);
    } catch (e) {
      throw Exception('Failed to delete encounter: $e');
    }
  }

  // 获取问诊的完整数据（包含工具数据）
  Future<Map<String, dynamic>> getEncounterWithToolData(String encounterId) async {
    try {
      final encounter = await getEncounter(encounterId);
      if (encounter == null) {
        throw Exception('Encounter not found');
      }

      final toolData = await _toolDataService.getEncounterToolData(encounterId);
      
      // 获取科室信息
      Map<String, dynamic>? departmentInfo;
      if (encounter.departmentId != null) {
        final department = await _departmentService.getDepartmentById(encounter.departmentId!);
        if (department != null) {
          departmentInfo = department.toJson();
        }
      }

      return {
        'encounter': encounter.toJson(),
        'department': departmentInfo,
        'tool_data': toolData.map((data) => data.toJson()).toList(),
      };
    } catch (e) {
      throw Exception('Failed to get encounter with tool data: $e');
    }
  }

  // 保存问诊的工具数据
  Future<void> saveEncounterToolData({
    required String encounterId,
    required Map<String, Map<String, dynamic>> toolDataMap,
  }) async {
    try {
      await _toolDataService.batchSaveToolData(
        encounterId: encounterId,
        toolDataMap: toolDataMap,
      );
    } catch (e) {
      throw Exception('Failed to save encounter tool data: $e');
    }
  }

  // 复制问诊（创建基于现有问诊的新问诊）
  Future<Encounter> copyEncounter({
    required String sourceEncounterId,
    required String patientId,
    required String providerId,
    required String clinicId,
    bool copyToolData = false,
  }) async {
    try {
      final sourceEncounter = await getEncounter(sourceEncounterId);
      if (sourceEncounter == null) {
        throw Exception('Source encounter not found');
      }

      // 创建新问诊
      final newEncounter = await createEncounter(
        patientId: patientId,
        providerId: providerId,
        clinicId: clinicId,
        departmentId: sourceEncounter.departmentId,
        examType: sourceEncounter.examType,
        chiefComplaint: sourceEncounter.chiefComplaint,
        notes: sourceEncounter.notes,
        metadata: Map<String, dynamic>.from(sourceEncounter.metadata),
      );

      // 如果需要，复制工具数据
      if (copyToolData) {
        final sourceToolData = await _toolDataService.getEncounterToolData(sourceEncounterId);
        
        for (final toolData in sourceToolData) {
          await _toolDataService.saveToolData(
            encounterId: newEncounter.id,
            toolId: toolData.toolId,
            data: toolData.data,
          );
        }
      }

      return newEncounter;
    } catch (e) {
      throw Exception('Failed to copy encounter: $e');
    }
  }

  // 获取问诊统计
  Future<Map<String, dynamic>> getEncounterStats({
    String? clinicId,
    String? departmentId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      var query = _supabase.from('encounters').select('status');

      if (clinicId != null) query = query.eq('clinic_id', clinicId);
      if (departmentId != null) query = query.eq('department_id', departmentId);
      if (fromDate != null) {
        query = query.gte('visit_date', fromDate.toIso8601String());
      }
      if (toDate != null) {
        query = query.lte('visit_date', toDate.toIso8601String());
      }

      final allEncounters = await query;
      final encounters = allEncounters as List;
      
      final total = encounters.length;
      final active = encounters.where((e) => e['status'] == 'active').length;
      final completed = encounters.where((e) => e['status'] == 'completed').length;
      final cancelled = encounters.where((e) => e['status'] == 'cancelled').length;

      return {
        'total': total,
        'active': active,
        'completed': completed,
        'cancelled': cancelled,
      };
    } catch (e) {
      throw Exception('Failed to get encounter stats: $e');
    }
  }

  // 搜索问诊
  Future<List<Encounter>> searchEncounters({
    required String query,
    String? clinicId,
    String? departmentId,
    int limit = 20,
  }) async {
    try {
      var searchQuery = _supabase
          .from('encounters')
          .select()
          .or('chief_complaint.ilike.%$query%,notes.ilike.%$query%,exam_type.ilike.%$query%');

      if (clinicId != null) searchQuery = searchQuery.eq('clinic_id', clinicId);
      if (departmentId != null) searchQuery = searchQuery.eq('department_id', departmentId);

      final response = await searchQuery
          .order('visit_date', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => Encounter.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search encounters: $e');
    }
  }
}
