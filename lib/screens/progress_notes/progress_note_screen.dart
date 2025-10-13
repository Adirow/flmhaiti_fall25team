import 'package:flutter/material.dart';

class ProgressNoteScreen extends StatefulWidget {
  const ProgressNoteScreen({super.key});

  @override
  State<ProgressNoteScreen> createState() => _ProgressNoteScreenState();
}

class _ProgressNoteScreenState extends State<ProgressNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _anesthesiaController = TextEditingController();
  final _doseController = TextEditingController();
  final _materialsController = TextEditingController();
  final _complicationsController = TextEditingController();
  final _followUpController = TextEditingController();

  @override
  void dispose() {
    _anesthesiaController.dispose();
    _doseController.dispose();
    _materialsController.dispose();
    _complicationsController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress note saved successfully')),
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
        title: const Text('Progress Note'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveNote),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Procedure Details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _anesthesiaController,
                      decoration: InputDecoration(
                        labelText: 'Anesthesia Type',
                        hintText: 'e.g., Local, General, Sedation',
                        prefixIcon: Icon(Icons.medication_outlined, color: colorScheme.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _doseController,
                      decoration: InputDecoration(
                        labelText: 'Dosage',
                        hintText: 'e.g., 2% Lidocaine, 1.8ml',
                        prefixIcon: Icon(Icons.science_outlined, color: colorScheme.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _materialsController,
                      decoration: InputDecoration(
                        labelText: 'Materials Used',
                        hintText: 'List all materials and instruments',
                        prefixIcon: Icon(Icons.build_outlined, color: colorScheme.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Post-Procedure', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _complicationsController,
                      decoration: InputDecoration(
                        labelText: 'Complications',
                        hintText: 'Note any complications or adverse reactions',
                        prefixIcon: Icon(Icons.warning_amber_outlined, color: colorScheme.tertiary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _followUpController,
                      decoration: InputDecoration(
                        labelText: 'Follow-Up Plan',
                        hintText: 'Instructions and next steps',
                        prefixIcon: Icon(Icons.event_note_outlined, color: colorScheme.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      maxLines: 4,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter follow-up plan' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: Text('Save Progress Note', style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
