import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_drawing/path_drawing.dart';

import '../../core/base_tool_widget.dart';
import '../../core/encounter_context.dart';
import '../../core/interfaces.dart';

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

class ToothRegion {
  final int number;
  final Path path;
  final Rect bounds;

  ToothRegion({
    required this.number,
    required this.path,
    required this.bounds,
  });

  Offset get center => bounds.center;
}

class ToothMapWidgetState extends BaseToolWidgetState<ToothMapWidget> {
  Map<int, String> _teethConditions = {};
  String _selectedCondition = 'healthy';
  List<String> _availableConditions = [];
  Map<String, Color> _conditionColors = {};
  Map<int, ToothRegion> _toothRegions = {};
  bool _toothRegionsLoaded = false;
  String? _toothRegionsLoadError;

  @override
  void initState() {
    super.initState();
    _initializeConditions();
    _loadToothRegions();
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

  Future<void> _loadToothRegions() async {
    try {
      debugPrint('ToothMap: extracting tooth shapes from SVG...');
      final svgContent =
          await rootBundle.loadString('assets/images/dental-arches-flutter.svg');

      final RegExp pathPattern = RegExp(
        r'<path[^>]*class="([^"]*tooth-(\d{2})[^"]*parent[^"]*)"[^>]*d="([^"]+)"',
        multiLine: true,
      );

      final Map<int, ToothRegion> regions = {};

      for (final match in pathPattern.allMatches(svgContent)) {
        final int number = int.parse(match.group(2)!);
        final String rawPath = match.group(3)!;
        final Path path = parseSvgPathData(rawPath)..fillType = PathFillType.nonZero;
        final Rect bounds = path.getBounds();

        regions.putIfAbsent(
          number,
          () => ToothRegion(number: number, path: path, bounds: bounds),
        );
      }

      if (regions.isEmpty) {
        throw const FormatException('No tooth shapes were found in SVG');
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _toothRegions = regions;
        _toothRegionsLoaded = true;
        _toothRegionsLoadError = null;
      });
      debugPrint('ToothMap: loaded ${regions.length} tooth regions from SVG.');
    } catch (error, stackTrace) {
      debugPrint('ToothMap: failed to load tooth regions: $error');
      debugPrint(stackTrace.toString());

      if (!mounted) {
        return;
      }

      setState(() {
        _toothRegions = {};
        _toothRegionsLoaded = true;
        _toothRegionsLoadError = error.toString();
      });
    }
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

  // Widget _buildToothChart() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Theme.of(context).dividerColor),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           // Upper jaw
  //           _buildJaw(isUpper: true),
  //           const SizedBox(height: 20),
  //           // Lower jaw
  //           _buildJaw(isUpper: false),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildToothChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (!_toothRegionsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_toothRegionsLoadError != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Unable to load tooth regions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _toothRegionsLoadError!,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            const double svgWidth = 289.61084;
            const double svgHeight = 370.54398;
            final double aspectRatio = svgWidth / svgHeight;

            double width = constraints.maxWidth;
            double height = width / aspectRatio;

            if (height > constraints.maxHeight) {
              height = constraints.maxHeight;
              width = height * aspectRatio;
            }

            final double scaleX = width / svgWidth;
            final double scaleY = height / svgHeight;
            final Map<int, String> conditionSnapshot =
                Map<int, String>.from(_teethConditions);

            return Center(
              child: SizedBox(
                width: width,
                height: height,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) =>
                      _handleTap(details.localPosition, scaleX, scaleY),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        SvgPicture.asset(
                          'assets/images/dental-arches-flutter.svg',
                          width: width,
                          height: height,
                          fit: BoxFit.contain,
                        ),
                        CustomPaint(
                          painter: _ToothHighlightPainter(
                            toothRegions: _toothRegions,
                            teethConditions: conditionSnapshot,
                            conditionColors: _conditionColors,
                            scaleX: scaleX,
                            scaleY: scaleY,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleTap(Offset position, double scaleX, double scaleY) {
    final Offset normalized = Offset(
      position.dx / scaleX,
      position.dy / scaleY,
    );

    for (final entry in _toothRegions.entries) {
      if (entry.value.path.contains(normalized)) {
        _onToothTapped(entry.key);
        break;
      }
    }
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
      if (_selectedCondition == 'healthy') {
        _teethConditions.remove(toothNumber);
      } else {
        _teethConditions[toothNumber] = _selectedCondition;
      }
    });
  }

  void _clearAllConditions() {
    setState(() {
      _teethConditions.clear();
    });
  }

  void _onToothTapped(int toothNumber) {
    _setToothCondition(toothNumber);
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

class _ToothHighlightPainter extends CustomPainter {
  final Map<int, ToothRegion> toothRegions;
  final Map<int, String> teethConditions;
  final Map<String, Color> conditionColors;
  final double scaleX;
  final double scaleY;

  _ToothHighlightPainter({
    required this.toothRegions,
    required this.teethConditions,
    required this.conditionColors,
    required this.scaleX,
    required this.scaleY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(scaleX, scaleY);

    toothRegions.forEach((number, region) {
      final String? condition = teethConditions[number];
      if (condition == null || condition == 'healthy') {
        return;
      }

      final Color fillColor =
          (conditionColors[condition] ?? Colors.green).withOpacity(0.55);

      final Paint paint = Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawPath(region.path, paint);
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ToothHighlightPainter oldDelegate) {
    if (identical(this, oldDelegate)) {
      return false;
    }

    return oldDelegate.teethConditions != teethConditions ||
        oldDelegate.conditionColors != conditionColors ||
        oldDelegate.scaleX != scaleX ||
        oldDelegate.scaleY != scaleY;
  }
}
