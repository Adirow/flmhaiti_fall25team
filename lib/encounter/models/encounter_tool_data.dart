class EncounterToolData {
  final String id;
  final String encounterId;
  final String toolId;
  final Map<String, dynamic> data;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EncounterToolData({
    required this.id,
    required this.encounterId,
    required this.toolId,
    required this.data,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EncounterToolData.fromJson(Map<String, dynamic> json) =>
      EncounterToolData(
        id: json['id'] as String,
        encounterId: json['encounter_id'] as String,
        toolId: json['tool_id'] as String,
        data: Map<String, dynamic>.from(json['data'] as Map),
        version: json['version'] as int? ?? 1,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'encounter_id': encounterId,
        'tool_id': toolId,
        'data': data,
        'version': version,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  EncounterToolData copyWith({
    String? id,
    String? encounterId,
    String? toolId,
    Map<String, dynamic>? data,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      EncounterToolData(
        id: id ?? this.id,
        encounterId: encounterId ?? this.encounterId,
        toolId: toolId ?? this.toolId,
        data: data ?? this.data,
        version: version ?? this.version,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncounterToolData &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'EncounterToolData(id: $id, encounterId: $encounterId, toolId: $toolId)';
}
