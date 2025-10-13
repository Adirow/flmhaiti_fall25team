class Encounter {
  final String id;
  final String patientId;
  final String providerId;
  final String clinicId;
  final String? departmentId;  // 新增科室ID
  final String examType;
  final String chiefComplaint;
  final String notes;
  final DateTime visitDate;
  final String status;  // 新增状态字段
  final Map<String, dynamic> metadata;  // 新增元数据字段
  final DateTime createdAt;
  final DateTime updatedAt;

  Encounter({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.clinicId,
    this.departmentId,
    required this.examType,
    required this.chiefComplaint,
    required this.notes,
    required this.visitDate,
    required this.status,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Encounter.fromJson(Map<String, dynamic> json) => Encounter(
    id: json['id'] as String,
    patientId: json['patient_id'] as String,
    providerId: json['provider_id'] as String,
    clinicId: json['clinic_id'] as String,
    departmentId: json['department_id'] as String?,
    examType: json['exam_type'] as String,
    chiefComplaint: json['chief_complaint'] as String,
    notes: json['notes'] as String? ?? '',
    visitDate: DateTime.parse(json['visit_date'] as String),
    status: json['status'] as String? ?? 'active',
    metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_id': patientId,
    'provider_id': providerId,
    'clinic_id': clinicId,
    'department_id': departmentId,
    'exam_type': examType,
    'chief_complaint': chiefComplaint,
    'notes': notes,
    'visit_date': visitDate.toIso8601String(),
    'status': status,
    'metadata': metadata,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  Encounter copyWith({
    String? id,
    String? patientId,
    String? providerId,
    String? clinicId,
    String? departmentId,
    String? examType,
    String? chiefComplaint,
    String? notes,
    DateTime? visitDate,
    String? status,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Encounter(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    providerId: providerId ?? this.providerId,
    clinicId: clinicId ?? this.clinicId,
    departmentId: departmentId ?? this.departmentId,
    examType: examType ?? this.examType,
    chiefComplaint: chiefComplaint ?? this.chiefComplaint,
    notes: notes ?? this.notes,
    visitDate: visitDate ?? this.visitDate,
    status: status ?? this.status,
    metadata: metadata ?? this.metadata,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
