import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dental_roots/models/form_template.dart';
import 'package:dental_roots/services/form_service.dart';

class QuestionEditorWidget extends StatefulWidget {
  final String sectionId;
  final List<FormQuestion> questions;
  final Function(FormQuestion) onQuestionAdded;
  final Function(FormQuestion) onQuestionUpdated;
  final Function(String) onQuestionDeleted;
  final Function(int, int) onQuestionsReordered;

  const QuestionEditorWidget({
    super.key,
    required this.sectionId,
    required this.questions,
    required this.onQuestionAdded,
    required this.onQuestionUpdated,
    required this.onQuestionDeleted,
    required this.onQuestionsReordered,
  });

  @override
  State<QuestionEditorWidget> createState() => _QuestionEditorWidgetState();
}

class _QuestionEditorWidgetState extends State<QuestionEditorWidget> {
  final _formService = FormService();

  void _addNewQuestion() {
    showDialog(
      context: context,
      builder: (context) => _QuestionEditorDialog(
        onSave: (question) {
          final newQuestion = question.copyWith(
            id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
            sectionId: widget.sectionId,
            sortOrder: widget.questions.length,
          );
          widget.onQuestionAdded(newQuestion);
        },
      ),
    );
  }

  void _editQuestion(FormQuestion question) {
    showDialog(
      context: context,
      builder: (context) => _QuestionEditorDialog(
        question: question,
        onSave: widget.onQuestionUpdated,
      ),
    );
  }

  void _searchAndReuseQuestion() {
    showDialog(
      context: context,
      builder: (context) => _QuestionSearchDialog(
        formService: _formService,
        onQuestionSelected: (question) {
          final reusedQuestion = question.copyWith(
            id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
            sectionId: widget.sectionId,
            sortOrder: widget.questions.length,
          );
          widget.onQuestionAdded(reusedQuestion);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Questions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchAndReuseQuestion,
                  tooltip: 'Reuse Question',
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNewQuestion,
                  tooltip: 'Add Question',
                ),
              ],
            ),
          ),
          
          // Questions list
          Expanded(
            child: widget.questions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 48,
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No questions yet',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a question to get started',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: widget.questions.length,
                    onReorder: widget.onQuestionsReordered,
                    itemBuilder: (context, index) {
                      final question = widget.questions[index];
                      return _QuestionTile(
                        key: ValueKey(question.id),
                        question: question,
                        onEdit: () => _editQuestion(question),
                        onDelete: () => widget.onQuestionDeleted(question.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  final FormQuestion question;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _QuestionTile({
    super.key,
    required this.question,
    required this.onEdit,
    required this.onDelete,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: Text('Are you sure you want to delete "${question.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(
          Icons.drag_handle,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        title: Text(
          question.label,
          style: theme.textTheme.titleSmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                _InfoChip(
                  label: question.typeDisplayName,
                  color: _getTypeColor(question.type),
                ),
                const SizedBox(width: 8),
                if (question.required)
                  _InfoChip(
                    label: 'Required',
                    color: Colors.red,
                  ),
                if (question.visibleIf != null)
                  const SizedBox(width: 8),
                if (question.visibleIf != null)
                  _InfoChip(
                    label: 'Conditional',
                    color: Colors.orange,
                  ),
              ],
            ),
            if (question.logicalId.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'ID: ${question.logicalId}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit();
                break;
              case 'delete':
                _confirmDelete(context);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        onTap: onEdit,
      ),
    );
  }

  Color _getTypeColor(QuestionType type) {
    switch (type) {
      case QuestionType.boolean:
        return Colors.blue;
      case QuestionType.text:
        return Colors.green;
      case QuestionType.number:
        return Colors.purple;
      case QuestionType.date:
        return Colors.orange;
      case QuestionType.choice:
        return Colors.teal;
      case QuestionType.multichoice:
        return Colors.indigo;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _QuestionEditorDialog extends StatefulWidget {
  final FormQuestion? question;
  final Function(FormQuestion) onSave;

  const _QuestionEditorDialog({
    this.question,
    required this.onSave,
  });

  @override
  State<_QuestionEditorDialog> createState() => _QuestionEditorDialogState();
}

class _QuestionEditorDialogState extends State<_QuestionEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _formService = FormService();
  final _labelController = TextEditingController();
  final _logicalIdController = TextEditingController();
  final _choicesController = TextEditingController();
  final _visibleIfController = TextEditingController();

  QuestionType _selectedType = QuestionType.text;
  bool _isRequired = false;

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _labelController.text = widget.question!.label;
      _logicalIdController.text = widget.question!.logicalId;
      _selectedType = widget.question!.type;
      _isRequired = widget.question!.required;
      
      if (widget.question!.choiceOptions.isNotEmpty) {
        _choicesController.text = widget.question!.choiceOptions.join('\n');
      }
      
      if (widget.question!.visibleIf != null) {
        _visibleIfController.text = jsonEncode(widget.question!.visibleIf);
      }
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _logicalIdController.dispose();
    _choicesController.dispose();
    _visibleIfController.dispose();
    super.dispose();
  }

  Future<bool> _ensureUniqueLogicalId(BuildContext context, String logicalId) async {
    if (logicalId.trim().isEmpty) return true; 

    final existing = await _formService.checkDuplicateLogicalId(logicalId);
    if (existing == null) return true; 

    // show dialog
    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duplicate Logical ID'),
        content: Text(
          'This Logical ID has been used by question「${existing.label}」.\n'
          'Reuse this ID only when you want to have a newer version of the same question.\n\n'
          'Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    return proceed ?? false;
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    // check logicalId duplicate
    final logicalId = _logicalIdController.text.trim();
    final ok = await _ensureUniqueLogicalId(context, logicalId);
    if (!ok) return;

    Map<String, dynamic>? options;
    if (_selectedType == QuestionType.choice || _selectedType == QuestionType.multichoice) {
      final choices = _choicesController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (choices.isNotEmpty) {
        options = {'choices': choices};
      }
    }

    Map<String, dynamic>? visibleIf;
    if (_visibleIfController.text.trim().isNotEmpty) {
      try {
        visibleIf = jsonDecode(_visibleIfController.text.trim());
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid JSON in visible_if: $e'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final question = FormQuestion(
      id: widget.question?.id ?? '',
      sectionId: widget.question?.sectionId ?? '',
      logicalId: _logicalIdController.text.trim(),
      label: _labelController.text.trim(),
      type: _selectedType,
      options: options,
      required: _isRequired,
      visibleIf: visibleIf,
      sortOrder: widget.question?.sortOrder ?? 0,
      isActive: widget.question?.isActive ?? true,
      createdAt: widget.question?.createdAt,
    );

    widget.onSave(question);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.question != null ? 'Edit Question' : 'New Question',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(
                  labelText: 'Question Label *',
                  hintText: 'Enter the question text',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a question label';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _logicalIdController,
                decoration: const InputDecoration(
                  labelText: 'Logical ID',
                  hintText: 'e.g., dental.pain_level',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<QuestionType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Question Type *',
                  border: OutlineInputBorder(),
                ),
                items: QuestionType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (type) {
                  if (type != null) {
                    setState(() => _selectedType = type);
                  }
                },
              ),
              const SizedBox(height: 16),
              
              if (_selectedType == QuestionType.choice || _selectedType == QuestionType.multichoice) ...[
                TextFormField(
                  controller: _choicesController,
                  decoration: const InputDecoration(
                    labelText: 'Choices (one per line)',
                    hintText: 'Option 1\nOption 2\nOption 3',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (_selectedType == QuestionType.choice || _selectedType == QuestionType.multichoice) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter at least one choice';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              
              TextFormField(
                controller: _visibleIfController,
                decoration: const InputDecoration(
                  labelText: 'Visible If (JSON)',
                  hintText: '{"dental.has_pain": true}',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              
              CheckboxListTile(
                title: const Text('Required'),
                value: _isRequired,
                onChanged: (value) {
                  setState(() => _isRequired = value ?? false);
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionSearchDialog extends StatefulWidget {
  final FormService formService;
  final Function(FormQuestion) onQuestionSelected;

  const _QuestionSearchDialog({
    required this.formService,
    required this.onQuestionSelected,
  });

  @override
  State<_QuestionSearchDialog> createState() => _QuestionSearchDialogState();
}

class _QuestionSearchDialogState extends State<_QuestionSearchDialog> {
  final _searchController = TextEditingController();
  List<FormQuestion> _searchResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final results = await widget.formService.searchQuestionsByLogicalId(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Reuse Existing Question',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search by Logical ID',
                      hintText: 'e.g., dental.pain',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? const Center(
                          child: Text('No questions found. Try searching by logical ID.'),
                        )
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final question = _searchResults[index];
                            return ListTile(
                              title: Text(question.label),
                              subtitle: Text('ID: ${question.logicalId} | Type: ${question.typeDisplayName}'),
                              onTap: () {
                                widget.onQuestionSelected(question);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
            ),
            
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
