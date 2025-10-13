class MedicalAnswer {
  final String id;
  final String patientId;
  final String questionId;
  final String answerText;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicalAnswer({
    required this.id,
    required this.patientId,
    required this.questionId,
    required this.answerText,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicalAnswer.fromJson(Map<String, dynamic> json) => MedicalAnswer(
    id: json['id'] as String,
    patientId: json['patient_id'] as String,
    questionId: json['question_id'] as String,
    answerText: json['answer_text'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_id': patientId,
    'question_id': questionId,
    'answer_text': answerText,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  MedicalAnswer copyWith({
    String? id,
    String? patientId,
    String? questionId,
    String? answerText,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MedicalAnswer(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    questionId: questionId ?? this.questionId,
    answerText: answerText ?? this.answerText,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
