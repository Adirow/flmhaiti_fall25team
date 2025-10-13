import 'package:flutter/material.dart';
import '../core/interfaces.dart';
import '../core/encounter_context.dart';
import '../core/tool_registry.dart';
import '../core/department_registry.dart';

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
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1600 ? 3 : 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _toolConfigs.length,
            itemBuilder: (context, index) {
              final config = _toolConfigs[index];
              final metadata = _toolMetadata[config.toolId];
              
              if (metadata == null) return const SizedBox.shrink();
              
              return _buildToolCard(config, metadata);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.build_circle,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Clinical Tools',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        if (_selectedToolId != null)
          IconButton(
            onPressed: _clearSelection,
            icon: const Icon(Icons.close),
            tooltip: 'Close Tool',
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.build_circle_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No tools available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tools will appear here when configured for this department',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
          ),
        ],
      ),
    );
  }

  void _selectTool(ToolConfig config) {
    // 创建工具实例
    final tool = ToolRegistry.createTool(config.toolId, config);
    if (tool == null) {
      _showError('Failed to load tool: ${config.toolId}');
      return;
    }

    // 构建工具 Widget
    final toolWidget = tool.buildWidget(widget.encounterContext);
    
    setState(() {
      _selectedToolId = config.toolId;
    });

    // 通知父组件
    widget.onToolSelected?.call(config.toolId, toolWidget);

    // 发送工具激活事件
    widget.encounterContext.emitEvent(ToolActivatedEvent(config.toolId));
  }

  void _clearSelection() {
    if (_selectedToolId != null) {
      widget.encounterContext.emitEvent(ToolDeactivatedEvent(_selectedToolId!));
    }
    
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
