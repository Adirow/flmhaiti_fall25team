class DepartmentTool {
  final String id;
  final String departmentId;
  final String toolId;
  final int displayOrder;
  final bool isRequired;
  final Map<String, dynamic> toolConfig;
  final DateTime createdAt;

  const DepartmentTool({
    required this.id,
    required this.departmentId,
    required this.toolId,
    required this.displayOrder,
    required this.isRequired,
    required this.toolConfig,
    required this.createdAt,
  });

  factory DepartmentTool.fromJson(Map<String, dynamic> json) => DepartmentTool(
        id: json['id'] as String,
        departmentId: json['department_id'] as String,
        toolId: json['tool_id'] as String,
        displayOrder: json['display_order'] as int? ?? 0,
        isRequired: json['is_required'] as bool? ?? false,
        toolConfig: Map<String, dynamic>.from(json['tool_config'] as Map? ?? {}),
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'department_id': departmentId,
        'tool_id': toolId,
        'display_order': displayOrder,
        'is_required': isRequired,
        'tool_config': toolConfig,
        'created_at': createdAt.toIso8601String(),
      };

  DepartmentTool copyWith({
    String? id,
    String? departmentId,
    String? toolId,
    int? displayOrder,
    bool? isRequired,
    Map<String, dynamic>? toolConfig,
    DateTime? createdAt,
  }) =>
      DepartmentTool(
        id: id ?? this.id,
        departmentId: departmentId ?? this.departmentId,
        toolId: toolId ?? this.toolId,
        displayOrder: displayOrder ?? this.displayOrder,
        isRequired: isRequired ?? this.isRequired,
        toolConfig: toolConfig ?? this.toolConfig,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepartmentTool &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'DepartmentTool(id: $id, departmentId: $departmentId, toolId: $toolId)';
}
