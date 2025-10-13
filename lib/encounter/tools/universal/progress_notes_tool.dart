import 'package:flutter/material.dart';
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

class ProgressNotesWidgetState extends BaseToolWidgetState<ProgressNotesWidget> {
  final Map<String, TextEditingController> _controllers = {};
  List<Map<String, dynamic>> _sections = [];

  @override
  void initState() {
    super.initState();
    _initializeSections();
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
            ),
            onChanged: (_) {
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
    final data = <String, dynamic>{};
    
    for (final entry in _controllers.entries) {
      data[entry.key] = entry.value.text;
    }
    
    data['last_updated'] = DateTime.now().toIso8601String();
    data['sections'] = _sections;
    
    return data;
  }

  @override
  Future<void> loadToolData(Map<String, dynamic> data) async {
    for (final entry in _controllers.entries) {
      final fieldName = entry.key;
      final controller = entry.value;
      
      if (data.containsKey(fieldName)) {
        controller.text = data[fieldName]?.toString() ?? '';
      }
    }
  }

  @override
  bool validateToolData() {
    final requiredFields = widget.config.config['required_fields'] as List<String>? ?? [];
    
    for (final fieldName in requiredFields) {
      final controller = _controllers[fieldName];
      if (controller == null || controller.text.trim().isEmpty) {
        return false;
      }
    }
    
    return true;
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
