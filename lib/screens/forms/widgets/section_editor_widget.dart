import 'package:flutter/material.dart';
import 'package:flmhaiti_fall25team/models/form_template.dart';

class SectionEditorWidget extends StatelessWidget {
  final List<FormSection> sections;
  final String? selectedSectionId;
  final Function(String) onSectionSelected;
  final Function(FormSection) onSectionUpdated;
  final Function(String) onSectionDeleted;
  final Function(int, int) onSectionsReordered;

  const SectionEditorWidget({
    super.key,
    required this.sections,
    required this.selectedSectionId,
    required this.onSectionSelected,
    required this.onSectionUpdated,
    required this.onSectionDeleted,
    required this.onSectionsReordered,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (sections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_list,
              size: 48,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No sections yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a section to get started',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sections.length,
      onReorder: onSectionsReordered,
      itemBuilder: (context, index) {
        final section = sections[index];
        final isSelected = section.id == selectedSectionId;

        return _SectionTile(
          key: ValueKey(section.id),
          section: section,
          isSelected: isSelected,
          onTap: () => onSectionSelected(section.id),
          onUpdated: onSectionUpdated,
          onDeleted: () => onSectionDeleted(section.id),
        );
      },
    );
  }
}

class _SectionTile extends StatefulWidget {
  final FormSection section;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(FormSection) onUpdated;
  final VoidCallback onDeleted;

  const _SectionTile({
    super.key,
    required this.section,
    required this.isSelected,
    required this.onTap,
    required this.onUpdated,
    required this.onDeleted,
  });

  @override
  State<_SectionTile> createState() => _SectionTileState();
}

class _SectionTileState extends State<_SectionTile> {
  final _titleController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.section.title;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _titleController.text = widget.section.title;
    });
  }

  void _saveChanges() {
    if (_titleController.text.trim().isNotEmpty) {
      final updatedSection = widget.section.copyWith(
        title: _titleController.text.trim(),
      );
      widget.onUpdated(updatedSection);
    }
    setState(() => _isEditing = false);
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _titleController.text = widget.section.title;
    });
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Section'),
        content: Text('Are you sure you want to delete "${widget.section.title}"? This will also delete all questions in this section.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDeleted();
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
        color: widget.isSelected 
            ? colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: widget.isSelected 
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
      ),
      child: ListTile(
        leading: Icon(
          Icons.drag_handle,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        title: _isEditing
            ? TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                autofocus: true,
                onSubmitted: (_) => _saveChanges(),
              )
            : Text(
                widget.section.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  color: widget.isSelected ? colorScheme.primary : null,
                ),
              ),
        subtitle: Text(
          'Section ${widget.section.sortOrder + 1}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: _isEditing
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: _saveChanges,
                    tooltip: 'Save',
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: _cancelEditing,
                    tooltip: 'Cancel',
                  ),
                ],
              )
            : PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _startEditing();
                      break;
                    case 'delete':
                      _confirmDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Rename'),
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
        onTap: _isEditing ? null : widget.onTap,
      ),
    );
  }
}
