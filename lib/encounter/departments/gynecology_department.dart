import 'package:flutter/material.dart';
import '../core/interfaces.dart';
import '../core/encounter_context.dart';

class GynecologyDepartment implements IDepartment {
  @override
  String get departmentId => 'gynecology';

  @override
  String get displayName => 'Gynecology';

  @override
  List<String> get availableToolIds => ['progress_notes', 'pelvic_diagram'];

  @override
  List<String> get examTypes => [
        'Routine Checkup',
        'Annual Exam',
        'Prenatal Visit',
        'Postpartum Visit',
        'Contraception Consultation',
        'Menstrual Issues',
        'Fertility Consultation',
        'Emergency Visit',
      ];

  @override
  Widget? buildCustomHeader(EncounterContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink.shade50,
            Colors.pink.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: Colors.pink.shade700,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gynecological Examination',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade800,
                  ),
                ),
                Text(
                  'Women\'s health and reproductive care',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.pink.shade600,
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
      'department': 'gynecology',
      'specialty': 'womens_health',
      'requires_privacy': true,
      'requires_chaperone': false,
      'default_duration_minutes': 45,
      'age_restrictions': {
        'min_age': 12,
        'requires_guardian_under': 18,
      },
    };
  }

  @override
  bool validateEncounter(EncounterContext context) {
    // 妇科特定的验证逻辑
    final metadata = context.metadata;
    
    // 检查是否有必要的妇科信息
    if (metadata['chief_complaint']?.toString().isEmpty ?? true) {
      return false;
    }

    // 如果有盆腔图数据，验证其完整性
    final pelvicData = context.getToolData<Map<String, dynamic>>('pelvic_diagram');
    if (pelvicData != null) {
      // 验证盆腔图数据结构
      if (!pelvicData.containsKey('examination_findings')) {
        return false;
      }
    }

    // 验证进度记录
    final progressData = context.getToolData<Map<String, dynamic>>('progress_notes');
    if (progressData != null) {
      final requiredFields = ['examination', 'assessment'];
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
      case 'pelvic_diagram':
        return {
          'show_anatomy_labels': true,
          'enable_annotations': true,
          'default_view': 'frontal',
          'available_findings': [
            'normal',
            'inflammation',
            'mass',
            'cyst',
            'fibroid',
            'polyp',
            'adhesions',
          ],
          'color_coding': {
            'normal': '#4CAF50',
            'inflammation': '#FF5722',
            'mass': '#9C27B0',
            'cyst': '#2196F3',
            'fibroid': '#795548',
            'polyp': '#FF9800',
            'adhesions': '#607D8B',
          },
        };
      case 'progress_notes':
        return {
          'template': 'gynecology',
          'required_fields': ['examination', 'assessment'],
          'sections': [
            {
              'title': 'Chief Complaint',
              'field': 'chief_complaint',
              'type': 'textarea',
              'required': true,
            },
            {
              'title': 'Menstrual History',
              'field': 'menstrual_history',
              'type': 'textarea',
              'required': false,
            },
            {
              'title': 'Physical Examination',
              'field': 'examination',
              'type': 'textarea',
              'required': true,
            },
            {
              'title': 'Assessment',
              'field': 'assessment',
              'type': 'textarea',
              'required': true,
            },
            {
              'title': 'Plan',
              'field': 'plan',
              'type': 'textarea',
              'required': false,
            },
            {
              'title': 'Follow-up',
              'field': 'followup',
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
