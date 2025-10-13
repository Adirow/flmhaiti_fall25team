class ProgressNote {
  final String id;
  final String encounterId;
  final String anesthesiaType;
  final String dose;
  final String materialsUsed;
  final String complications;
  final String followUpPlan;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProgressNote({
    required this.id,
    required this.encounterId,
    required this.anesthesiaType,
    required this.dose,
    required this.materialsUsed,
    required this.complications,
    required this.followUpPlan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProgressNote.fromJson(Map<String, dynamic> json) => ProgressNote(
    id: json['id'] as String,
    encounterId: json['encounter_id'] as String,
    anesthesiaType: json['anesthesia_type'] as String? ?? '',
    dose: json['dose'] as String? ?? '',
    materialsUsed: json['materials_used'] as String? ?? '',
    complications: json['complications'] as String? ?? '',
    followUpPlan: json['follow_up_plan'] as String? ?? '',
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'encounter_id': encounterId,
    'anesthesia_type': anesthesiaType,
    'dose': dose,
    'materials_used': materialsUsed,
    'complications': complications,
    'follow_up_plan': followUpPlan,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  ProgressNote copyWith({
    String? id,
    String? encounterId,
    String? anesthesiaType,
    String? dose,
    String? materialsUsed,
    String? complications,
    String? followUpPlan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProgressNote(
    id: id ?? this.id,
    encounterId: encounterId ?? this.encounterId,
    anesthesiaType: anesthesiaType ?? this.anesthesiaType,
    dose: dose ?? this.dose,
    materialsUsed: materialsUsed ?? this.materialsUsed,
    complications: complications ?? this.complications,
    followUpPlan: followUpPlan ?? this.followUpPlan,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
