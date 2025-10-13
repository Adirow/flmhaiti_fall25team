import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dental_roots/models/form_template.dart';

class FormRendererWidget extends StatefulWidget {
  final List<FormSection> sections;
  final Map<String, List<FormQuestion>> questionsBySection;
  final bool isPreviewMode;
  final Map<String, dynamic>? initialAnswers;
  final Function(Map<String, dynamic>)? onAnswersChanged;

  const FormRendererWidget({
    super.key,
    required this.sections,
    required this.questionsBySection,
    this.isPreviewMode = false,
    this.initialAnswers,
    this.onAnswersChanged,
  });

  @override
  State<FormRendererWidget> createState() => _FormRendererWidgetState();
}

class _FormRendererWidgetState extends State<FormRendererWidget> {
  final Map<String, dynamic> _answers = {};
  final Map<String, TextEditingController> _textControllers = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialAnswers != null) {
      _answers.addAll(widget.initialAnswers!);
    }
    _initializeControllers();
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    for (final section in widget.sections) {
      final questions = widget.questionsBySection[section.id] ?? [];
      for (final question in questions) {
        if (question.type == QuestionType.text || question.type == QuestionType.number) {
          final controller = TextEditingController();
          if (_answers.containsKey(question.logicalId)) {
            controller.text = _answers[question.logicalId].toString();
          }
          _textControllers[question.logicalId] = controller;
        }
      }
    }
  }

  void _updateAnswer(String logicalId, dynamic value) {
    setState(() {
      _answers[logicalId] = value;
    });
    widget.onAnswersChanged?.call(_answers);
  }

  bool _isQuestionVisible(FormQuestion question) {
    if (question.visibleIf == null) return true;

    // Simple visibility evaluator
    for (final entry in question.visibleIf!.entries) {
      final requiredValue = entry.value;
      final actualValue = _answers[entry.key];
      
      if (actualValue != requiredValue) {
        return false;
      }
    }
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.sections.map((section) {
        final questions = widget.questionsBySection[section.id] ?? [];
        final visibleQuestions = questions.where(_isQuestionVisible).toList();
        
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
              // Section header
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
              
              // Questions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: visibleQuestions.map((question) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: _buildQuestionWidget(question, theme),
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

  Widget _buildQuestionWidget(FormQuestion question, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question label
        RichText(
          text: TextSpan(
            text: question.label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            children: [
              if (question.required)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Question input
        _buildQuestionInput(question, theme),
        
        // Preview mode indicator
        if (widget.isPreviewMode)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Preview mode - inputs are disabled',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionInput(FormQuestion question, ThemeData theme) {
    switch (question.type) {
      case QuestionType.boolean:
        return _buildBooleanInput(question, theme);
      case QuestionType.text:
        return _buildTextInput(question, theme);
      case QuestionType.number:
        return _buildNumberInput(question, theme);
      case QuestionType.date:
        return _buildDateInput(question, theme);
      case QuestionType.choice:
        return _buildChoiceInput(question, theme);
      case QuestionType.multichoice:
        return _buildMultiChoiceInput(question, theme);
    }
  }

  Widget _buildBooleanInput(FormQuestion question, ThemeData theme) {
    final value = _answers[question.logicalId] as bool?;
    
    return SwitchListTile(
      title: Text('Yes'),
      value: value ?? false,
      onChanged: widget.isPreviewMode 
          ? null 
          : (newValue) => _updateAnswer(question.logicalId, newValue),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildTextInput(FormQuestion question, ThemeData theme) {
    final controller = _textControllers[question.logicalId];
    
    return TextFormField(
      controller: controller,
      enabled: !widget.isPreviewMode,
      decoration: InputDecoration(
        hintText: 'Enter your answer...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      maxLines: question.label.toLowerCase().contains('description') ||
                question.label.toLowerCase().contains('comment') ? 3 : 1,
      onChanged: widget.isPreviewMode 
          ? null 
          : (value) => _updateAnswer(question.logicalId, value),
    );
  }

  Widget _buildNumberInput(FormQuestion question, ThemeData theme) {
    final controller = _textControllers[question.logicalId];
    
    return TextFormField(
      controller: controller,
      enabled: !widget.isPreviewMode,
      decoration: InputDecoration(
        hintText: 'Enter a number...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      onChanged: widget.isPreviewMode 
          ? null 
          : (value) {
              final numValue = double.tryParse(value);
              _updateAnswer(question.logicalId, numValue);
            },
    );
  }

  Widget _buildDateInput(FormQuestion question, ThemeData theme) {
    final value = _answers[question.logicalId] as DateTime?;
    
    return InkWell(
      onTap: widget.isPreviewMode ? null : () => _selectDate(question),
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

  Widget _buildChoiceInput(FormQuestion question, ThemeData theme) {
    final choices = question.choiceOptions;
    final value = _answers[question.logicalId] as String?;
    
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: 'Select an option...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: choices.map((choice) {
        return DropdownMenuItem(
          value: choice,
          child: Text(choice),
        );
      }).toList(),
      onChanged: widget.isPreviewMode 
          ? null 
          : (newValue) => _updateAnswer(question.logicalId, newValue),
    );
  }

  Widget _buildMultiChoiceInput(FormQuestion question, ThemeData theme) {
    final choices = question.choiceOptions;
    final selectedChoices = _answers[question.logicalId] as List<String>? ?? [];
    
    return Column(
      children: choices.map((choice) {
        final isSelected = selectedChoices.contains(choice);
        
        return CheckboxListTile(
          title: Text(choice),
          value: isSelected,
          onChanged: widget.isPreviewMode 
              ? null 
              : (selected) {
                  final newSelection = List<String>.from(selectedChoices);
                  if (selected == true) {
                    newSelection.add(choice);
                  } else {
                    newSelection.remove(choice);
                  }
                  _updateAnswer(question.logicalId, newSelection);
                },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Future<void> _selectDate(FormQuestion question) async {
    final currentValue = _answers[question.logicalId] as DateTime?;
    
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentValue ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (selectedDate != null) {
      _updateAnswer(question.logicalId, selectedDate);
    }
  }
}
