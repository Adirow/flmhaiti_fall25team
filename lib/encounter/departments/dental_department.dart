import 'package:flutter/material.dart';
import '../core/interfaces.dart';
import '../core/encounter_context.dart';

class DentalDepartment implements IDepartment {
  @override
  String get departmentId => 'dental';

  @override
  String get displayName => 'Dental';

  @override
  List<String> get availableToolIds => ['tooth_map', 'progress_notes'];

  @override
  List<String> get examTypes => [
        'Routine Checkup',
        'Dental Cleaning',
        'Tooth Extraction',
        'Root Canal',
        'Filling',
        'Emergency Visit',
        'Consultation',
      ];

  @override
  Widget? buildCustomHeader(EncounterContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_hospital,
            color: Colors.blue.shade700,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dental Examination',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                Text(
                  'Comprehensive oral health assessment',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Map<String, dynamic> getDefaultMetadata() {
    return {
      'department': 'dental',
      'specialty': 'general_dentistry',
      'requires_xray': false,
      'requires_anesthesia': false,
      'follow_up_required': false,
      'default_duration_minutes': 30,
    };
  }

  @override
  bool validateEncounter(EncounterContext context) {
    // 牙科特定的验证逻辑
    final metadata = context.metadata;
    
    // 检查是否有必要的牙科信息
    if (metadata['chief_complaint']?.toString().isEmpty ?? true) {
      return false;
    }

    // 如果有牙位图数据，验证其完整性
    final toothMapData = context.getToolData<Map<String, dynamic>>('tooth_map');
    if (toothMapData != null) {
      // 验证牙位图数据结构
      if (!toothMapData.containsKey('teeth_conditions')) {
        return false;
      }
    }

    // 验证进度记录
    final progressData = context.getToolData<Map<String, dynamic>>('progress_notes');
    if (progressData != null) {
      final requiredFields = ['examination', 'diagnosis'];
      for (final field in requiredFields) {
        if (progressData[field]?.toString().isEmpty ?? true) {
          return false;
        }
      }
    }

    return true;
  }

  @override
  Map<String, dynamic> getToolConfig(String toolId) {
    switch (toolId) {
      case 'tooth_map':
        return {
          'show_numbering': true,
          'enable_conditions': true,
          'default_view': 'adult',
          'available_conditions': [
            'healthy',
            'caries',
            'filled',
            'crown',
            'missing',
            'implant',
            'root_canal',
          ],
          'color_coding': {
            'healthy': '#4CAF50',
            'caries': '#F44336',
            'filled': '#2196F3',
            'crown': '#FF9800',
            'missing': '#9E9E9E',
            'implant': '#9C27B0',
            'root_canal': '#795548',
          },
        };
      case 'progress_notes':
        return {
          'template': 'dental',
          'required_fields': ['examination', 'diagnosis', 'treatment_plan'],
          'sections': [
            {
              'title': 'Chief Complaint',
              'field': 'chief_complaint',
              'type': 'textarea',
              'required': true,
            },
            {
              'title': 'Clinical Examination',
              'field': 'examination',
              'type': 'textarea',
              'required': true,
            },
            {
              'title': 'Diagnosis',
              'field': 'diagnosis',
              'type': 'textarea',
              'required': true,
            },
            {
              'title': 'Treatment Plan',
              'field': 'treatment_plan',
              'type': 'textarea',
              'required': false,
            },
            {
              'title': 'Notes',
              'field': 'notes',
              'type': 'textarea',
              'required': false,
            },
          ],
        };
      default:
        return {};
    }
  }
}
