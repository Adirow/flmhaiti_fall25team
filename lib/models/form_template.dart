enum Department { dental, obgyn, general }

enum QuestionType { boolean, text, number, date, choice, multichoice }

class FormTemplate {
  final String id;
  final Department department;
  final String name;
  final int version;
  final String description;
  final bool isActive;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FormTemplate({
    required this.id,
    required this.department,
    required this.name,
    required this.version,
    required this.description,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory FormTemplate.fromJson(Map<String, dynamic> json) => FormTemplate(
    id: json['id'] as String,
    department: Department.values.firstWhere((e) => e.name == json['department']),
    name: json['name'] as String,
    version: json['version'] as int,
    description: json['description'] as String? ?? '',
    isActive: json['is_active'] as bool,
    createdBy: json['created_by'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] != null 
        ? DateTime.parse(json['updated_at'] as String) 
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'department': department.name,
    'name': name,
    'version': version,
    'description': description,
    'is_active': isActive,
    'created_by': createdBy,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  FormTemplate copyWith({
    String? id,
    Department? department,
    String? name,
    int? version,
    String? description,
    bool? isActive,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FormTemplate(
    id: id ?? this.id,
    department: department ?? this.department,
    name: name ?? this.name,
    version: version ?? this.version,
    description: description ?? this.description,
    isActive: isActive ?? this.isActive,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

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
}

class FormSection {
  final String id;
  final String templateId;
  final String title;
  final int sortOrder;
  final DateTime? createdAt;

  FormSection({
    required this.id,
    required this.templateId,
    required this.title,
    required this.sortOrder,
    this.createdAt,
  });

  factory FormSection.fromJson(Map<String, dynamic> json) => FormSection(
    id: json['id'] as String,
    templateId: json['template_id'] as String,
    title: json['title'] as String,
    sortOrder: json['sort_order'] as int,
    createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at'] as String) 
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'template_id': templateId,
    'title': title,
    'sort_order': sortOrder,
    'created_at': createdAt?.toIso8601String(),
  };

  FormSection copyWith({
    String? id,
    String? templateId,
    String? title,
    int? sortOrder,
    DateTime? createdAt,
  }) => FormSection(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    title: title ?? this.title,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
}

class FormQuestion {
  final String id;
  final String sectionId;
  final String logicalId;
  final String label;
  final QuestionType type;
  final Map<String, dynamic>? options;
  final bool required;
  final Map<String, dynamic>? visibleIf;
  final int sortOrder;
  final bool isActive;
  final DateTime? createdAt;

  FormQuestion({
    required this.id,
    required this.sectionId,
    required this.logicalId,
    required this.label,
    required this.type,
    this.options,
    required this.required,
    this.visibleIf,
    required this.sortOrder,
    required this.isActive,
    this.createdAt,
  });

  factory FormQuestion.fromJson(Map<String, dynamic> json) => FormQuestion(
    id: json['id'] as String,
    sectionId: json['section_id'] as String,
    logicalId: json['logical_id'] as String,
    label: json['label'] as String,
    type: QuestionType.values.firstWhere((e) => e.name == json['type']),
    options: json['options'] as Map<String, dynamic>?,
    required: json['required'] as bool,
    visibleIf: json['visible_if'] as Map<String, dynamic>?,
    sortOrder: json['sort_order'] as int,
    isActive: json['is_active'] as bool,
    createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at'] as String) 
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'section_id': sectionId,
    'logical_id': logicalId,
    'label': label,
    'type': type.name,
    'options': options,
    'required': required,
    'visible_if': visibleIf,
    'sort_order': sortOrder,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
  };

  FormQuestion copyWith({
    String? id,
    String? sectionId,
    String? logicalId,
    String? label,
    QuestionType? type,
    Map<String, dynamic>? options,
    bool? required,
    Map<String, dynamic>? visibleIf,
    int? sortOrder,
    bool? isActive,
    DateTime? createdAt,
  }) => FormQuestion(
    id: id ?? this.id,
    sectionId: sectionId ?? this.sectionId,
    logicalId: logicalId ?? this.logicalId,
    label: label ?? this.label,
    type: type ?? this.type,
    options: options ?? this.options,
    required: required ?? this.required,
    visibleIf: visibleIf ?? this.visibleIf,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );

  String get typeDisplayName {
    switch (type) {
      case QuestionType.boolean:
        return 'Yes/No';
      case QuestionType.text:
        return 'Text';
      case QuestionType.number:
        return 'Number';
      case QuestionType.date:
        return 'Date';
      case QuestionType.choice:
        return 'Single Choice';
      case QuestionType.multichoice:
        return 'Multiple Choice';
    }
  }

  List<String> get choiceOptions {
    if (options == null || options!['choices'] == null) return [];
    return List<String>.from(options!['choices'] as List);
  }
}
