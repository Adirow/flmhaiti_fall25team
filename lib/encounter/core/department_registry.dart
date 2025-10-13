import 'package:flutter/foundation.dart';
import 'interfaces.dart';

class DepartmentRegistry {
  static final Map<String, DepartmentFactory> _departments = {};
  static final Map<String, Map<String, ToolConfig>> _departmentToolConfigs = {};

  // 注册科室
  static void registerDepartment(
    String departmentId,
    DepartmentFactory factory, {
    Map<String, ToolConfig>? toolConfigs,
  }) {
    _departments[departmentId] = factory;
    
    if (toolConfigs != null) {
      _departmentToolConfigs[departmentId] = toolConfigs;
    }
    
    if (kDebugMode) {
      print('Registered department: $departmentId');
    }
  }

  // 创建科室实例
  static IDepartment? getDepartment(String departmentId) {
    final factory = _departments[departmentId];
    if (factory == null) {
      if (kDebugMode) {
        print('Department not found: $departmentId');
      }
      return null;
    }
    
    try {
      return factory();
    } catch (e) {
      if (kDebugMode) {
        print('Error creating department $departmentId: $e');
      }
      return null;
    }
  }

  // 获取科室的工具配置
  static List<ToolConfig> getDepartmentToolConfigs(String departmentId) {
    final configs = _departmentToolConfigs[departmentId];
    if (configs == null) return [];
    
    return configs.values.toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  // 获取科室的特定工具配置
  static ToolConfig? getToolConfig(String departmentId, String toolId) {
    return _departmentToolConfigs[departmentId]?[toolId];
  }

  // 添加工具配置到科室
  static void addToolConfig(
    String departmentId,
    String toolId,
    ToolConfig config,
  ) {
    _departmentToolConfigs.putIfAbsent(departmentId, () => {});
    _departmentToolConfigs[departmentId]![toolId] = config;
    
    if (kDebugMode) {
      print('Added tool config: $departmentId -> $toolId');
    }
  }

  // 移除科室的工具配置
  static void removeToolConfig(String departmentId, String toolId) {
    _departmentToolConfigs[departmentId]?.remove(toolId);
    
    if (kDebugMode) {
      print('Removed tool config: $departmentId -> $toolId');
    }
  }

  // 获取所有可用科室
  static List<String> getAvailableDepartments() => _departments.keys.toList();

  // 检查科室是否存在
  static bool hasDepartment(String departmentId) => 
      _departments.containsKey(departmentId);

  // 取消注册科室（主要用于测试）
  static void unregisterDepartment(String departmentId) {
    _departments.remove(departmentId);
    _departmentToolConfigs.remove(departmentId);
    
    if (kDebugMode) {
      print('Unregistered department: $departmentId');
    }
  }

  // 清空所有注册（主要用于测试）
  static void clear() {
    _departments.clear();
    _departmentToolConfigs.clear();
    
    if (kDebugMode) {
      print('Cleared all department registrations');
    }
  }

  // 获取科室统计信息
  static Map<String, dynamic> getStats() {
    final departmentStats = <String, Map<String, dynamic>>{};
    
    for (final departmentId in _departments.keys) {
      final toolConfigs = _departmentToolConfigs[departmentId] ?? {};
      departmentStats[departmentId] = {
        'tool_count': toolConfigs.length,
        'tools': toolConfigs.keys.toList(),
      };
    }
    
    return {
      'total_departments': _departments.length,
      'registered_departments': _departments.keys.toList(),
      'department_details': departmentStats,
    };
  }

  // 验证科室配置
  static bool validateDepartmentConfig(String departmentId) {
    if (!hasDepartment(departmentId)) return false;
    
    final department = getDepartment(departmentId);
    if (department == null) return false;
    
    final availableTools = department.availableToolIds;
    final configuredTools = _departmentToolConfigs[departmentId]?.keys.toList() ?? [];
    
    // 检查是否所有必需的工具都已配置
    for (final toolId in availableTools) {
      if (!configuredTools.contains(toolId)) {
        if (kDebugMode) {
          print('Missing tool config for $departmentId: $toolId');
        }
        return false;
      }
    }
    
    return true;
  }
}
