class MedicalHistoryCore {
  final String id;
  final String patientId;
  final String allergies;
  final bool hasDiabetes;
  final bool hasHeartIssues;
  final bool isPregnant;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicalHistoryCore({
    required this.id,
    required this.patientId,
    required this.allergies,
    required this.hasDiabetes,
    required this.hasHeartIssues,
    required this.isPregnant,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicalHistoryCore.fromJson(Map<String, dynamic> json) => MedicalHistoryCore(
    id: json['id'] as String,
    patientId: json['patient_id'] as String,
    allergies: json['allergies'] as String? ?? '',
    hasDiabetes: json['has_diabetes'] as bool? ?? false,
    hasHeartIssues: json['has_heart_issues'] as bool? ?? false,
    isPregnant: json['is_pregnant'] as bool? ?? false,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_id': patientId,
    'allergies': allergies,
    'has_diabetes': hasDiabetes,
    'has_heart_issues': hasHeartIssues,
    'is_pregnant': isPregnant,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  MedicalHistoryCore copyWith({
    String? id,
    String? patientId,
    String? allergies,
    bool? hasDiabetes,
    bool? hasHeartIssues,
    bool? isPregnant,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MedicalHistoryCore(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    allergies: allergies ?? this.allergies,
    hasDiabetes: hasDiabetes ?? this.hasDiabetes,
    hasHeartIssues: hasHeartIssues ?? this.hasHeartIssues,
    isPregnant: isPregnant ?? this.isPregnant,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
