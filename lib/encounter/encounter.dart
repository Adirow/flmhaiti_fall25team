// Encounter System - Main Export File
// This file provides a single entry point for the encounter system

// Core
export 'core/encounter_context.dart';
export 'core/interfaces.dart';
export 'core/base_tool_widget.dart';
export 'core/tool_registry.dart';
export 'core/department_registry.dart';

// Models
export 'models/department.dart';
export 'models/encounter_tool.dart';
export 'models/department_tool.dart';
export 'models/encounter_tool_data.dart';

// Services
export 'services/encounter_service.dart';
export 'services/department_service.dart';
export 'services/tool_data_service.dart';

// Configuration
export 'config/encounter_config.dart';

// Departments
export 'departments/dental_department.dart';
export 'departments/gynecology_department.dart';

// Tools
export 'tools/universal/progress_notes_tool.dart';
export 'tools/dental/tooth_map_tool.dart';
export 'tools/gynecology/pelvic_diagram_tool.dart';

// Widgets
export 'widgets/encounter_screen_new.dart';
export 'widgets/tool_grid.dart';
export 'widgets/department_selector.dart';
