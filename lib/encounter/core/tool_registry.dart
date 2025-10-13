import 'package:flutter/foundation.dart';
import 'interfaces.dart';

class ToolRegistry {
  static final Map<String, ToolFactory> _tools = {};
  static final Map<String, ToolMetadata> _metadata = {};

  // 注册工具
  static void registerTool(
    String toolId,
    ToolFactory factory,
    ToolMetadata metadata,
  ) {
    _tools[toolId] = factory;
    _metadata[toolId] = metadata;
    
    if (kDebugMode) {
      print('Registered tool: $toolId');
    }
  }

  // 创建工具实例
  static IEncounterTool? createTool(String toolId, ToolConfig config) {
    final factory = _tools[toolId];
    if (factory == null) {
      if (kDebugMode) {
        print('Tool not found: $toolId');
      }
      return null;
    }
    
    try {
      return factory(config);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating tool $toolId: $e');
      }
      return null;
    }
  }

  // 获取工具元数据
  static ToolMetadata? getToolMetadata(String toolId) {
    return _metadata[toolId];
  }

  // 获取所有可用工具
  static List<String> getAvailableTools() => _tools.keys.toList();

  // 获取通用工具
  static List<String> getUniversalTools() {
    return _metadata.entries
        .where((entry) => entry.value.isUniversal)
        .map((entry) => entry.key)
        .toList();
  }

  // 获取专属工具
  static List<String> getSpecializedTools() {
    return _metadata.entries
        .where((entry) => !entry.value.isUniversal)
        .map((entry) => entry.key)
        .toList();
  }

  // 检查工具是否存在
  static bool hasTool(String toolId) => _tools.containsKey(toolId);

  // 取消注册工具（主要用于测试）
  static void unregisterTool(String toolId) {
    _tools.remove(toolId);
    _metadata.remove(toolId);
    
    if (kDebugMode) {
      print('Unregistered tool: $toolId');
    }
  }

  // 清空所有注册（主要用于测试）
  static void clear() {
    _tools.clear();
    _metadata.clear();
    
    if (kDebugMode) {
      print('Cleared all tool registrations');
    }
  }

  // 获取工具统计信息
  static Map<String, dynamic> getStats() {
    final universalCount = getUniversalTools().length;
    final specializedCount = getSpecializedTools().length;
    
    return {
      'total_tools': _tools.length,
      'universal_tools': universalCount,
      'specialized_tools': specializedCount,
      'registered_tools': _tools.keys.toList(),
    };
  }
}
