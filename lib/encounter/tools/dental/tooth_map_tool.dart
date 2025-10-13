import 'package:flutter/material.dart';
import '../../core/interfaces.dart';
import '../../core/encounter_context.dart';
import '../../core/base_tool_widget.dart';

class ToothMapTool implements IEncounterTool {
  final ToolConfig config;

  ToothMapTool({required this.config});

  @override
  String get toolId => 'tooth_map';

  @override
  String get displayName => 'Tooth Map';

  @override
  IconData get icon => Icons.grid_view;

  @override
  bool get isUniversal => false;

  @override
  Widget buildWidget(EncounterContext context) {
    return ToothMapWidget(
      context: context,
      config: config,
    );
  }

  @override
  Future<Map<String, dynamic>> saveData() async {
    throw UnimplementedError('saveData should be implemented in widget');
  }

  @override
  Future<void> loadData(Map<String, dynamic> data) async {
    throw UnimplementedError('loadData should be implemented in widget');
  }

  @override
  bool validateData() {
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

class ToothMapWidget extends BaseToolWidget {
  const ToothMapWidget({
    super.key,
    required super.context,
    required super.config,
  });

  @override
  ToothMapWidgetState createState() => ToothMapWidgetState();
}

class ToothMapWidgetState extends BaseToolWidgetState<ToothMapWidget> {
  Map<int, String> _teethConditions = {};
  String _selectedCondition = 'healthy';
  List<String> _availableConditions = [];
  Map<String, Color> _conditionColors = {};

  @override
  void initState() {
    super.initState();
    _initializeConditions();
  }

  void _initializeConditions() {
    final config = widget.config.config;
    
    _availableConditions = List<String>.from(
      config['available_conditions'] ?? [
        'healthy',
        'caries',
        'filled',
        'crown',
        'missing',
        'implant',
      ],
    );

    final colorConfig = config['color_coding'] as Map<String, dynamic>? ?? {};
    _conditionColors = {
      'healthy': _parseColor(colorConfig['healthy']) ?? Colors.green,
      'caries': _parseColor(colorConfig['caries']) ?? Colors.red,
      'filled': _parseColor(colorConfig['filled']) ?? Colors.blue,
      'crown': _parseColor(colorConfig['crown']) ?? Colors.orange,
      'missing': _parseColor(colorConfig['missing']) ?? Colors.grey,
      'implant': _parseColor(colorConfig['implant']) ?? Colors.purple,
      'root_canal': _parseColor(colorConfig['root_canal']) ?? Colors.brown,
    };
  }

  Color? _parseColor(dynamic colorValue) {
    if (colorValue is String) {
      try {
        return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Widget buildToolContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildConditionSelector(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildToothChart(),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.grid_view, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          'Tooth Map',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        IconButton(
          onPressed: _clearAllConditions,
          icon: const Icon(Icons.clear_all),
          tooltip: 'Clear All',
        ),
        IconButton(
          onPressed: saveData,
          icon: const Icon(Icons.save),
          tooltip: 'Save Tooth Map',
        ),
      ],
    );
  }

  Widget _buildConditionSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Condition:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _availableConditions.map((condition) {
              final isSelected = condition == _selectedCondition;
              final color = _conditionColors[condition] ?? Colors.grey;
              
              return FilterChip(
                label: Text(
                  condition.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCondition = condition;
                    });
                  }
                },
                backgroundColor: color.withOpacity(0.2),
                selectedColor: color,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildToothChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Upper jaw
            _buildJaw(isUpper: true),
            const SizedBox(height: 20),
            // Lower jaw
            _buildJaw(isUpper: false),
          ],
        ),
      ),
    );
  }

  Widget _buildJaw({required bool isUpper}) {
    
    return Column(
      children: [
        Text(
          isUpper ? 'Upper Jaw' : 'Lower Jaw',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Right side
            ...List.generate(8, (index) {
              final toothNumber = isUpper ? (18 - index) : (48 - index);
              return _buildTooth(toothNumber);
            }),
            const SizedBox(width: 20),
            // Left side
            ...List.generate(8, (index) {
              final toothNumber = isUpper ? (21 + index) : (31 + index);
              return _buildTooth(toothNumber);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildTooth(int toothNumber) {
    final condition = _teethConditions[toothNumber] ?? 'healthy';
    final color = _conditionColors[condition] ?? Colors.green;
    
    return GestureDetector(
      onTap: () => _setToothCondition(toothNumber),
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.black26,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            toothNumber.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legend:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: _availableConditions.map((condition) {
              final color = _conditionColors[condition] ?? Colors.grey;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    condition.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _setToothCondition(int toothNumber) {
    setState(() {
      _teethConditions[toothNumber] = _selectedCondition;
    });
  }

  void _clearAllConditions() {
    setState(() {
      _teethConditions.clear();
    });
  }

  @override
  Future<Map<String, dynamic>> saveToolData() async {
    return {
      'teeth_conditions': _teethConditions,
      'selected_condition': _selectedCondition,
      'last_updated': DateTime.now().toIso8601String(),
      'chart_type': 'adult',
    };
  }

  @override
  Future<void> loadToolData(Map<String, dynamic> data) async {
    if (data['teeth_conditions'] != null) {
      _teethConditions = Map<int, String>.from(
        (data['teeth_conditions'] as Map).map(
          (key, value) => MapEntry(int.parse(key.toString()), value.toString()),
        ),
      );
    }
    
    if (data['selected_condition'] != null) {
      _selectedCondition = data['selected_condition'] as String;
    }
    
    setState(() {});
  }

  @override
  bool validateToolData() {
    // 牙位图数据总是有效的，即使是空的
    return true;
  }
}
