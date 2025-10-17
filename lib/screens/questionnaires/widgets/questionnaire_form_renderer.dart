import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flmhaiti_fall25team/models/form_template.dart';

/// 🧩 This is a safer and improved version of the form renderer used for questionnaires.
/// It fixes type mismatches (bool vs DateTime), ensures logicalId-based mapping,
/// and prevents crashes when loading mixed data from Supabase.
class QuestionnaireFormRenderer extends StatefulWidget {
  final List<FormSection> sections;
  final Map<String, List<FormQuestion>> questionsBySection;
  final bool isPreviewMode;
  final Map<String, dynamic>? initialAnswers;
  final Function(Map<String, dynamic>)? onAnswersChanged;

  const QuestionnaireFormRenderer({
    super.key,
    required this.sections,
    required this.questionsBySection,
    this.isPreviewMode = false,
    this.initialAnswers,
    this.onAnswersChanged,
  });

  @override
  State<QuestionnaireFormRenderer> createState() => _QuestionnaireFormRendererState();
}

class _QuestionnaireFormRendererState extends State<QuestionnaireFormRenderer> {
  final Map<String, dynamic> _answers = {};
  final Map<String, TextEditingController> _textControllers = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialAnswers != null) {
      _answers.addAll(widget.initialAnswers!);
    }
    _normalizeInitialValues();
    _initializeControllers();
  }

  @override
  void dispose() {
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// Convert stored JSON/string values into correct Dart types
  void _normalizeInitialValues() {
    for (final section in widget.sections) {
      for (final q in widget.questionsBySection[section.id] ?? []) {
        final raw = _answers[q.logicalId];
        if (raw == null) continue;

        try {
          switch (q.type) {
            case QuestionType.date:
              if (raw is String && raw.isNotEmpty) {
                _answers[q.logicalId] = DateTime.parse(raw);
              } else if (raw is! DateTime) {
                _answers.remove(q.logicalId); // Remove invalid date
              }
              break;
              
            case QuestionType.boolean:
              if (raw is String) {
                _answers[q.logicalId] = raw.toLowerCase() == 'true' || raw == '1';
              } else if (raw is int) {
                _answers[q.logicalId] = raw == 1;
              } else if (raw is! bool) {
                _answers[q.logicalId] = false; // Default to false for invalid values
              }
              break;
              
            case QuestionType.number:
              if (raw is String && raw.isNotEmpty) {
                final parsed = double.tryParse(raw);
                if (parsed != null) {
                  _answers[q.logicalId] = parsed;
                } else {
                  _answers.remove(q.logicalId); // Remove invalid number
                }
              } else if (raw is! num) {
                _answers.remove(q.logicalId); // Remove non-numeric values
              }
              break;
              
            case QuestionType.choice:
              if (raw is! String || !q.choiceOptions.contains(raw)) {
                _answers.remove(q.logicalId); // Remove invalid choice
              }
              break;
              
            case QuestionType.multichoice:
              if (raw is List) {
                // Keep only valid string choices
                final validChoices = raw
                    .whereType<String>()
                    .where((choice) => q.choiceOptions.contains(choice))
                    .toList();
                _answers[q.logicalId] = validChoices;
              } else if (raw is String && raw.isNotEmpty) {
                // Handle comma-separated strings
                final choices = raw.split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty && q.choiceOptions.contains(s))
                    .toList();
                _answers[q.logicalId] = choices;
              } else {
                _answers[q.logicalId] = <String>[]; // Default to empty list
              }
              break;
              
            case QuestionType.text:
              if (raw is! String) {
                _answers[q.logicalId] = raw.toString(); // Convert to string
              }
              break;
          }
        } catch (e) {
          // If any conversion fails, remove the invalid value
          print('Failed to normalize value for ${q.logicalId}: $e');
          _answers.remove(q.logicalId);
        }
      }
    }
  }

  void _initializeControllers() {
    for (final section in widget.sections) {
      for (final q in widget.questionsBySection[section.id] ?? []) {
        if (q.type == QuestionType.text || q.type == QuestionType.number) {
          final controller = TextEditingController();
          
          // Safe text initialization
          if (_answers.containsKey(q.logicalId)) {
            final value = _answers[q.logicalId];
            if (value != null) {
              try {
                controller.text = value.toString();
              } catch (e) {
                print('Failed to set controller text for ${q.logicalId}: $e');
                controller.text = '';
              }
            }
          }
          
          _textControllers[q.logicalId] = controller;
        }
      }
    }
  }

  void _updateAnswer(String logicalId, dynamic value) {
    setState(() {
      _answers[logicalId] = value;
    });
    widget.onAnswersChanged?.call({logicalId: value});
  }

  bool _isVisible(FormQuestion q) {
    if (q.visibleIf == null) return true;
    
    for (final entry in q.visibleIf!.entries) {
      final currentValue = _answers[entry.key];
      final expectedValue = entry.value;
      
      // Safe comparison handling different types
      if (!_valuesMatch(currentValue, expectedValue)) {
        return false;
      }
    }
    return true;
  }
  
  bool _valuesMatch(dynamic current, dynamic expected) {
    if (current == expected) return true;
    
    // Handle string comparisons
    if (current is String && expected is String) {
      return current.toLowerCase() == expected.toLowerCase();
    }
    
    // Handle boolean comparisons
    if (expected is bool) {
      if (current is bool) return current == expected;
      if (current is String) {
        return (current.toLowerCase() == 'true' || current == '1') == expected;
      }
      if (current is int) return (current == 1) == expected;
    }
    
    // Handle numeric comparisons
    if (expected is num && current is String) {
      final parsed = num.tryParse(current);
      return parsed == expected;
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.sections.map((section) {
        final visibleQuestions = (widget.questionsBySection[section.id] ?? [])
            .where(_isVisible)
            .toList();

        if (visibleQuestions.isEmpty) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  section.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: visibleQuestions.map((q) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: _buildQuestion(q, theme),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuestion(FormQuestion q, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: q.label,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            children: [
              if (q.required)
                const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildInput(q, theme),
      ],
    );
  }

  Widget _buildInput(FormQuestion q, ThemeData theme) {
    switch (q.type) {
      case QuestionType.boolean:
        return _buildBool(q);
      case QuestionType.text:
        return _buildText(q);
      case QuestionType.number:
        return _buildNumber(q);
      case QuestionType.date:
        return _buildDate(q, theme);
      case QuestionType.choice:
        return _buildChoice(q);
      case QuestionType.multichoice:
        return _buildMultiChoice(q);
    }
  }

  Widget _buildBool(FormQuestion q) {
    // Safe type conversion for boolean values
    bool val = false;
    final raw = _answers[q.logicalId];
    
    if (raw is bool) {
      val = raw;
    } else if (raw is String) {
      val = raw.toLowerCase() == 'true' || raw == '1';
    } else if (raw is int) {
      val = raw == 1;
    }
    
    return SwitchListTile(
      title: const Text('Yes'),
      value: val,
      onChanged: widget.isPreviewMode ? null : (v) => _updateAnswer(q.logicalId, v),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildText(FormQuestion q) {
    final c = _textControllers[q.logicalId];
    return TextFormField(
      controller: c,
      enabled: !widget.isPreviewMode,
      decoration: InputDecoration(
        hintText: 'Enter your answer...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      maxLines: q.label.toLowerCase().contains('comment') ? 3 : 1,
      onChanged: widget.isPreviewMode ? null : (v) => _updateAnswer(q.logicalId, v),
    );
  }

  Widget _buildNumber(FormQuestion q) {
    final c = _textControllers[q.logicalId];
    return TextFormField(
      controller: c,
      enabled: !widget.isPreviewMode,
      decoration: InputDecoration(
        hintText: 'Enter a number...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      onChanged: widget.isPreviewMode
          ? null
          : (v) => _updateAnswer(q.logicalId, double.tryParse(v)),
    );
  }

  Widget _buildDate(FormQuestion q, ThemeData theme) {
    final raw = _answers[q.logicalId];
    DateTime? value;
    if (raw is DateTime) {
      value = raw;
    } else if (raw is String) {
      try {
        value = DateTime.parse(raw);
      } catch (_) {}
    }

    return InkWell(
      onTap: widget.isPreviewMode ? null : () => _selectDate(q),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              value != null
                  ? '${value.day}/${value.month}/${value.year}'
                  : 'Select date...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: value != null ? null : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoice(FormQuestion q) {
    final choices = q.choiceOptions;
    
    // Safe type conversion for choice values
    String? val;
    final raw = _answers[q.logicalId];
    if (raw is String && choices.contains(raw)) {
      val = raw;
    }
    
    return DropdownButtonFormField<String>(
      value: val,
      decoration: InputDecoration(
        hintText: 'Select an option...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: choices.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: widget.isPreviewMode ? null : (v) => _updateAnswer(q.logicalId, v),
    );
  }

  Widget _buildMultiChoice(FormQuestion q) {
    final choices = q.choiceOptions;
    
    // Safe type conversion for multi-choice values
    List<String> selected = [];
    final raw = _answers[q.logicalId];
    if (raw is List) {
      selected = raw.whereType<String>().toList();
    } else if (raw is String && raw.isNotEmpty) {
      // Handle comma-separated strings
      selected = raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }
    
    return Column(
      children: choices.map((choice) {
        final isSel = selected.contains(choice);
        return CheckboxListTile(
          title: Text(choice),
          value: isSel,
          onChanged: widget.isPreviewMode
              ? null
              : (checked) {
                  final updated = List<String>.from(selected);
                  if (checked == true) {
                    updated.add(choice);
                  } else {
                    updated.remove(choice);
                  }
                  _updateAnswer(q.logicalId, updated);
                },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Future<void> _selectDate(FormQuestion q) async {
    final current = _answers[q.logicalId] is DateTime
        ? _answers[q.logicalId] as DateTime
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      _updateAnswer(q.logicalId, picked);
    }
  }
}
