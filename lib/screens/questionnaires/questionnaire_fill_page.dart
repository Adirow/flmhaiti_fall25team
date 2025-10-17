import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flmhaiti_fall25team/models/form_template.dart';
import 'package:flmhaiti_fall25team/models/questionnaire_session.dart';
import 'package:flmhaiti_fall25team/repositories/questionnaire_repository.dart';
import 'package:flmhaiti_fall25team/screens/questionnaires/widgets/questionnaire_form_renderer.dart';
class QuestionnaireFillPage extends StatefulWidget {
  final QuestionnaireSession session;

  const QuestionnaireFillPage({
    super.key,
    required this.session,
  });

  @override
  State<QuestionnaireFillPage> createState() => _QuestionnaireFillPageState();
}

class _QuestionnaireFillPageState extends State<QuestionnaireFillPage> {
  final _repository = QuestionnaireRepository();
  
  // Template structure
  List<FormSection> _sections = [];
  Map<String, List<FormQuestion>> _questionsBySection = {};
  Map<String, FormQuestion> _questionMap = {};
  
  // Form state
  Map<String, dynamic> _answers = {};
  Map<String, dynamic> _pendingAnswers = {};
  
  // UI state
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSubmitting = false;
  String? _error;
  
  // Auto-save
  Timer? _autoSaveTimer;
  static const Duration _autoSaveDelay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _loadQuestionnaireData();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadQuestionnaireData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load template structure
      final templateStructure = await _repository.loadTemplateStructure(widget.session.templateId);
      final sections = templateStructure['sections'] as List<FormSection>;
      final questionsBySection = templateStructure['questionsBySection'] as Map<String, List<FormQuestion>>;
      
      // Create question map for easy lookup
      final questionMap = _repository.createQuestionMap(questionsBySection);
      
      // Load existing answers
      final existingAnswers = await _repository.getSessionAnswerValues(widget.session.id);
      
      setState(() {
        _sections = sections;
        _questionsBySection = questionsBySection;
        _questionMap = questionMap;
        _answers = existingAnswers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onAnswerChanged(Map<String, dynamic> newAnswers) {
    setState(() {
      _answers.addAll(newAnswers);
      _pendingAnswers.addAll(newAnswers);
    });
    
    _scheduleAutoSave();
  }

  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(_autoSaveDelay, _performAutoSave);
  }

  Future<void> _performAutoSave() async {
    if (_pendingAnswers.isEmpty || widget.session.isCompleted) return;

    setState(() => _isSaving = true);

    try {
      await _repository.upsertAnswers(
        sessionId: widget.session.id,
        answers: _pendingAnswers,
        questionMap: _questionMap,
      );
      
      setState(() {
        _pendingAnswers.clear();
        _isSaving = false;
      });
    } catch (e) {
      setState(() => _isSaving = false);
      // Show error but don't interrupt user flow
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Auto-save failed: $e'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _submitQuestionnaire() async {
    // Ensure all pending answers are saved first
    if (_pendingAnswers.isNotEmpty) {
      await _performAutoSave();
    }

    setState(() => _isSubmitting = true);

    try {
      await _repository.submitSession(widget.session.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Questionnaire submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit questionnaire: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    // Auto-save before leaving
    if (_pendingAnswers.isNotEmpty && !widget.session.isCompleted) {
      await _performAutoSave();
    }
    return true;
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
          title: Text(widget.session.templateName),
          actions: [
            // Auto-save indicator
            if (_isSaving)
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Saving...',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            
            // Status indicator
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.session.isCompleted 
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.session.isCompleted ? 'SUBMITTED' : 'DRAFT',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: widget.session.isCompleted ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _buildBody(theme, colorScheme),
        bottomNavigationBar: widget.session.isCompleted 
            ? null 
            : _buildSubmitButton(theme, colorScheme),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, ColorScheme colorScheme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load questionnaire',
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
              onPressed: _loadQuestionnaireData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_sections.isEmpty) {
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
              'No questions found',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This questionnaire appears to be empty',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Questionnaire header
          Container(
            padding: const EdgeInsets.all(24),
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
                Text(
                  widget.session.templateName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.business,
                      label: widget.session.departmentDisplayName,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.numbers,
                      label: 'Version ${widget.session.templateVersion}',
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
                if (widget.session.isCompleted) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This questionnaire has been submitted and is now read-only.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Form renderer
          QuestionnaireFormRenderer(
            sections: _sections,
            questionsBySection: _questionsBySection,
            isPreviewMode: widget.session.isCompleted,
            initialAnswers: _answers,
            onAnswersChanged: widget.session.isCompleted ? null : _onAnswerChanged,
          ),
          
          // Bottom spacing for submit button
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitQuestionnaire,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Submit Questionnaire',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
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
