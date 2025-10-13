import 'package:flutter/material.dart';
import 'package:dental_roots/models/form_template.dart';
import 'package:dental_roots/models/questionnaire_session.dart';
import 'package:dental_roots/repositories/questionnaire_repository.dart';
import 'package:dental_roots/repositories/questionnaire_repository_debug.dart';
import 'package:dental_roots/screens/questionnaires/questionnaire_fill_page.dart';

class QuestionnairesHomePage extends StatefulWidget {
  final String patientId;
  final String patientName;

  const QuestionnairesHomePage({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<QuestionnairesHomePage> createState() => _QuestionnairesHomePageState();
}

class _QuestionnairesHomePageState extends State<QuestionnairesHomePage> {
  final _repository = QuestionnaireRepository();
  final _debugRepository = QuestionnaireRepositoryDebug();
  
  List<Department> _departments = [];
  List<FormTemplate> _templates = [];
  List<QuestionnaireSessionSummary> _sessions = [];
  
  Department? _selectedDepartment;
  FormTemplate? _selectedTemplate;
  
  bool _isLoadingDepartments = true;
  bool _isLoadingTemplates = false;
  bool _isLoadingSessions = true;
  bool _isCreatingSession = false;
  
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadDepartments(),
      _loadSessions(),
    ]);
  }

  Future<void> _loadDepartments() async {
    setState(() {
      _isLoadingDepartments = true;
      _error = null;
    });

    try {
      // First test the connection
      await _debugRepository.testConnection();
      
      // Then load departments with debug info
      final departments = await _debugRepository.getAvailableDepartmentsSimple();
      setState(() {
        _departments = departments;
        _isLoadingDepartments = false;
      });
    } catch (e) {
      print('Error loading departments: $e');
      setState(() {
        _error = e.toString();
        _isLoadingDepartments = false;
      });
    }
  }

  Future<void> _loadTemplates(Department department) async {
    setState(() {
      _isLoadingTemplates = true;
      _selectedTemplate = null;
    });

    try {
      final templates = await _debugRepository.getActiveTemplatesByDepartmentSimple(department);
      setState(() {
        _templates = templates;
        _isLoadingTemplates = false;
      });
    } catch (e) {
      print('Error loading templates: $e');
      setState(() {
        _error = e.toString();
        _isLoadingTemplates = false;
      });
    }
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoadingSessions = true;
    });

    try {
      // Use simple session loading for now
      final sessions = await _debugRepository.getPatientSessionsSimple(widget.patientId);
      
      // Convert to summaries with empty stats for now
      final summaries = sessions.map((session) => QuestionnaireSessionSummary(
        session: session,
        answeredQuestions: 0,
        completedQuestions: 0,
        patientName: widget.patientName,
        patientPhone: null,
      )).toList();
      
      setState(() {
        _sessions = summaries;
        _isLoadingSessions = false;
      });
    } catch (e) {
      print('Error loading sessions: $e');
      setState(() {
        _error = e.toString();
        _isLoadingSessions = false;
      });
    }
  }

  void _onDepartmentChanged(Department? department) {
    setState(() {
      _selectedDepartment = department;
      _selectedTemplate = null;
    });
    
    if (department != null) {
      _loadTemplates(department);
    }
  }

  void _onTemplateChanged(FormTemplate? template) {
    setState(() {
      _selectedTemplate = template;
    });
  }

  Future<void> _startNewQuestionnaire() async {
    if (_selectedTemplate == null) return;

    setState(() => _isCreatingSession = true);

    try {
      // Check if there's an incomplete session for this template
      final incompleteSession = await _repository.getIncompleteSession(
        widget.patientId,
        _selectedTemplate!.id,
      );

      if (incompleteSession != null) {
        // Continue existing session
        _navigateToFillPage(incompleteSession);
      } else {
        // Create new session
        final newSession = await _repository.createSession(
          patientId: widget.patientId,
          template: _selectedTemplate!,
        );
        _navigateToFillPage(newSession);
      }
    } catch (e) {
      setState(() => _isCreatingSession = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start questionnaire: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToFillPage(QuestionnaireSession session) async {
    setState(() => _isCreatingSession = false);
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionnaireFillPage(session: session),
      ),
    );
    
    if (result == true) {
      _loadSessions(); // Refresh sessions list
    }
  }

  void _continueSession(QuestionnaireSessionSummary sessionSummary) {
    _navigateToFillPage(sessionSummary.session);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Questionnaires - ${widget.patientName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInitialData,
          ),
        ],
      ),
      body: _error != null
          ? _buildErrorView(theme, colorScheme)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildNewQuestionnaireCard(theme, colorScheme),
                  const SizedBox(height: 24),
                  _buildSessionsHistory(theme, colorScheme),
                ],
              ),
            ),
    );
  }

  Widget _buildErrorView(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load questionnaires',
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
            onPressed: _loadInitialData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNewQuestionnaireCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_circle_outline, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Start New Questionnaire',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Department selection
            if (_isLoadingDepartments)
              const Center(child: CircularProgressIndicator())
            else if (_departments.isEmpty)
              Text(
                'No questionnaire templates available',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              )
            else ...[
              DropdownButtonFormField<Department>(
                value: _selectedDepartment,
                decoration: InputDecoration(
                  labelText: 'Select Department',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                ),
                items: _departments.map((dept) {
                  return DropdownMenuItem(
                    value: dept,
                    child: Text(dept.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: _onDepartmentChanged,
              ),
              const SizedBox(height: 16),
              
              // Template selection
              if (_selectedDepartment != null) ...[
                if (_isLoadingTemplates)
                  const Center(child: CircularProgressIndicator())
                else if (_templates.isEmpty)
                  Text(
                    'No templates available for ${_selectedDepartment!.name}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  )
                else ...[
                  DropdownButtonFormField<FormTemplate>(
                    value: _selectedTemplate,
                    decoration: InputDecoration(
                      labelText: 'Select Questionnaire',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    items: _templates.map((template) {
                      return DropdownMenuItem(
                        value: template,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(template.name),
                            if (template.description.isNotEmpty)
                              Text(
                                template.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: _onTemplateChanged,
                  ),
                  const SizedBox(height: 16),
                  
                  // Start button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedTemplate == null || _isCreatingSession
                          ? null
                          : _startNewQuestionnaire,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isCreatingSession
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Start Questionnaire'),
                    ),
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsHistory(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Previous Questionnaires',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        if (_isLoadingSessions)
          const Center(child: CircularProgressIndicator())
        else if (_sessions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 48,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No previous questionnaires',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sessions.length,
            itemBuilder: (context, index) {
              final sessionSummary = _sessions[index];
              return _SessionCard(
                sessionSummary: sessionSummary,
                onTap: () => _continueSession(sessionSummary),
              );
            },
          ),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final QuestionnaireSessionSummary sessionSummary;
  final VoidCallback onTap;

  const _SessionCard({
    required this.sessionSummary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final session = sessionSummary.session;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getStatusColor(session.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getStatusIcon(session.status),
              color: _getStatusColor(session.status),
            ),
          ),
          title: Text(
            session.templateName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                '${session.departmentDisplayName} • ${session.statusDisplayName}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.schedule,
                    label: _formatDate(session.startedAt),
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(width: 8),
                  if (sessionSummary.answeredQuestions > 0)
                    _InfoChip(
                      icon: Icons.check_circle,
                      label: '${sessionSummary.completedQuestions}/${sessionSummary.answeredQuestions}',
                      colorScheme: colorScheme,
                    ),
                ],
              ),
              if (session.isInProgress && sessionSummary.answeredQuestions > 0) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: sessionSummary.completionPercentage / 100,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              ],
            ],
          ),
          trailing: Icon(
            session.isInProgress ? Icons.edit : Icons.visibility,
            color: colorScheme.primary,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Color _getStatusColor(SessionStatus status) {
    switch (status) {
      case SessionStatus.inProgress:
        return Colors.orange;
      case SessionStatus.submitted:
        return Colors.green;
      case SessionStatus.archived:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(SessionStatus status) {
    switch (status) {
      case SessionStatus.inProgress:
        return Icons.edit;
      case SessionStatus.submitted:
        return Icons.check_circle;
      case SessionStatus.archived:
        return Icons.archive;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
