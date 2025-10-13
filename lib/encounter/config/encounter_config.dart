import 'package:flutter/material.dart';
import '../core/tool_registry.dart';
import '../core/department_registry.dart';
import '../core/interfaces.dart';
import '../departments/dental_department.dart';
import '../departments/gynecology_department.dart';
import '../tools/universal/progress_notes_tool.dart';
import '../tools/dental/tooth_map_tool.dart';
import '../tools/gynecology/pelvic_diagram_tool.dart';

class EncounterConfig {
  static bool _isInitialized = false;

  // 初始化 encounter 系统
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 注册通用工具
      _registerUniversalTools();

      // 注册科室
      _registerDepartments();

      // 注册科室专属工具
      _registerSpecializedTools();

      // 配置科室工具关联
      _configureDepartmentTools();

      _isInitialized = true;
      debugPrint('EncounterConfig: Initialization completed successfully');
    } catch (e) {
      debugPrint('EncounterConfig: Initialization failed: $e');
      rethrow;
    }
  }

  // 注册通用工具
  static void _registerUniversalTools() {
    // Progress Notes - 通用进度记录工具
    ToolRegistry.registerTool(
      'progress_notes',
      (config) => ProgressNotesTool(config: config),
      const ToolMetadata(
        toolId: 'progress_notes',
        name: 'Progress Notes',
        description: 'General progress notes for all departments',
        icon: Icons.edit_note,
        isUniversal: true,
      ),
    );
  }

  // 注册科室
  static void _registerDepartments() {
    // Dental Department
    DepartmentRegistry.registerDepartment(
      'dental',
      () => DentalDepartment(),
    );

    // Gynecology Department
    DepartmentRegistry.registerDepartment(
      'gynecology',
      () => GynecologyDepartment(),
    );
  }

  // 注册科室专属工具
  static void _registerSpecializedTools() {
    // Tooth Map - 牙科专属工具
    ToolRegistry.registerTool(
      'tooth_map',
      (config) => ToothMapTool(config: config),
      const ToolMetadata(
        toolId: 'tooth_map',
        name: 'Tooth Map',
        description: 'Dental tooth mapping and charting tool',
        icon: Icons.grid_view,
        isUniversal: false,
      ),
    );

    // Pelvic Diagram - 妇科专属工具
    ToolRegistry.registerTool(
      'pelvic_diagram',
      (config) => PelvicDiagramTool(config: config),
      const ToolMetadata(
        toolId: 'pelvic_diagram',
        name: 'Pelvic Diagram',
        description: 'Gynecological pelvic examination tool',
        icon: Icons.medical_information,
        isUniversal: false,
      ),
    );
  }

  // 配置科室工具关联
  static void _configureDepartmentTools() {
    // Dental Department 工具配置
    DepartmentRegistry.addToolConfig(
      'dental',
      'tooth_map',
      const ToolConfig(
        toolId: 'tooth_map',
        config: {
          'show_numbering': true,
          'enable_conditions': true,
          'default_view': 'adult',
        },
        displayOrder: 1,
        isRequired: false,
      ),
    );

    DepartmentRegistry.addToolConfig(
      'dental',
      'progress_notes',
      const ToolConfig(
        toolId: 'progress_notes',
        config: {
          'template': 'dental',
          'required_fields': ['examination', 'diagnosis', 'treatment_plan'],
        },
        displayOrder: 2,
        isRequired: true,
      ),
    );

    // Gynecology Department 工具配置
    DepartmentRegistry.addToolConfig(
      'gynecology',
      'pelvic_diagram',
      const ToolConfig(
        toolId: 'pelvic_diagram',
        config: {
          'show_anatomy_labels': true,
          'enable_annotations': true,
          'default_view': 'frontal',
        },
        displayOrder: 1,
        isRequired: false,
      ),
    );

    DepartmentRegistry.addToolConfig(
      'gynecology',
      'progress_notes',
      const ToolConfig(
        toolId: 'progress_notes',
        config: {
          'template': 'gynecology',
          'required_fields': ['examination', 'assessment'],
        },
        displayOrder: 2,
        isRequired: true,
      ),
    );
  }

  // 获取默认科室
  static String getDefaultDepartment() => 'dental';

  // 获取科室的默认工具
  static List<String> getDefaultToolsForDepartment(String departmentId) {
    switch (departmentId) {
      case 'dental':
        return ['tooth_map', 'progress_notes'];
      case 'gynecology':
        return ['pelvic_diagram', 'progress_notes'];
      default:
        return ['progress_notes'];
    }
  }

  // 验证配置
  static bool validateConfiguration() {
    try {
      // 检查默认科室是否存在
      final defaultDept = getDefaultDepartment();
      if (!DepartmentRegistry.hasDepartment(defaultDept)) {
        debugPrint('EncounterConfig: Default department not found: $defaultDept');
        return false;
      }

      // 检查科室配置是否有效
      if (!DepartmentRegistry.validateDepartmentConfig(defaultDept)) {
        debugPrint('EncounterConfig: Invalid department configuration: $defaultDept');
        return false;
      }

      // 检查通用工具是否存在
      final universalTools = ToolRegistry.getUniversalTools();
      if (universalTools.isEmpty) {
        debugPrint('EncounterConfig: No universal tools registered');
        return false;
      }

      debugPrint('EncounterConfig: Configuration validation passed');
      return true;
    } catch (e) {
      debugPrint('EncounterConfig: Configuration validation failed: $e');
      return false;
    }
  }

  // 获取配置统计信息
  static Map<String, dynamic> getConfigStats() {
    return {
      'initialized': _isInitialized,
      'tool_stats': ToolRegistry.getStats(),
      'department_stats': DepartmentRegistry.getStats(),
      'default_department': getDefaultDepartment(),
    };
  }

  // 重置配置（主要用于测试）
  static void reset() {
    ToolRegistry.clear();
    DepartmentRegistry.clear();
    _isInitialized = false;
    debugPrint('EncounterConfig: Configuration reset');
  }

  // 检查是否已初始化
  static bool get isInitialized => _isInitialized;
}

// 配置常量
class EncounterConstants {
  // 默认配置
  static const String defaultDepartment = 'dental';
  static const String defaultStatus = 'active';
  
  // 工具配置
  static const Map<String, dynamic> defaultToolConfig = {
    'auto_save': true,
    'save_interval': 30, // seconds
    'validation_enabled': true,
  };
  
  // 科室配置
  static const Map<String, List<String>> departmentExamTypes = {
    'dental': [
      'Routine Checkup',
      'Dental Cleaning',
      'Tooth Extraction',
      'Root Canal',
      'Filling',
      'Emergency Visit',
      'Consultation',
    ],
    'gynecology': [
      'Routine Checkup',
      'Annual Exam',
      'Prenatal Visit',
      'Postpartum Visit',
      'Contraception Consultation',
      'Menstrual Issues',
      'Fertility Consultation',
      'Emergency Visit',
    ],
  };
  
  // UI 配置
  static const Map<String, dynamic> uiConfig = {
    'tool_grid_columns': 2,
    'tool_card_height': 120.0,
    'auto_save_indicator': true,
    'show_tool_descriptions': true,
  };
}
