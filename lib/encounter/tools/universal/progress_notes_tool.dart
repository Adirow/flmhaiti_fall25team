import 'package:flutter/material.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_utils.dart';

import '../../core/interfaces.dart';
import '../../core/encounter_context.dart';
import '../../core/base_tool_widget.dart';

class ProgressNotesTool implements IEncounterTool {
  final ToolConfig config;

  ProgressNotesTool({required this.config});

  @override
  String get toolId => 'progress_notes';

  @override
  String get displayName => 'Progress Notes';

  @override
  IconData get icon => Icons.edit_note;

  @override
  bool get isUniversal => true;

  @override
  Widget buildWidget(EncounterContext context) {
    return ProgressNotesWidget(
      context: context,
      config: config,
    );
  }

  @override
  Future<Map<String, dynamic>> saveData() async {
    // 这个方法在 BaseToolWidget 中会被调用
    throw UnimplementedError('saveData should be implemented in widget');
  }

  @override
  Future<void> loadData(Map<String, dynamic> data) async {
    // 这个方法在 BaseToolWidget 中会被调用
    throw UnimplementedError('loadData should be implemented in widget');
  }

  @override
  bool validateData() {
    // 这个方法在 BaseToolWidget 中会被调用
    throw UnimplementedError('validateData should be implemented in widget');
  }

  @override
  void onActivated(EncounterContext context) {
    // 工具激活时的逻辑
  }

  @override
  void onDeactivated(EncounterContext context) {
    // 工具停用时的逻辑
  }

  @override
  void dispose() {
    // 清理资源
  }
}

class ProgressNotesWidget extends BaseToolWidget {
  const ProgressNotesWidget({
    super.key,
    required super.context,
    required super.config,
  });

  @override
  ProgressNotesWidgetState createState() => ProgressNotesWidgetState();
}

class ProgressNoteSectionSnapshot {
  final String field;
  final String title;
  final String value;
  final bool required;

  const ProgressNoteSectionSnapshot({
    required this.field,
    required this.title,
    required this.value,
    this.required = false,
  });

  ProgressNoteSectionSnapshot copyWith({
    String? field,
    String? title,
    String? value,
    bool? required,
  }) {
    return ProgressNoteSectionSnapshot(
      field: field ?? this.field,
      title: title ?? this.title,
      value: value ?? this.value,
      required: required ?? this.required,
    );
  }

  Map<String, dynamic> toJson() => {
        'field': field,
        'title': title,
        'value': value,
        'required': required,
      };

  factory ProgressNoteSectionSnapshot.fromJson(Map<String, dynamic> json) {
    return ProgressNoteSectionSnapshot(
      field: json['field'] as String,
      title: json['title'] as String? ?? json['field'] as String,
      value: json['value'] as String? ?? '',
      required: json['required'] as bool? ?? false,
    );
  }
}

class ProgressNoteSnapshot {
  final String encounterId;
  final String patientId;
  final String userId;
  final DateTime updatedAt;
  final List<ProgressNoteSectionSnapshot> sections;
  final Map<String, dynamic> metadata;

  const ProgressNoteSnapshot({
    required this.encounterId,
    required this.patientId,
    required this.userId,
    required this.updatedAt,
    required this.sections,
    this.metadata = const {},
  });

  ProgressNoteSnapshot copyWith({
    String? encounterId,
    String? patientId,
    String? userId,
    DateTime? updatedAt,
    List<ProgressNoteSectionSnapshot>? sections,
    Map<String, dynamic>? metadata,
  }) {
    return ProgressNoteSnapshot(
      encounterId: encounterId ?? this.encounterId,
      patientId: patientId ?? this.patientId,
      userId: userId ?? this.userId,
      updatedAt: updatedAt ?? this.updatedAt,
      sections: sections ?? this.sections,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encounter_id': encounterId,
      'patient_id': patientId,
      'user_id': userId,
      'updated_at': updatedAt.toIso8601String(),
      'sections': sections.map((section) => section.toJson()).toList(),
      'metadata': metadata,
    };
  }

  Map<String, dynamic> toSupabasePayload() {
    return {
      'encounter_id': encounterId,
      'patient_id': patientId,
      'user_id': userId,
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'sections': sections
          .map(
            (section) => {
              'field': section.field,
              'title': section.title,
              'value': section.value,
            },
          )
          .toList(),
      'metadata': metadata,
    };
  }

  factory ProgressNoteSnapshot.fromJson(Map<String, dynamic> json) {
    final dynamic sectionsJson = json['sections'];
    final List<ProgressNoteSectionSnapshot> parsedSections;

    if (sectionsJson is List) {
      parsedSections = sectionsJson
          .whereType<Map>()
          .map((raw) => ProgressNoteSectionSnapshot.fromJson(
                Map<String, dynamic>.from(raw),
              ))
          .toList();
    } else {
      parsedSections = const [];
    }

    return ProgressNoteSnapshot(
      encounterId: json['encounter_id'] as String,
      patientId: json['patient_id'] as String,
      userId: json['user_id'] as String? ?? 'unknown_user',
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
      sections: parsedSections,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }
}

class ProgressNotesWidgetState extends BaseToolWidgetState<ProgressNotesWidget> {
  final Map<String, TextEditingController> _controllers = {};
  List<Map<String, dynamic>> _sections = [];
  ProgressNoteSnapshot? _lastSavedSnapshot;
  bool _hasUnsavedChanges = false;
  Map<String, String> _fieldErrors = {};

  @override
  void initState() {
    super.initState();
    _initializeSections();
    widget.context.registerLeaveGuard(widget.config.toolId, _onToolLeaveRequest);
  }

  void _initializeSections() {
    // 从配置中获取sections，如果没有则使用默认
    _sections = List<Map<String, dynamic>>.from(
      widget.config.config['sections'] ?? _getDefaultSections(),
    );

    // 为每个section创建controller
    for (final section in _sections) {
      final fieldName = section['field'] as String;
      _controllers[fieldName] = TextEditingController();
    }
  }

  List<Map<String, dynamic>> _getDefaultSections() {
    return [
      {
        'title': 'Chief Complaint',
        'field': 'chief_complaint',
        'type': 'textarea',
        'required': true,
      },
      {
        'title': 'History of Present Illness',
        'field': 'hpi',
        'type': 'textarea',
        'required': false,
      },
      {
        'title': 'Physical Examination',
        'field': 'examination',
        'type': 'textarea',
        'required': true,
      },
      {
        'title': 'Assessment',
        'field': 'assessment',
        'type': 'textarea',
        'required': true,
      },
      {
        'title': 'Plan',
        'field': 'plan',
        'type': 'textarea',
        'required': false,
      },
      {
        'title': 'Notes',
        'field': 'notes',
        'type': 'textarea',
        'required': false,
      },
    ];
  }

  @override
  Widget buildToolContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                'Progress Notes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              IconButton(
                onPressed: saveData,
                icon: const Icon(Icons.save),
                tooltip: 'Save Notes',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _sections.length,
              itemBuilder: (context, index) {
                final section = _sections[index];
                return _buildSection(section);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(Map<String, dynamic> section) {
    final title = section['title'] as String;
    final field = section['field'] as String;
    final isRequired = section['required'] as bool? ?? false;
    final controller = _controllers[field]!;
    final errorText = _fieldErrors[field];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: _getMaxLines(section),
            decoration: InputDecoration(
              hintText: 'Enter ${title.toLowerCase()}...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              errorText: errorText,
              errorMaxLines: 2,
            ),
            onChanged: (_) {
              _clearFieldError(field);
              _markUnsavedChanges();
              // 自动保存逻辑可以在这里实现
              if (widget.config.config['auto_save'] == true) {
                // 延迟保存以避免频繁调用
                Future.delayed(const Duration(seconds: 2), () {
                  saveData();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  int _getMaxLines(Map<String, dynamic> section) {
    final type = section['type'] as String? ?? 'textarea';
    switch (type) {
      case 'textarea':
        return 4;
      case 'text':
        return 1;
      default:
        return 3;
    }
  }

  @override
  Future<Map<String, dynamic>> saveToolData() async {
    final String userId = await _resolveUserId();
    final ProgressNoteSnapshot snapshot = _createSnapshot(userId: userId);

    setState(() {
      _lastSavedSnapshot = snapshot;
      _hasUnsavedChanges = false;
    });

    final Map<String, String> fieldValues = {
      for (final section in snapshot.sections) section.field: section.value,
    };

    return {
      ...fieldValues,
      'snapshot': snapshot.toJson(),
      'snapshot_user_id': userId,
      'sections': snapshot.sections.map((section) => section.toJson()).toList(),
      'section_values': fieldValues,
      'last_updated': snapshot.updatedAt.toIso8601String(),
      'metadata': snapshot.metadata,
    };
  }

  @override
  Future<void> loadToolData(Map<String, dynamic> data) async {
    ProgressNoteSnapshot? snapshot;

    if (data['snapshot'] is Map) {
      snapshot = ProgressNoteSnapshot.fromJson(
        Map<String, dynamic>.from(data['snapshot'] as Map),
      );
    }

    if (snapshot == null) {
      final Map<String, dynamic> metadata = Map<String, dynamic>.from(
        data['metadata'] as Map? ?? {},
      );

      final List<ProgressNoteSectionSnapshot> fallbackSections = _sections
          .map((section) {
            final field = section['field'] as String;
            return ProgressNoteSectionSnapshot(
              field: field,
              title: section['title'] as String? ?? field,
              value: data[field]?.toString() ??
                  (data['section_values'] is Map
                      ? ((data['section_values'] as Map)[field]?.toString() ?? '')
                      : ''),
              required: section['required'] as bool? ?? false,
            );
          })
          .toList();

      snapshot = ProgressNoteSnapshot(
        encounterId: widget.context.encounterId,
        patientId: widget.context.patientId,
        userId: data['snapshot_user_id'] as String? ?? 'local_user',
        updatedAt: DateTime.tryParse(data['last_updated'] as String? ?? '') ??
            DateTime.now(),
        sections: fallbackSections,
        metadata: metadata.isEmpty
            ? {
                'section_config': _sections,
              }
            : metadata,
      );
    }

    final dynamic sectionConfigRaw = snapshot.metadata['section_config'];
    final List<Map<String, dynamic>>? snapshotSectionConfig =
        sectionConfigRaw is List
            ? sectionConfigRaw
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList()
            : null;

    setState(() {
      if (snapshotSectionConfig != null && snapshotSectionConfig.isNotEmpty) {
        _sections = snapshotSectionConfig;
        _ensureControllersForSections();
      }

      for (final section in snapshot!.sections) {
        final controller = _controllers.putIfAbsent(
          section.field,
          () => TextEditingController(),
        );
        controller.text = section.value;
      }

      _lastSavedSnapshot = snapshot;
      _hasUnsavedChanges = false;
      _fieldErrors = {};
    });
  }

  @override
  bool validateToolData() {
    final requiredFields = widget.config.config['required_fields'] as List<String>? ?? [];
    final Map<String, String> errors = {};

    for (final fieldName in requiredFields) {
      final controller = _controllers[fieldName];
      if (controller == null || controller.text.trim().isEmpty) {
        errors[fieldName] = '${_resolveSectionTitle(fieldName)} is required.';
      }
    }

    setState(() {
      _fieldErrors = Map<String, String>.from(errors);
    });

    return errors.isEmpty;
  }

  @override
  void dispose() {
    widget.context.unregisterLeaveGuard(widget.config.toolId);
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<String> _resolveUserId() async {
    try {
      return await SupabaseUtils.getCurrentUserId();
    } catch (_) {
      return widget.context.metadata['user_id'] as String? ?? 'local_user';
    }
  }

  List<ProgressNoteSectionSnapshot> _buildSectionSnapshots() {
    return _sections.map((section) {
      final field = section['field'] as String;
      final title = section['title'] as String? ?? field;
      final isRequired = section['required'] as bool? ?? false;
      final controller = _controllers[field];

      return ProgressNoteSectionSnapshot(
        field: field,
        title: title,
        value: controller?.text ?? '',
        required: isRequired,
      );
    }).toList();
  }

  Map<String, dynamic> _buildSnapshotMetadata() {
    final rawMetadata = widget.config.config['metadata'];
    final Map<String, dynamic> metadata =
        rawMetadata is Map<String, dynamic> ? Map<String, dynamic>.from(rawMetadata) : {};

    metadata['section_config'] = _sections
        .map((section) => Map<String, dynamic>.from(section))
        .toList();

    return metadata;
  }

  ProgressNoteSnapshot _createSnapshot({
    required String userId,
    DateTime? updatedAt,
  }) {
    return ProgressNoteSnapshot(
      encounterId: widget.context.encounterId,
      patientId: widget.context.patientId,
      userId: userId,
      updatedAt: updatedAt ?? DateTime.now(),
      sections: _buildSectionSnapshots(),
      metadata: _buildSnapshotMetadata(),
    );
  }

  ProgressNoteSnapshot? get lastSavedSnapshot => _lastSavedSnapshot;

  Map<String, dynamic>? get supabasePayload =>
      _lastSavedSnapshot?.toSupabasePayload();

  void _markUnsavedChanges() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _clearFieldError(String field) {
    if (_fieldErrors.containsKey(field)) {
      setState(() {
        _fieldErrors.remove(field);
      });
    }
  }

  String _resolveSectionTitle(String field) {
    for (final section in _sections) {
      if (section['field'] == field) {
        return section['title'] as String? ?? field;
      }
    }
    return field;
  }

  void _ensureControllersForSections() {
    for (final section in _sections) {
      final field = section['field'] as String;
      _controllers.putIfAbsent(field, () => TextEditingController());
    }
  }

  Future<bool> _onToolLeaveRequest() async {
    if (!_hasUnsavedChanges) {
      return true;
    }

    if (!mounted) {
      return true;
    }

    final bool? shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text(
            'You have unsaved progress notes. Do you want to discard them?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );

    if (shouldDiscard == true) {
      setState(() {
        _hasUnsavedChanges = false;
      });
      return true;
    }

    return false;
  }
}
