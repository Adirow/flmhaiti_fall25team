class EncounterTool {
  final String id;
  final String code;
  final String name;
  final String? description;
  final String? iconName;
  final String? componentPath;
  final bool isUniversal;
  final Map<String, dynamic> config;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EncounterTool({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.iconName,
    this.componentPath,
    required this.isUniversal,
    required this.config,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EncounterTool.fromJson(Map<String, dynamic> json) => EncounterTool(
        id: json['id'] as String,
        code: json['code'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        iconName: json['icon_name'] as String?,
        componentPath: json['component_path'] as String?,
        isUniversal: json['is_universal'] as bool? ?? false,
        config: Map<String, dynamic>.from(json['config'] as Map? ?? {}),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'description': description,
        'icon_name': iconName,
        'component_path': componentPath,
        'is_universal': isUniversal,
        'config': config,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  EncounterTool copyWith({
    String? id,
    String? code,
    String? name,
    String? description,
    String? iconName,
    String? componentPath,
    bool? isUniversal,
    Map<String, dynamic>? config,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      EncounterTool(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        description: description ?? this.description,
        iconName: iconName ?? this.iconName,
        componentPath: componentPath ?? this.componentPath,
        isUniversal: isUniversal ?? this.isUniversal,
        config: config ?? this.config,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncounterTool &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'EncounterTool(id: $id, code: $code, name: $name)';
}
