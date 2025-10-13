import 'package:flutter/material.dart';
import '../../core/interfaces.dart';
import '../../core/encounter_context.dart';
import '../../core/base_tool_widget.dart';

class PelvicDiagramTool implements IEncounterTool {
  final ToolConfig config;

  PelvicDiagramTool({required this.config});

  @override
  String get toolId => 'pelvic_diagram';

  @override
  String get displayName => 'Pelvic Diagram';

  @override
  IconData get icon => Icons.medical_information;

  @override
  bool get isUniversal => false;

  @override
  Widget buildWidget(EncounterContext context) {
    return PelvicDiagramWidget(
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

class PelvicDiagramWidget extends BaseToolWidget {
  const PelvicDiagramWidget({
    super.key,
    required super.context,
    required super.config,
  });

  @override
  PelvicDiagramWidgetState createState() => PelvicDiagramWidgetState();
}

class PelvicDiagramWidgetState extends BaseToolWidgetState<PelvicDiagramWidget> {
  Map<String, String> _anatomyFindings = {};
  String _selectedFinding = 'normal';
  List<String> _availableFindings = [];
  Map<String, Color> _findingColors = {};
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFindings();
  }

  void _initializeFindings() {
    final config = widget.config.config;
    
    _availableFindings = List<String>.from(
      config['available_findings'] ?? [
        'normal',
        'inflammation',
        'mass',
        'cyst',
        'fibroid',
        'polyp',
      ],
    );

    final colorConfig = config['color_coding'] as Map<String, dynamic>? ?? {};
    _findingColors = {
      'normal': _parseColor(colorConfig['normal']) ?? Colors.green,
      'inflammation': _parseColor(colorConfig['inflammation']) ?? Colors.red,
      'mass': _parseColor(colorConfig['mass']) ?? Colors.purple,
      'cyst': _parseColor(colorConfig['cyst']) ?? Colors.blue,
      'fibroid': _parseColor(colorConfig['fibroid']) ?? Colors.brown,
      'polyp': _parseColor(colorConfig['polyp']) ?? Colors.orange,
      'adhesions': _parseColor(colorConfig['adhesions']) ?? Colors.grey,
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
          _buildFindingSelector(),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildPelvicDiagram(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildNotesSection(),
                ),
              ],
            ),
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
        Icon(Icons.medical_information, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          'Pelvic Examination',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        IconButton(
          onPressed: _clearAllFindings,
          icon: const Icon(Icons.clear_all),
          tooltip: 'Clear All',
        ),
        IconButton(
          onPressed: saveData,
          icon: const Icon(Icons.save),
          tooltip: 'Save Findings',
        ),
      ],
    );
  }

  Widget _buildFindingSelector() {
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
            'Select Finding:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _availableFindings.map((finding) {
              final isSelected = finding == _selectedFinding;
              final color = _findingColors[finding] ?? Colors.grey;
              
              return FilterChip(
                label: Text(
                  finding.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedFinding = finding;
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

  Widget _buildPelvicDiagram() {
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
            const Text(
              'Pelvic Anatomy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildAnatomyDiagram(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnatomyDiagram() {
    // 简化的盆腔解剖图
    final anatomyParts = [
      {'name': 'Uterus', 'position': const Offset(0.5, 0.4)},
      {'name': 'Left Ovary', 'position': const Offset(0.2, 0.3)},
      {'name': 'Right Ovary', 'position': const Offset(0.8, 0.3)},
      {'name': 'Cervix', 'position': const Offset(0.5, 0.6)},
      {'name': 'Vagina', 'position': const Offset(0.5, 0.8)},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // 背景轮廓
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: PelvicOutlinePainter(),
              ),
            ),
            // 解剖部位
            ...anatomyParts.map((part) {
              final name = part['name'] as String;
              final position = part['position'] as Offset;
              final finding = _anatomyFindings[name] ?? 'normal';
              final color = _findingColors[finding] ?? Colors.green;
              
              return Positioned(
                left: position.dx * constraints.maxWidth - 20,
                top: position.dy * constraints.maxHeight - 20,
                child: GestureDetector(
                  onTap: () => _setAnatomyFinding(name),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        name.substring(0, 1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildNotesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Examination Notes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Enter examination findings and notes...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
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
            children: _availableFindings.map((finding) {
              final color = _findingColors[finding] ?? Colors.grey;
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
                    finding.replaceAll('_', ' ').toUpperCase(),
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

  void _setAnatomyFinding(String anatomyPart) {
    setState(() {
      _anatomyFindings[anatomyPart] = _selectedFinding;
    });
  }

  void _clearAllFindings() {
    setState(() {
      _anatomyFindings.clear();
      _notesController.clear();
    });
  }

  @override
  Future<Map<String, dynamic>> saveToolData() async {
    return {
      'examination_findings': _anatomyFindings,
      'selected_finding': _selectedFinding,
      'notes': _notesController.text,
      'last_updated': DateTime.now().toIso8601String(),
      'diagram_type': 'pelvic',
    };
  }

  @override
  Future<void> loadToolData(Map<String, dynamic> data) async {
    if (data['examination_findings'] != null) {
      _anatomyFindings = Map<String, String>.from(data['examination_findings']);
    }
    
    if (data['selected_finding'] != null) {
      _selectedFinding = data['selected_finding'] as String;
    }
    
    if (data['notes'] != null) {
      _notesController.text = data['notes'] as String;
    }
    
    setState(() {});
  }

  @override
  bool validateToolData() {
    // 盆腔图数据总是有效的，即使是空的
    return true;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}

// 简单的盆腔轮廓绘制器
class PelvicOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // 绘制简化的盆腔轮廓
    path.moveTo(size.width * 0.3, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.1,
      size.width * 0.7, size.height * 0.2,
    );
    path.lineTo(size.width * 0.8, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.9,
      size.width * 0.2, size.height * 0.7,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
