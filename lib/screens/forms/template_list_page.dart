import 'package:flutter/material.dart';
import 'package:flmhaiti_fall25team/models/form_template.dart';
import 'package:flmhaiti_fall25team/repositories/form_repository.dart';
import 'package:flmhaiti_fall25team/screens/forms/template_editor_page.dart';
import 'package:flmhaiti_fall25team/localization/l10n_extension.dart';

class TemplateListPage extends StatefulWidget {
  const TemplateListPage({super.key});

  @override
  State<TemplateListPage> createState() => _TemplateListPageState();
}

class _TemplateListPageState extends State<TemplateListPage> {
  final _formRepository = FormRepository();
  final _searchController = TextEditingController();
  
  List<FormTemplate> _templates = [];
  List<FormTemplate> _filteredTemplates = [];
  bool _isLoading = true;
  String? _error;
  
  Department _selectedDepartment = Department.dental;
  bool? _activeFilter; // null = all, true = active only, false = archived only
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTemplates() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final templates = await _formRepository.getTemplatesByDepartment(
        _selectedDepartment,
        isActive: _activeFilter,
      );
      
      setState(() {
        _templates = templates;
        _filteredTemplates = templates;
        _isLoading = false;
      });
      
      _applyFilters();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredTemplates = _templates.where((template) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          if (!template.name.toLowerCase().contains(searchLower) &&
              !template.description.toLowerCase().contains(searchLower)) {
            return false;
          }
        }
        
        return true;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _onDepartmentChanged(Department? department) {
    if (department != null) {
      setState(() {
        _selectedDepartment = department;
      });
      _loadTemplates();
    }
  }

  void _onActiveFilterChanged(bool? isActive) {
    setState(() {
      _activeFilter = isActive;
    });
    _loadTemplates();
  }

  Future<void> _createNewTemplate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemplateEditorPage(
          department: _selectedDepartment,
        ),
      ),
    );
    
    if (result == true) {
      _loadTemplates();
    }
  }

  Future<void> _editTemplate(FormTemplate template) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemplateEditorPage(
          template: template,
          department: _selectedDepartment,
        ),
      ),
    );
    
    if (result == true) {
      _loadTemplates();
    }
  }

  Future<void> _duplicateTemplate(FormTemplate template) async {
    setState(() => _isLoading = true);
    
    try {
      await _formRepository.duplicateTemplate(template.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.formsDuplicateSuccess(template.name)),
          backgroundColor: Colors.green,
        ),
      );
      _loadTemplates();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.formsDuplicateError(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _archiveTemplate(FormTemplate template) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.formsArchiveConfirmTitle),
        content: Text(context.l10n.formsArchiveConfirmMessage(template.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: Text(context.l10n.formsArchiveAction),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _formRepository.archiveTemplate(template.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.formsArchiveSuccess(template.name)),
            backgroundColor: Colors.orange,
          ),
        );
        _loadTemplates();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.formsArchiveError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.formsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTemplates,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.formsSearchHint,
                    prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                  ),
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: 16),
                
                // Filter row
                Row(
                  children: [
                    // Department filter
                    Expanded(
                      child: DropdownButtonFormField<Department>(
                        value: _selectedDepartment,
                        decoration: InputDecoration(
                          labelText: l10n.encountersDepartmentLabel,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                        items: Department.values.map((dept) {
                          return DropdownMenuItem(
                            value: dept,
                            child: Text(dept.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: _onDepartmentChanged,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Active filter
                    Expanded(
                      child: DropdownButtonFormField<bool?>(
                        value: _activeFilter,
                        decoration: InputDecoration(
                          labelText: l10n.formsStatusLabel,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                        items: [
                          DropdownMenuItem(value: null, child: Text(l10n.formsStatusAll)),
                          DropdownMenuItem(value: true, child: Text(l10n.formsStatusActive)),
                          DropdownMenuItem(value: false, child: Text(l10n.formsStatusArchived)),
                        ],
                        onChanged: _onActiveFilterChanged,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Templates list
          Expanded(
            child: _buildTemplatesList(theme, colorScheme),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewTemplate,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: Text(l10n.formsCreateNew),
      ),
    );
  }

  Widget _buildTemplatesList(ThemeData theme, ColorScheme colorScheme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      final l10n = context.l10n;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              l10n.formsLoadError,
              style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.error),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTemplates,
              child: Text(context.l10n.commonRetry),
            ),
          ],
        ),
      );
    }

    if (_filteredTemplates.isEmpty) {
      final l10n = context.l10n;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? l10n.formsNoTemplatesFound : l10n.formsNoTemplatesSearch,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty 
                  ? l10n.formsNoTemplatesSubtitle
                  : l10n.formsNoTemplatesSearchSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredTemplates.length,
      itemBuilder: (context, index) {
        final template = _filteredTemplates[index];
        return _TemplateCard(
          template: template,
          onEdit: () => _editTemplate(template),
          onDuplicate: () => _duplicateTemplate(template),
          onArchive: () => _archiveTemplate(template),
        );
      },
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final FormTemplate template;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onArchive;

  const _TemplateCard({
    required this.template,
    required this.onEdit,
    required this.onDuplicate,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: template.isActive 
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.description,
                color: template.isActive 
                    ? colorScheme.primary
                    : Colors.grey,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    template.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: template.isActive ? null : Colors.grey,
                    ),
                  ),
                ),
                if (!template.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.formsDetailsArchivedBadge,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  template.description.isNotEmpty 
                      ? template.description 
                      : l10n.formsNoDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.business,
                      label: template.departmentDisplayName,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.numbers,
                      label: 'v${template.version}',
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit();
                    break;
                  case 'duplicate':
                    onDuplicate();
                    break;
                  case 'archive':
                    onArchive();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text(l10n.formsPopupEdit),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'duplicate',
                  child: ListTile(
                    leading: const Icon(Icons.copy),
                    title: Text(l10n.formsPopupDuplicate),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                if (template.isActive)
                  PopupMenuItem(
                    value: 'archive',
                    child: ListTile(
                      leading: const Icon(Icons.archive, color: Colors.orange),
                      title: Text(l10n.formsPopupArchive, style: const TextStyle(color: Colors.orange)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
            onTap: onEdit,
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
