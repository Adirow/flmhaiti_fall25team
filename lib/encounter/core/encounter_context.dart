import 'dart:async';
import 'package:flutter/foundation.dart';

class EncounterContext {
  final String encounterId;
  final String patientId;
  final String? departmentId;
  final Map<String, dynamic> metadata;

  // 工具数据管理
  final Map<String, dynamic> _toolData = {};

  // 状态管理
  final ValueNotifier<bool> _isDirty = ValueNotifier(false);
  final ValueNotifier<bool> _isSaving = ValueNotifier(false);

  // 事件总线
  final StreamController<ToolEvent> _eventBus = StreamController<ToolEvent>.broadcast();

  EncounterContext({
    required this.encounterId,
    required this.patientId,
    this.departmentId,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? {};

  // Getters
  ValueListenable<bool> get isDirty => _isDirty;
  ValueListenable<bool> get isSaving => _isSaving;
  Stream<ToolEvent> get eventStream => _eventBus.stream;
  Map<String, dynamic> get toolData => Map.unmodifiable(_toolData);

  // 工具数据操作
  T? getToolData<T>(String toolId) {
    return _toolData[toolId] as T?;
  }

  void setToolData(String toolId, dynamic data) {
    _toolData[toolId] = data;
    _isDirty.value = true;
    _eventBus.add(ToolDataChangedEvent(toolId, data));
  }

  void clearToolData(String toolId) {
    _toolData.remove(toolId);
    _isDirty.value = true;
    _eventBus.add(ToolDataClearedEvent(toolId));
  }

  // 状态管理
  void markSaving() {
    _isSaving.value = true;
  }

  void markSaved() {
    _isDirty.value = false;
    _isSaving.value = false;
    _eventBus.add(DataSavedEvent());
  }

  void markSaveError(String error) {
    _isSaving.value = false;
    _eventBus.add(SaveErrorEvent(error));
  }

  // 事件发送
  void emitEvent(ToolEvent event) {
    _eventBus.add(event);
  }

  // 资源清理
  void dispose() {
    _isDirty.dispose();
    _isSaving.dispose();
    _eventBus.close();
  }
}

// 事件定义
abstract class ToolEvent {
  final DateTime timestamp = DateTime.now();
}

class ToolDataChangedEvent extends ToolEvent {
  final String toolId;
  final dynamic data;

  ToolDataChangedEvent(this.toolId, this.data);
}

class ToolDataClearedEvent extends ToolEvent {
  final String toolId;

  ToolDataClearedEvent(this.toolId);
}

class DataSavedEvent extends ToolEvent {}

class SaveErrorEvent extends ToolEvent {
  final String error;

  SaveErrorEvent(this.error);
}

class ToolActivatedEvent extends ToolEvent {
  final String toolId;

  ToolActivatedEvent(this.toolId);
}

class ToolDeactivatedEvent extends ToolEvent {
  final String toolId;

  ToolDeactivatedEvent(this.toolId);
}
