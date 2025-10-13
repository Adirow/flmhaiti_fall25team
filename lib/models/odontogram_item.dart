class OdontogramItem {
  final String id;
  final String encounterId;
  final String toothCode;
  final List<String> diagnoses;
  final List<String> treatmentPlan;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  OdontogramItem({
    required this.id,
    required this.encounterId,
    required this.toothCode,
    required this.diagnoses,
    required this.treatmentPlan,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OdontogramItem.fromJson(Map<String, dynamic> json) => OdontogramItem(
    id: json['id'] as String,
    encounterId: json['encounter_id'] as String,
    toothCode: json['tooth_code'] as String,
    diagnoses: List<String>.from(json['diagnoses'] as List? ?? []),
    treatmentPlan: List<String>.from(json['treatment_plan'] as List? ?? []),
    notes: json['notes'] as String? ?? '',
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'encounter_id': encounterId,
    'tooth_code': toothCode,
    'diagnoses': diagnoses,
    'treatment_plan': treatmentPlan,
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  OdontogramItem copyWith({
    String? id,
    String? encounterId,
    String? toothCode,
    List<String>? diagnoses,
    List<String>? treatmentPlan,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OdontogramItem(
    id: id ?? this.id,
    encounterId: encounterId ?? this.encounterId,
    toothCode: toothCode ?? this.toothCode,
    diagnoses: diagnoses ?? this.diagnoses,
    treatmentPlan: treatmentPlan ?? this.treatmentPlan,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
