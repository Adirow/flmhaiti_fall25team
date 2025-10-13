import 'package:flutter/material.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _allergiesController = TextEditingController();
  
  bool _hasDiabetes = false;
  bool _hasHeartIssues = false;
  bool _isPregnant = false;
  
  final Map<String, String> _dynamicAnswers = {};
  
  final _dynamicQuestions = [
    {'id': '1', 'text': 'Do you smoke?', 'type': 'boolean'},
    {'id': '2', 'text': 'Any previous surgeries?', 'type': 'text'},
    {'id': '3', 'text': 'Current medications', 'type': 'text'},
    {'id': '4', 'text': 'Family history of dental issues?', 'type': 'boolean'},
  ];

  @override
  void dispose() {
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _saveHistory() async {
    if (!_formKey.currentState!.validate()) return;

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medical history saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Medical History'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveHistory),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Core Medical Information', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _allergiesController,
                      decoration: InputDecoration(
                        labelText: 'Allergies',
                        hintText: 'List any known allergies',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Diabetes'),
                      subtitle: const Text('Does the patient have diabetes?'),
                      value: _hasDiabetes,
                      activeColor: colorScheme.primary,
                      onChanged: (value) => setState(() => _hasDiabetes = value),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Heart Issues'),
                      subtitle: const Text('Any cardiovascular problems?'),
                      value: _hasHeartIssues,
                      activeColor: colorScheme.primary,
                      onChanged: (value) => setState(() => _hasHeartIssues = value),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Pregnancy'),
                      subtitle: const Text('Is the patient currently pregnant?'),
                      value: _isPregnant,
                      activeColor: colorScheme.primary,
                      onChanged: (value) => setState(() => _isPregnant = value),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text('Additional Questions', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._dynamicQuestions.map((question) {
                final isBoolean = question['type'] == 'boolean';
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: isBoolean
                      ? SwitchListTile(
                          title: Text(question['text']!),
                          value: _dynamicAnswers[question['id']] == 'true',
                          activeColor: colorScheme.primary,
                          onChanged: (value) => setState(() => _dynamicAnswers[question['id']!] = value.toString()),
                          contentPadding: EdgeInsets.zero,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(question['text']!, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter answer',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: colorScheme.surface,
                              ),
                              onChanged: (value) => _dynamicAnswers[question['id']!] = value,
                            ),
                          ],
                        ),
                );
              }),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveHistory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: Text('Save Medical History', style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
