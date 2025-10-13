import 'package:flutter/material.dart';
import 'package:dental_roots/models/form_template.dart';
import 'package:dental_roots/repositories/form_repository.dart';
import 'package:dental_roots/screens/forms/widgets/section_editor_widget.dart';
import 'package:dental_roots/screens/forms/widgets/question_editor_widget.dart';
import 'package:dental_roots/screens/forms/widgets/form_preview_widget.dart';

class TemplateEditorPage extends StatefulWidget {
  final FormTemplate? template;
  final Department department;

  const TemplateEditorPage({
    super.key,
    this.template,
    required this.department,
  });

  @override
  State<TemplateEditorPage> createState() => _TemplateEditorPageState();
}

class _TemplateEditorPageState extends State<TemplateEditorPage>
    with TickerProviderStateMixin {
  final _formRepository = FormRepository();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  late TabController _tabController;
  
  // Template data
  late FormTemplate _template;
  List<FormSection> _sections = [];
  Map<String, List<FormQuestion>> _questionsBySection = {};
  
  // UI state
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  String? _selectedSectionId;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeTemplate();
    _loadTemplateData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initializeTemplate() {
    if (widget.template != null) {
      // Editing existing template
      _template = widget.template!;
      _nameController.text = _template.name;
      _descriptionController.text = _template.description;
    } else {
      // Creating new template
      _template = FormTemplate(
        id: '',
        department: widget.department,
        name: '',
        version: 1,
        description: '',
        isActive: true,
        createdBy: '', // Will be set when saving
        createdAt: DateTime.now(),
      );
    }
  }

  Future<void> _loadTemplateData() async {
    if (widget.template == null) return;

    setState(() => _isLoading = true);

    try {
      final sections = await _formRepository.getSectionsByTemplateId(_template.id);
      final questionsBySection = await _formRepository.getQuestionsByTemplateId(_template.id);
      
      setState(() {
        _sections = sections;
        _questionsBySection = questionsBySection;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load template data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  void _onTemplateNameChanged(String value) {
    _template = _template.copyWith(name: value);
    _markAsChanged();
  }

  void _onTemplateDescriptionChanged(String value) {
    _template = _template.copyWith(description: value);
    _markAsChanged();
  }

  void _onDepartmentChanged(Department department) {
    _template = _template.copyWith(department: department);
    _markAsChanged();
  }

  void _addSection() {
    final newSection = FormSection(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      templateId: _template.id,
      title: 'New Section',
      sortOrder: _sections.length,
    );
    
    setState(() {
      _sections.add(newSection);
      _questionsBySection[newSection.id] = [];
      _selectedSectionId = newSection.id;
    });
    _markAsChanged();
  }

  void _updateSection(FormSection section) {
    final index = _sections.indexWhere((s) => s.id == section.id);
    if (index != -1) {
      setState(() {
        _sections[index] = section;
      });
      _markAsChanged();
    }
  }

  void _deleteSection(String sectionId) {
    setState(() {
      _sections.removeWhere((s) => s.id == sectionId);
      _questionsBySection.remove(sectionId);
      if (_selectedSectionId == sectionId) {
        _selectedSectionId = _sections.isNotEmpty ? _sections.first.id : null;
      }
    });
    _markAsChanged();
  }

  void _reorderSections(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    
    setState(() {
      final section = _sections.removeAt(oldIndex);
      _sections.insert(newIndex, section);
      
      // Update sort orders
      for (int i = 0; i < _sections.length; i++) {
        _sections[i] = _sections[i].copyWith(sortOrder: i);
      }
    });
    _markAsChanged();
  }

  void _addQuestion(String sectionId, FormQuestion question) {
    setState(() {
      _questionsBySection[sectionId] = [
        ...(_questionsBySection[sectionId] ?? []),
        question,
      ];
    });
    _markAsChanged();
  }

  void _updateQuestion(String sectionId, FormQuestion question) {
    final questions = _questionsBySection[sectionId] ?? [];
    final index = questions.indexWhere((q) => q.id == question.id);
    
    if (index != -1) {
      setState(() {
        questions[index] = question;
      });
      _markAsChanged();
    }
  }

  void _deleteQuestion(String sectionId, String questionId) {
    setState(() {
      _questionsBySection[sectionId]?.removeWhere((q) => q.id == questionId);
    });
    _markAsChanged();
  }

  void _reorderQuestions(String sectionId, int oldIndex, int newIndex) {
    final questions = _questionsBySection[sectionId];
    if (questions == null) return;
    
    if (newIndex > oldIndex) newIndex--;
    
    setState(() {
      final question = questions.removeAt(oldIndex);
      questions.insert(newIndex, question);
      
      // Update sort orders
      for (int i = 0; i < questions.length; i++) {
        questions[i] = questions[i].copyWith(sortOrder: i);
      }
    });
    _markAsChanged();
  }

  Future<void> _saveTemplate() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a template name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedTemplate = _template.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        updatedAt: DateTime.now(),
      );

      await _formRepository.saveTemplateStructure(
        template: updatedTemplate,
        sections: _sections,
        questionsBySection: _questionsBySection,
      );

      setState(() {
        _hasUnsavedChanges = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Template saved successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save template: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Do you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(widget.template != null ? 'Edit Template' : 'New Template'),
          actions: [
            if (_hasUnsavedChanges)
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'UNSAVED',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isLoading ? null : _saveTemplate,
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Template', icon: Icon(Icons.settings)),
              Tab(text: 'Sections', icon: Icon(Icons.view_list)),
              Tab(text: 'Preview', icon: Icon(Icons.preview)),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildTemplateTab(theme, colorScheme),
                  _buildSectionsTab(theme, colorScheme),
                  _buildPreviewTab(theme, colorScheme),
                ],
              ),
      ),
    );
  }

  Widget _buildTemplateTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Template Information',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Template Name *',
                      hintText: 'Enter template name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onTemplateNameChanged,
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<Department>(
                    value: _template.department,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                    items: Department.values.map((dept) {
                      return DropdownMenuItem(
                        value: dept,
                        child: Text(dept.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (dept) {
                      if (dept != null) _onDepartmentChanged(dept);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter template description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: _onTemplateDescriptionChanged,
                  ),
                  
                  if (widget.template != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.numbers,
                          label: 'Version ${_template.version}',
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(width: 8),
                        _InfoChip(
                          icon: _template.isActive ? Icons.check_circle : Icons.archive,
                          label: _template.isActive ? 'Active' : 'Archived',
                          colorScheme: colorScheme,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionsTab(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        // Sections panel
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
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
                        'Sections',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addSection,
                        tooltip: 'Add Section',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SectionEditorWidget(
                    sections: _sections,
                    selectedSectionId: _selectedSectionId,
                    onSectionSelected: (sectionId) {
                      setState(() => _selectedSectionId = sectionId);
                    },
                    onSectionUpdated: _updateSection,
                    onSectionDeleted: _deleteSection,
                    onSectionsReordered: _reorderSections,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Questions panel
        Expanded(
          flex: 2,
          child: _selectedSectionId != null
              ? QuestionEditorWidget(
                  sectionId: _selectedSectionId!,
                  questions: _questionsBySection[_selectedSectionId!] ?? [],
                  onQuestionAdded: (question) => _addQuestion(_selectedSectionId!, question),
                  onQuestionUpdated: (question) => _updateQuestion(_selectedSectionId!, question),
                  onQuestionDeleted: (questionId) => _deleteQuestion(_selectedSectionId!, questionId),
                  onQuestionsReordered: (oldIndex, newIndex) => 
                      _reorderQuestions(_selectedSectionId!, oldIndex, newIndex),
                )
              : Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 64,
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Select a section to edit questions',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildPreviewTab(ThemeData theme, ColorScheme colorScheme) {
    return FormPreviewWidget(
      template: _template,
      sections: _sections,
      questionsBySection: _questionsBySection,
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
          Icon(icon, size: 14, color: colorScheme.primary),
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
