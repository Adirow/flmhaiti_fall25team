enum QuestionType { text, boolean, multipleChoice }

class MedicalQuestion {
  final String id;
  final String clinicId;
  final String questionText;
  final QuestionType questionType;
  final List<String>? options;
  final bool isActive;
  final int displayOrder;
  final DateTime createdAt;

  MedicalQuestion({
    required this.id,
    required this.clinicId,
    required this.questionText,
    required this.questionType,
    this.options,
    required this.isActive,
    required this.displayOrder,
    required this.createdAt,
  });

  factory MedicalQuestion.fromJson(Map<String, dynamic> json) => MedicalQuestion(
    id: json['id'] as String,
    clinicId: json['clinic_id'] as String,
    questionText: json['question_text'] as String,
    questionType: QuestionType.values.firstWhere((e) => e.name == json['question_type']),
    options: json['options'] != null ? List<String>.from(json['options'] as List) : null,
    isActive: json['is_active'] as bool? ?? true,
    displayOrder: json['display_order'] as int,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'clinic_id': clinicId,
    'question_text': questionText,
    'question_type': questionType.name,
    'options': options,
    'is_active': isActive,
    'display_order': displayOrder,
    'created_at': createdAt.toIso8601String(),
  };

  MedicalQuestion copyWith({
    String? id,
    String? clinicId,
    String? questionText,
    QuestionType? questionType,
    List<String>? options,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
  }) => MedicalQuestion(
    id: id ?? this.id,
    clinicId: clinicId ?? this.clinicId,
    questionText: questionText ?? this.questionText,
    questionType: questionType ?? this.questionType,
    options: options ?? this.options,
    isActive: isActive ?? this.isActive,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
  );
}
