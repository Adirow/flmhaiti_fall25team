import 'package:flutter/material.dart';
import '../core/interfaces.dart';
import '../core/encounter_context.dart';
import '../core/tool_registry.dart';
import '../core/department_registry.dart';
import 'package:flmhaiti_fall25team/localization/l10n_extension.dart';

class ToolGrid extends StatefulWidget {
  final EncounterContext encounterContext;
  final String departmentId;
  final Function(String toolId, Widget toolWidget)? onToolSelected;

  const ToolGrid({
    super.key,
    required this.encounterContext,
    required this.departmentId,
    this.onToolSelected,
  });

  @override
  State<ToolGrid> createState() => _ToolGridState();
}

class _ToolGridState extends State<ToolGrid> {
  List<ToolConfig> _toolConfigs = [];
  Map<String, ToolMetadata> _toolMetadata = {};
  String? _selectedToolId;

  @override
  void initState() {
    super.initState();
    _loadToolConfigs();
  }

  void _loadToolConfigs() {
    // 获取科室的工具配置
    _toolConfigs = DepartmentRegistry.getDepartmentToolConfigs(widget.departmentId);
    
    // 获取工具元数据
    for (final config in _toolConfigs) {
      final metadata = ToolRegistry.getToolMetadata(config.toolId);
      if (metadata != null) {
        _toolMetadata[config.toolId] = metadata;
      }
    }
    
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_toolConfigs.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final spacing = 12.0;
              final crossAxisCount = availableWidth > 1600 ? 3 : 2;
              final tileWidth = (availableWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;
              const targetTileHeight = 160.0;
              final computedAspectRatio = tileWidth / targetTileHeight;
              final childAspectRatio = computedAspectRatio.isFinite && computedAspectRatio > 0
                  ? computedAspectRatio
                  : 1.0;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                ),
                itemCount: _toolConfigs.length,
                itemBuilder: (context, index) {
                  final config = _toolConfigs[index];
                  final metadata = _toolMetadata[config.toolId];

                  if (metadata == null) return const SizedBox.shrink();

                  return _buildToolCard(config, metadata);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Row(
      children: [
        Icon(
          Icons.build_circle,
          color: theme.primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          l10n.encountersToolsTitle,
          style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        if (_selectedToolId != null)
          IconButton(
            onPressed: _clearSelection,
            icon: const Icon(Icons.close),
            tooltip: l10n.encountersCloseTool,
          ),
      ],
    );
  }

  Widget _buildToolCard(ToolConfig config, ToolMetadata metadata) {
    final isSelected = _selectedToolId == config.toolId;
    final hasData = widget.encounterContext.getToolData(config.toolId) != null;
    
    return Card(
      elevation: isSelected ? 8 : 2,
      shadowColor: isSelected 
          ? Theme.of(context).primaryColor.withOpacity(0.3)
          : null,
      child: InkWell(
        onTap: () => _selectTool(config),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Icon(
                    metadata.icon,
                    size: 36,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  if (hasData)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).cardColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  if (config.isRequired)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                metadata.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
              ),
              if (metadata.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  metadata.description!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.build_circle_outlined,
            size: 64,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.encountersNoTools,
            style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.encountersNoToolsSubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
          ),
        ],
      ),
    );
  }

  void _selectTool(ToolConfig config) {
    _handleToolSelection(config);
  }

  Future<void> _handleToolSelection(ToolConfig config) async {
    if (_selectedToolId != null && _selectedToolId!.isNotEmpty) {
      final canLeave =
          await widget.encounterContext.canDeactivateTool(_selectedToolId!);
      if (!canLeave) {
        return;
      }
    }

    // 创建工具实例
    final tool = ToolRegistry.createTool(config.toolId, config);
    if (tool == null) {
      _showError(context.l10n.encountersToolLoadError(config.toolId));
      return;
    }

    final toolWidget = tool.buildWidget(widget.encounterContext);

    setState(() {
      _selectedToolId = config.toolId;
    });

    widget.onToolSelected?.call(config.toolId, toolWidget);
    widget.encounterContext.emitEvent(ToolActivatedEvent(config.toolId));
  }

  void _clearSelection() {
    if (_selectedToolId == null) {
      return;
    }

    _handleClearSelection();
  }

  Future<void> _handleClearSelection() async {
    final currentToolId = _selectedToolId;
    if (currentToolId == null) {
      return;
    }

    final canLeave = await widget.encounterContext.canDeactivateTool(currentToolId);
    if (!canLeave) {
      return;
    }

    widget.encounterContext.emitEvent(ToolDeactivatedEvent(currentToolId));

    setState(() {
      _selectedToolId = null;
    });

    widget.onToolSelected?.call('', const SizedBox.shrink());
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(ToolGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.departmentId != widget.departmentId) {
      _clearSelection();
      _loadToolConfigs();
    }
  }
}
