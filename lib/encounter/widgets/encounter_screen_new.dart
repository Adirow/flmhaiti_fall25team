import 'package:flutter/material.dart';
import '../core/encounter_context.dart';
import '../core/department_registry.dart';
import '../models/department.dart';
import '../services/encounter_service.dart';
import '../services/department_service.dart';
import '../config/encounter_config.dart';
import 'department_selector.dart';
import 'tool_grid.dart';
import '../../supabase/supabase_utils.dart';
import 'package:flmhaiti_fall25team/localization/l10n_extension.dart';

class NewEncounterScreen extends StatefulWidget {
  final String? patientId;
  final String? providerId;
  final String? clinicId;
  final String? encounterId; // 如果是编辑现有问诊

  const NewEncounterScreen({
    super.key,
    this.patientId,
    this.providerId,
    this.clinicId,
    this.encounterId,
  });

  @override
  State<NewEncounterScreen> createState() => _NewEncounterScreenState();
}

class _NewEncounterScreenState extends State<NewEncounterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _chiefComplaintController = TextEditingController();
  final _notesController = TextEditingController();
  final _encounterService = EncounterService();
  final _departmentService = DepartmentService();

  // 新架构相关状态
  EncounterContext? _encounterContext;
  Department? _selectedDepartment;
  String _selectedExamType = 'Routine Checkup';
  List<String> _availableExamTypes = [];
  
  // UI 状态
  bool _isLoading = false;
  bool _isSaving = false;
  String? _selectedToolId;
  Widget _selectedToolWidget = const SizedBox.shrink();

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    setState(() => _isLoading = true);

    try {
      // 设置默认科室
      final defaultDeptCode = EncounterConfig.getDefaultDepartment();
      _selectedDepartment = await _departmentService.getDepartmentByCode(defaultDeptCode);
      
      if (_selectedDepartment != null) {
        // 从注册表获取科室实例来获取检查类型
        final departmentInstance = DepartmentRegistry.getDepartment(_selectedDepartment!.code);
        _availableExamTypes = departmentInstance?.examTypes ?? 
            EncounterConstants.departmentExamTypes[defaultDeptCode] ?? [];
        if (_availableExamTypes.isNotEmpty) {
          _selectedExamType = _availableExamTypes.first;
        }
      }

      // 如果是编辑模式，加载现有数据
      if (widget.encounterId != null) {
        await _loadExistingEncounter();
      } else {
        // 创建新的问诊上下文
        _createNewEncounterContext();
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(context.l10n.encountersInitError('$e'));
    }
  }

  void _createNewEncounterContext() {
    // 从注册表获取科室实例来获取默认元数据
    Map<String, dynamic> defaultMetadata = {};
    if (_selectedDepartment != null) {
      final departmentInstance = DepartmentRegistry.getDepartment(_selectedDepartment!.code);
      defaultMetadata = departmentInstance?.getDefaultMetadata() ?? {};
    }

    _encounterContext = EncounterContext(
      encounterId: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      patientId: widget.patientId ?? 'temp_patient',
      departmentId: _selectedDepartment?.id,
      metadata: defaultMetadata,
    );
  }

  Future<void> _loadExistingEncounter() async {
    // TODO: 实现加载现有问诊的逻辑
    _createNewEncounterContext();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.encountersLoadingTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(),
      body: _encounterContext == null 
          ? _buildErrorState()
          : _buildMainContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final l10n = context.l10n;
    return AppBar(
      title: Text(widget.encounterId != null ? l10n.encountersEditTitle : l10n.encountersNewTitle),
      actions: [
        if (_isSaving)
          const Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: l10n.encountersSave,
            onPressed: _saveEncounter,
          ),
      ],
    );
  }

  Widget _buildErrorState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            l10n.encountersInitErrorTitle,
            style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.error),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Row(
      children: [
        // 左侧：表单和工具网格
        Expanded(
          flex: 1,
          child: _buildLeftPanel(),
        ),
        // 右侧：选中的工具
        if (_selectedToolId != null && _selectedToolId!.isNotEmpty)
          Expanded(
            flex: 2,
            child: _buildRightPanel(),
          ),
      ],
    );
  }

  Widget _buildLeftPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEncounterInfoCard(),
            const SizedBox(height: 24),
            _buildToolsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: _selectedToolWidget,
    );
  }

  Widget _buildEncounterInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.encountersInfoSectionTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          // 科室选择器
          DepartmentSelector(
            selectedDepartmentId: _selectedDepartment?.id,
            onDepartmentChanged: _onDepartmentChanged,
          ),
          const SizedBox(height: 16),
          
          // 检查类型
          DropdownButtonFormField<String>(
            value: _selectedExamType,
            decoration: InputDecoration(
              labelText: context.l10n.encountersExamTypeLabel,
              prefixIcon: Icon(
                Icons.medical_services_outlined,
                color: Theme.of(context).primaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            items: _availableExamTypes
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedExamType = value);
              }
            },
          ),
          const SizedBox(height: 16),
          
          // 主诉
          TextFormField(
            controller: _chiefComplaintController,
            decoration: InputDecoration(
              labelText: context.l10n.encountersChiefComplaintLabel,
              hintText: context.l10n.encountersChiefComplaintHint,
              prefixIcon: Icon(
                Icons.notes,
                color: Theme.of(context).primaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            maxLines: 3,
            validator: (value) => value == null || value.isEmpty
                ? context.l10n.encountersChiefComplaintRequired
                : null,
          ),
          const SizedBox(height: 16),
          
          // 临床笔记
          TextFormField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: context.l10n.encountersNotesLabel,
              hintText: context.l10n.encountersNotesHint,
              prefixIcon: Icon(
                Icons.description_outlined,
                color: Theme.of(context).primaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildToolsSection() {
    if (_selectedDepartment == null || _encounterContext == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 400,
      child: ToolGrid(
        encounterContext: _encounterContext!,
        departmentId: _selectedDepartment!.code, // 使用 code 而不是 id
        onToolSelected: _onToolSelected,
      ),
    );
  }

  void _onDepartmentChanged(Department department) {
    // 使用 WidgetsBinding.instance.addPostFrameCallback 来延迟执行 setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      // 更新可用的检查类型
      final deptInstance = DepartmentRegistry.getDepartment(department.code);
      List<String> newExamTypes = [];
      String newSelectedExamType = _selectedExamType;
      
      if (deptInstance != null) {
        newExamTypes = deptInstance.examTypes;
        if (newExamTypes.isNotEmpty) {
          newSelectedExamType = newExamTypes.first;
        }
      }

      // 更新问诊上下文
      EncounterContext? newContext;
      if (_encounterContext != null) {
        // 从注册表获取科室实例来获取默认元数据
        Map<String, dynamic> defaultMetadata = {};
        final departmentInstance = DepartmentRegistry.getDepartment(department.code);
        defaultMetadata = departmentInstance?.getDefaultMetadata() ?? {};

        newContext = EncounterContext(
          encounterId: _encounterContext!.encounterId,
          patientId: _encounterContext!.patientId,
          departmentId: department.id,
          metadata: defaultMetadata,
        );
      }

      // 一次性更新所有状态
      setState(() {
        _selectedDepartment = department;
        _selectedToolId = null;
        _selectedToolWidget = const SizedBox.shrink();
        _availableExamTypes = newExamTypes;
        _selectedExamType = newSelectedExamType;
        if (newContext != null) {
          _encounterContext?.dispose();
          _encounterContext = newContext;
        }
      });
    });
  }

  void _onToolSelected(String toolId, Widget toolWidget) {
    // 使用 WidgetsBinding.instance.addPostFrameCallback 来延迟执行 setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _selectedToolId = toolId;
        _selectedToolWidget = toolWidget;
      });
    });
  }

  Future<void> _saveEncounter() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // 验证必需的 patientId
      if (widget.patientId == null || widget.patientId!.isEmpty) {
        throw Exception('Patient ID is required to create an encounter');
      }

      // 获取当前用户和诊所信息
      final currentUserId = await SupabaseUtils.getCurrentUserId();
      final currentClinicId = await SupabaseUtils.getCurrentClinicId();

      // 保存问诊基本信息
      final encounter = await _encounterService.createEncounter(
        patientId: widget.patientId!, // 使用传入的病人ID
        providerId: widget.providerId ?? currentUserId, // 使用传入的或当前用户ID
        clinicId: widget.clinicId ?? currentClinicId, // 使用传入的或当前诊所ID
        departmentId: _selectedDepartment?.id,
        examType: _selectedExamType,
        chiefComplaint: _chiefComplaintController.text,
        notes: _notesController.text,
        metadata: _encounterContext?.metadata ?? {},
      );

      // 保存工具数据
      if (_encounterContext != null && _encounterContext!.toolData.isNotEmpty) {
        await _encounterService.saveEncounterToolData(
          encounterId: encounter.id,
          toolDataMap: Map<String, Map<String, dynamic>>.from(
            _encounterContext!.toolData.map(
              (key, value) => MapEntry(key, Map<String, dynamic>.from(value)),
            ),
          ),
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.encountersSavedSuccess)),
        );
      }
    } catch (e) {
      String errorMessage = context.l10n.encountersErrorSave(e.toString());

      if (e.toString().contains('Patient ID is required')) {
        errorMessage = context.l10n.encountersErrorMissingPatient;
      } else if (e.toString().contains('User not logged in')) {
        errorMessage = context.l10n.encountersErrorNotLoggedIn;
      } else if (e.toString().contains('No clinic_id found')) {
        errorMessage = context.l10n.encountersErrorMissingClinic;
      } else if (e.toString().contains('PostgrestException')) {
        errorMessage = context.l10n.encountersErrorDatabase;
      }

      _showError(errorMessage);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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
  void dispose() {
    _chiefComplaintController.dispose();
    _notesController.dispose();
    _encounterContext?.dispose();
    super.dispose();
  }
}
