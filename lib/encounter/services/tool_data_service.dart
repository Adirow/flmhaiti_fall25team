import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/encounter_tool_data.dart';

class ToolDataService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 保存工具数据
  Future<EncounterToolData> saveToolData({
    required String encounterId,
    required String toolId,
    required Map<String, dynamic> data,
    int version = 1,
  }) async {
    try {
      // 首先检查是否已存在该工具的数据
      final existing = await _supabase
          .from('encounter_tool_data')
          .select()
          .eq('encounter_id', encounterId)
          .eq('tool_id', toolId)
          .maybeSingle();

      Map<String, dynamic> response;

      if (existing != null) {
        // 更新现有数据
        response = await _supabase
            .from('encounter_tool_data')
            .update({
              'data': data,
              'version': version,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('encounter_id', encounterId)
            .eq('tool_id', toolId)
            .select()
            .single();
      } else {
        // 创建新数据
        response = await _supabase
            .from('encounter_tool_data')
            .insert({
              'encounter_id': encounterId,
              'tool_id': toolId,
              'data': data,
              'version': version,
            })
            .select()
            .single();
      }

      return EncounterToolData.fromJson(response);
    } catch (e) {
      throw Exception('Failed to save tool data: $e');
    }
  }

  // 获取工具数据
  Future<EncounterToolData?> getToolData({
    required String encounterId,
    required String toolId,
  }) async {
    try {
      final response = await _supabase
          .from('encounter_tool_data')
          .select()
          .eq('encounter_id', encounterId)
          .eq('tool_id', toolId)
          .order('version', ascending: false)
          .limit(1)
          .maybeSingle();

      return response != null ? EncounterToolData.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to get tool data: $e');
    }
  }

  // 获取问诊的所有工具数据
  Future<List<EncounterToolData>> getEncounterToolData(String encounterId) async {
    try {
      final response = await _supabase
          .from('encounter_tool_data')
          .select()
          .eq('encounter_id', encounterId)
          .order('created_at');

      return (response as List)
          .map((json) => EncounterToolData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get encounter tool data: $e');
    }
  }

  // 获取工具数据的历史版本
  Future<List<EncounterToolData>> getToolDataHistory({
    required String encounterId,
    required String toolId,
  }) async {
    try {
      final response = await _supabase
          .from('encounter_tool_data')
          .select()
          .eq('encounter_id', encounterId)
          .eq('tool_id', toolId)
          .order('version', ascending: false);

      return (response as List)
          .map((json) => EncounterToolData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tool data history: $e');
    }
  }

  // 删除工具数据
  Future<void> deleteToolData({
    required String encounterId,
    required String toolId,
  }) async {
    try {
      await _supabase
          .from('encounter_tool_data')
          .delete()
          .eq('encounter_id', encounterId)
          .eq('tool_id', toolId);
    } catch (e) {
      throw Exception('Failed to delete tool data: $e');
    }
  }

  // 批量保存多个工具数据
  Future<List<EncounterToolData>> batchSaveToolData({
    required String encounterId,
    required Map<String, Map<String, dynamic>> toolDataMap,
  }) async {
    try {
      final results = <EncounterToolData>[];
      
      for (final entry in toolDataMap.entries) {
        final toolId = entry.key;
        final data = entry.value;
        
        final result = await saveToolData(
          encounterId: encounterId,
          toolId: toolId,
          data: data,
        );
        
        results.add(result);
      }
      
      return results;
    } catch (e) {
      throw Exception('Failed to batch save tool data: $e');
    }
  }

  // 获取工具数据摘要（不包含具体数据内容）
  Future<List<Map<String, dynamic>>> getToolDataSummary(String encounterId) async {
    try {
      final response = await _supabase
          .from('encounter_tool_data')
          .select('id, tool_id, version, created_at, updated_at')
          .eq('encounter_id', encounterId)
          .order('created_at');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get tool data summary: $e');
    }
  }

  // 检查工具数据是否存在
  Future<bool> hasToolData({
    required String encounterId,
    required String toolId,
  }) async {
    try {
      final response = await _supabase
          .from('encounter_tool_data')
          .select('id')
          .eq('encounter_id', encounterId)
          .eq('tool_id', toolId)
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check tool data existence: $e');
    }
  }

  // 复制工具数据到新问诊
  Future<EncounterToolData> copyToolData({
    required String sourceEncounterId,
    required String targetEncounterId,
    required String toolId,
  }) async {
    try {
      final sourceData = await getToolData(
        encounterId: sourceEncounterId,
        toolId: toolId,
      );

      if (sourceData == null) {
        throw Exception('Source tool data not found');
      }

      return await saveToolData(
        encounterId: targetEncounterId,
        toolId: toolId,
        data: sourceData.data,
      );
    } catch (e) {
      throw Exception('Failed to copy tool data: $e');
    }
  }

  // 获取工具使用统计
  Future<Map<String, dynamic>> getToolUsageStats(String toolId) async {
    try {
      final response = await _supabase
          .rpc('get_tool_usage_stats', params: {'tool_id_param': toolId});

      return Map<String, dynamic>.from(response ?? {});
    } catch (e) {
      // 如果 RPC 函数不存在，返回基本统计
      try {
        final response = await _supabase
            .from('encounter_tool_data')
            .select('id')
            .eq('tool_id', toolId);

        return {
          'usage_count': (response as List).length,
          'tool_id': toolId,
        };
      } catch (e2) {
        throw Exception('Failed to get tool usage stats: $e2');
      }
    }
  }
}
