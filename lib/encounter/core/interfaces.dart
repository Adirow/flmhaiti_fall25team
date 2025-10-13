import 'package:flutter/material.dart';
import 'encounter_context.dart';

// 工具接口定义
abstract class IEncounterTool {
  String get toolId;
  String get displayName;
  IconData get icon;
  bool get isUniversal;
  
  Widget buildWidget(EncounterContext context);
  Future<Map<String, dynamic>> saveData();
  Future<void> loadData(Map<String, dynamic> data);
  bool validateData();
  
  // 生命周期方法
  void onActivated(EncounterContext context) {}
  void onDeactivated(EncounterContext context) {}
  void dispose() {}
}

// 科室接口定义
abstract class IDepartment {
  String get departmentId;
  String get displayName;
  List<String> get availableToolIds;
  List<String> get examTypes;
  
  Widget? buildCustomHeader(EncounterContext context) => null;
  Map<String, dynamic> getDefaultMetadata() => {};
  
  // 科室特定的验证逻辑
  bool validateEncounter(EncounterContext context) => true;
  
  // 科室特定的工具配置
  Map<String, dynamic> getToolConfig(String toolId) => {};
}

// 工具配置类
class ToolConfig {
  final String toolId;
  final Map<String, dynamic> config;
  final bool isRequired;
  final int displayOrder;

  const ToolConfig({
    required this.toolId,
    required this.config,
    this.isRequired = false,
    this.displayOrder = 0,
  });

  factory ToolConfig.fromJson(Map<String, dynamic> json) => ToolConfig(
        toolId: json['tool_id'] as String,
        config: Map<String, dynamic>.from(json['config'] as Map? ?? {}),
        isRequired: json['is_required'] as bool? ?? false,
        displayOrder: json['display_order'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'tool_id': toolId,
        'config': config,
        'is_required': isRequired,
        'display_order': displayOrder,
      };
}

// 工厂接口
typedef ToolFactory = IEncounterTool Function(ToolConfig config);
typedef DepartmentFactory = IDepartment Function();

// 工具状态枚举
enum ToolStatus {
  inactive,
  active,
  loading,
  error,
}

// 工具元数据
class ToolMetadata {
  final String toolId;
  final String name;
  final String? description;
  final IconData icon;
  final bool isUniversal;
  final ToolStatus status;

  const ToolMetadata({
    required this.toolId,
    required this.name,
    this.description,
    required this.icon,
    required this.isUniversal,
    this.status = ToolStatus.inactive,
  });

  ToolMetadata copyWith({
    String? toolId,
    String? name,
    String? description,
    IconData? icon,
    bool? isUniversal,
    ToolStatus? status,
  }) =>
      ToolMetadata(
        toolId: toolId ?? this.toolId,
        name: name ?? this.name,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        isUniversal: isUniversal ?? this.isUniversal,
        status: status ?? this.status,
      );
}
