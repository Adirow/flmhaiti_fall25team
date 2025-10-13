import 'package:flutter/material.dart';
import 'encounter_context.dart';
import 'interfaces.dart';

// 工具基类 Widget
abstract class BaseToolWidget extends StatefulWidget {
  final EncounterContext context;
  final ToolConfig config;

  const BaseToolWidget({
    super.key,
    required this.context,
    required this.config,
  });

  @override
  BaseToolWidgetState createState();
}

abstract class BaseToolWidgetState<T extends BaseToolWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  bool get wantKeepAlive => true;

  // 子类需要实现的方法
  Widget buildToolContent(BuildContext context);
  Future<Map<String, dynamic>> saveToolData();
  Future<void> loadToolData(Map<String, dynamic> data);
  bool validateToolData();

  // 可选的生命周期方法
  void onToolActivated() {}
  void onToolDeactivated() {}

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final existingData = widget.context.getToolData<Map<String, dynamic>>(
      widget.config.toolId,
    );
    
    if (existingData != null) {
      setState(() => _isLoading = true);
      try {
        await loadToolData(existingData);
        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> saveData() async {
    if (!validateToolData()) return;

    setState(() => _isLoading = true);
    try {
      final data = await saveToolData();
      widget.context.setToolData(widget.config.toolId, data);
      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void clearError() {
    setState(() => _errorMessage = null);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Column(
      children: [
        if (_errorMessage != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: clearError,
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : buildToolContent(context),
        ),
      ],
    );
  }

  @override
  void dispose() {
    onToolDeactivated();
    super.dispose();
  }
}
