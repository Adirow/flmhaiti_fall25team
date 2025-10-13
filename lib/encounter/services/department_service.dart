import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/department.dart';
import '../models/department_tool.dart';
import '../models/encounter_tool.dart';

class DepartmentService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 获取所有活跃科室
  Future<List<Department>> getDepartments() async {
    try {
      final response = await _supabase
          .from('departments')
          .select()
          .eq('is_active', true)
          .order('name');

      return (response as List)
          .map((json) => Department.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch departments: $e');
    }
  }

  // 根据ID获取科室
  Future<Department?> getDepartmentById(String departmentId) async {
    try {
      final response = await _supabase
          .from('departments')
          .select()
          .eq('id', departmentId)
          .eq('is_active', true)
          .maybeSingle();

      return response != null ? Department.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to fetch department: $e');
    }
  }

  // 根据代码获取科室
  Future<Department?> getDepartmentByCode(String code) async {
    try {
      final response = await _supabase
          .from('departments')
          .select()
          .eq('code', code)
          .eq('is_active', true)
          .maybeSingle();

      return response != null ? Department.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to fetch department by code: $e');
    }
  }

  // 获取科室的工具配置
  Future<List<DepartmentTool>> getDepartmentTools(String departmentId) async {
    try {
      final response = await _supabase
          .from('department_tools')
          .select()
          .eq('department_id', departmentId)
          .order('display_order');

      return (response as List)
          .map((json) => DepartmentTool.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch department tools: $e');
    }
  }

  // 获取科室的工具详情（包含工具信息）
  Future<List<Map<String, dynamic>>> getDepartmentToolsWithDetails(
      String departmentId) async {
    try {
      final response = await _supabase
          .from('department_tools')
          .select('''
            *,
            encounter_tools (
              id,
              code,
              name,
              description,
              icon_name,
              component_path,
              is_universal,
              config
            )
          ''')
          .eq('department_id', departmentId)
          .order('display_order');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch department tools with details: $e');
    }
  }

  // 获取所有工具
  Future<List<EncounterTool>> getAllTools() async {
    try {
      final response = await _supabase
          .from('encounter_tools')
          .select()
          .order('name');

      return (response as List)
          .map((json) => EncounterTool.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch tools: $e');
    }
  }

  // 获取通用工具
  Future<List<EncounterTool>> getUniversalTools() async {
    try {
      final response = await _supabase
          .from('encounter_tools')
          .select()
          .eq('is_universal', true)
          .order('name');

      return (response as List)
          .map((json) => EncounterTool.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch universal tools: $e');
    }
  }

  // 根据代码获取工具
  Future<EncounterTool?> getToolByCode(String code) async {
    try {
      final response = await _supabase
          .from('encounter_tools')
          .select()
          .eq('code', code)
          .maybeSingle();

      return response != null ? EncounterTool.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to fetch tool by code: $e');
    }
  }

  // 创建科室
  Future<Department> createDepartment({
    required String code,
    required String name,
    String? description,
  }) async {
    try {
      final response = await _supabase
          .from('departments')
          .insert({
            'code': code,
            'name': name,
            'description': description,
            'is_active': true,
          })
          .select()
          .single();

      return Department.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create department: $e');
    }
  }

  // 创建工具
  Future<EncounterTool> createTool({
    required String code,
    required String name,
    String? description,
    String? iconName,
    String? componentPath,
    bool isUniversal = false,
    Map<String, dynamic>? config,
  }) async {
    try {
      final response = await _supabase
          .from('encounter_tools')
          .insert({
            'code': code,
            'name': name,
            'description': description,
            'icon_name': iconName,
            'component_path': componentPath,
            'is_universal': isUniversal,
            'config': config ?? {},
          })
          .select()
          .single();

      return EncounterTool.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create tool: $e');
    }
  }

  // 关联工具到科室
  Future<DepartmentTool> addToolToDepartment({
    required String departmentId,
    required String toolId,
    int displayOrder = 0,
    bool isRequired = false,
    Map<String, dynamic>? toolConfig,
  }) async {
    try {
      final response = await _supabase
          .from('department_tools')
          .insert({
            'department_id': departmentId,
            'tool_id': toolId,
            'display_order': displayOrder,
            'is_required': isRequired,
            'tool_config': toolConfig ?? {},
          })
          .select()
          .single();

      return DepartmentTool.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add tool to department: $e');
    }
  }

  // 移除科室的工具
  Future<void> removeToolFromDepartment({
    required String departmentId,
    required String toolId,
  }) async {
    try {
      await _supabase
          .from('department_tools')
          .delete()
          .eq('department_id', departmentId)
          .eq('tool_id', toolId);
    } catch (e) {
      throw Exception('Failed to remove tool from department: $e');
    }
  }

  // 更新科室工具配置
  Future<DepartmentTool> updateDepartmentTool({
    required String departmentId,
    required String toolId,
    int? displayOrder,
    bool? isRequired,
    Map<String, dynamic>? toolConfig,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (displayOrder != null) updateData['display_order'] = displayOrder;
      if (isRequired != null) updateData['is_required'] = isRequired;
      if (toolConfig != null) updateData['tool_config'] = toolConfig;

      final response = await _supabase
          .from('department_tools')
          .update(updateData)
          .eq('department_id', departmentId)
          .eq('tool_id', toolId)
          .select()
          .single();

      return DepartmentTool.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update department tool: $e');
    }
  }
}
