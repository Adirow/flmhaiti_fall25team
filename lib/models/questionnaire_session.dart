import 'package:dental_roots/models/form_template.dart';

enum SessionStatus { inProgress, submitted, archived }

class QuestionnaireSession {
  final String id;
  final String patientId;
  final String templateId;
  final String templateName;
  final int templateVersion;
  final Department department;
  final SessionStatus status;
  final DateTime startedAt;
  final DateTime? submittedAt;
  final String createdBy;
  final String clinicId;

  QuestionnaireSession({
    required this.id,
    required this.patientId,
    required this.templateId,
    required this.templateName,
    required this.templateVersion,
    required this.department,
    required this.status,
    required this.startedAt,
    this.submittedAt,
    required this.createdBy,
    required this.clinicId,
  });

  factory QuestionnaireSession.fromJson(Map<String, dynamic> json) {
    return QuestionnaireSession(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      templateId: json['template_id'] as String,
      templateName: json['template_name'] as String,
      templateVersion: json['template_version'] as int,
      department: Department.values.firstWhere((e) => e.name == json['department']),
      status: _parseStatus(json['status'] as String),
      startedAt: DateTime.parse(json['started_at'] as String),
      submittedAt: json['submitted_at'] != null 
          ? DateTime.parse(json['submitted_at'] as String) 
          : null,
      createdBy: json['created_by'] as String,
      clinicId: json['clinic_id'] as String,
    );
  }

  static SessionStatus _parseStatus(String statusString) {
    switch (statusString) {
      case 'in_progress':
        return SessionStatus.inProgress;
      case 'submitted':
        return SessionStatus.submitted;
      case 'archived':
        return SessionStatus.archived;
      default:
        return SessionStatus.inProgress; // Default fallback
    }
  }

  static String _statusToString(SessionStatus status) {
    switch (status) {
      case SessionStatus.inProgress:
        return 'in_progress';
      case SessionStatus.submitted:
        return 'submitted';
      case SessionStatus.archived:
        return 'archived';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'template_id': templateId,
      'template_name': templateName,
      'template_version': templateVersion,
      'department': department.name,
      'status': _statusToString(status),
      'started_at': startedAt.toIso8601String(),
      'submitted_at': submittedAt?.toIso8601String(),
      'created_by': createdBy,
      'clinic_id': clinicId,
    };
  }

  QuestionnaireSession copyWith({
    String? id,
    String? patientId,
    String? templateId,
    String? templateName,
    int? templateVersion,
    Department? department,
    SessionStatus? status,
    DateTime? startedAt,
    DateTime? submittedAt,
    String? createdBy,
    String? clinicId,
  }) {
    return QuestionnaireSession(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      templateId: templateId ?? this.templateId,
      templateName: templateName ?? this.templateName,
      templateVersion: templateVersion ?? this.templateVersion,
      department: department ?? this.department,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      submittedAt: submittedAt ?? this.submittedAt,
      createdBy: createdBy ?? this.createdBy,
      clinicId: clinicId ?? this.clinicId,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case SessionStatus.inProgress:
        return 'In Progress';
      case SessionStatus.submitted:
        return 'Submitted';
      case SessionStatus.archived:
        return 'Archived';
    }
  }

  String get departmentDisplayName {
    switch (department) {
      case Department.dental:
        return 'Dental';
      case Department.obgyn:
        return 'OB/GYN';
      case Department.general:
        return 'General';
    }
  }

  bool get isCompleted => status == SessionStatus.submitted;
  bool get isInProgress => status == SessionStatus.inProgress;
  bool get isArchived => status == SessionStatus.archived;

  Duration get duration {
    final endTime = submittedAt ?? DateTime.now();
    return endTime.difference(startedAt);
  }
}

class QuestionnaireAnswer {
  final String id;
  final String sessionId;
  final String questionLogicalId;
  final String questionLabel;
  final QuestionType questionType;
  final dynamic answerValue;
  final DateTime answeredAt;

  QuestionnaireAnswer({
    required this.id,
    required this.sessionId,
    required this.questionLogicalId,
    required this.questionLabel,
    required this.questionType,
    this.answerValue,
    required this.answeredAt,
  });

  factory QuestionnaireAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionnaireAnswer(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      questionLogicalId: json['question_logical_id'] as String,
      questionLabel: json['question_label'] as String,
      questionType: QuestionType.values.firstWhere((e) => e.name == json['question_type']),
      answerValue: json['answer_value'],
      answeredAt: DateTime.parse(json['answered_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'question_logical_id': questionLogicalId,
      'question_label': questionLabel,
      'question_type': questionType.name,
      'answer_value': answerValue,
      'answered_at': answeredAt.toIso8601String(),
    };
  }

  QuestionnaireAnswer copyWith({
    String? id,
    String? sessionId,
    String? questionLogicalId,
    String? questionLabel,
    QuestionType? questionType,
    dynamic answerValue,
    DateTime? answeredAt,
  }) {
    return QuestionnaireAnswer(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      questionLogicalId: questionLogicalId ?? this.questionLogicalId,
      questionLabel: questionLabel ?? this.questionLabel,
      questionType: questionType ?? this.questionType,
      answerValue: answerValue ?? this.answerValue,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  String get displayValue {
    if (answerValue == null) return 'No answer';
    
    switch (questionType) {
      case QuestionType.boolean:
        return answerValue == true ? 'Yes' : 'No';
      case QuestionType.text:
        return answerValue.toString();
      case QuestionType.number:
        return answerValue.toString();
      case QuestionType.date:
        if (answerValue is String) {
          try {
            final date = DateTime.parse(answerValue);
            return '${date.day}/${date.month}/${date.year}';
          } catch (e) {
            return answerValue.toString();
          }
        }
        return answerValue.toString();
      case QuestionType.choice:
        return answerValue.toString();
      case QuestionType.multichoice:
        if (answerValue is List) {
          return (answerValue as List).join(', ');
        }
        return answerValue.toString();
    }
  }

  bool get hasAnswer => answerValue != null && answerValue.toString().isNotEmpty;
}

class QuestionnaireSessionSummary {
  final QuestionnaireSession session;
  final int answeredQuestions;
  final int completedQuestions;
  final String? patientName;
  final String? patientPhone;

  QuestionnaireSessionSummary({
    required this.session,
    required this.answeredQuestions,
    required this.completedQuestions,
    this.patientName,
    this.patientPhone,
  });

  factory QuestionnaireSessionSummary.fromJson(Map<String, dynamic> json) {
    return QuestionnaireSessionSummary(
      session: QuestionnaireSession.fromJson(json),
      answeredQuestions: json['answered_questions'] as int? ?? 0,
      completedQuestions: json['completed_questions'] as int? ?? 0,
      patientName: json['patient_name'] as String?,
      patientPhone: json['patient_phone'] as String?,
    );
  }

  double get completionPercentage {
    if (answeredQuestions == 0) return 0.0;
    return (completedQuestions / answeredQuestions) * 100;
  }

  bool get isFullyCompleted => answeredQuestions > 0 && completedQuestions == answeredQuestions;
}
