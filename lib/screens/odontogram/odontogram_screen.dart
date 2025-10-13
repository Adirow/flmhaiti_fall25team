import 'package:flutter/material.dart';

class OdontogramScreen extends StatefulWidget {
  const OdontogramScreen({super.key});

  @override
  State<OdontogramScreen> createState() => _OdontogramScreenState();
}

class _OdontogramScreenState extends State<OdontogramScreen> {
  final Map<int, Map<String, dynamic>> _toothData = {};
  int? _selectedTooth;

  final _upperTeeth = [18, 17, 16, 15, 14, 13, 12, 11, 21, 22, 23, 24, 25, 26, 27, 28];
  final _lowerTeeth = [48, 47, 46, 45, 44, 43, 42, 41, 31, 32, 33, 34, 35, 36, 37, 38];

  void _selectTooth(int tooth) {
    setState(() => _selectedTooth = tooth);
    _showToothDialog(tooth);
  }

  void _showToothDialog(int tooth) {
    final data = _toothData[tooth] ?? {'diagnoses': <String>[], 'treatment': <String>[], 'notes': ''};
    
    showDialog(
      context: context,
      builder: (context) {
        final diagnosisController = TextEditingController(text: (data['diagnoses'] as List).join(', '));
        final treatmentController = TextEditingController(text: (data['treatment'] as List).join(', '));
        final notesController = TextEditingController(text: data['notes']);

        return AlertDialog(
          title: Text('Tooth #$tooth'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: diagnosisController,
                  decoration: const InputDecoration(labelText: 'Diagnoses', hintText: 'e.g., Caries, Fracture'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: treatmentController,
                  decoration: const InputDecoration(labelText: 'Treatment Plan', hintText: 'e.g., Filling, Crown'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _toothData[tooth] = {
                    'diagnoses': diagnosisController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                    'treatment': treatmentController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                    'notes': notesController.text,
                  };
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Odontogram - Tooth Map'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: [
                  Text('Upper Teeth', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: _upperTeeth.map((tooth) => _ToothWidget(
                      toothNumber: tooth,
                      hasData: _toothData.containsKey(tooth),
                      isSelected: _selectedTooth == tooth,
                      onTap: () => _selectTooth(tooth),
                      colorScheme: colorScheme,
                    )).toList(),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: _lowerTeeth.map((tooth) => _ToothWidget(
                      toothNumber: tooth,
                      hasData: _toothData.containsKey(tooth),
                      isSelected: _selectedTooth == tooth,
                      onTap: () => _selectTooth(tooth),
                      colorScheme: colorScheme,
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('Lower Teeth', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface.withValues(alpha: 0.6))),
                ],
              ),
            ),
            if (_toothData.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Summary', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._toothData.entries.map((entry) {
                final tooth = entry.key;
                final data = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tooth #$tooth', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                      if ((data['diagnoses'] as List).isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('Diagnoses: ${(data['diagnoses'] as List).join(', ')}', style: theme.textTheme.bodyMedium),
                      ],
                      if ((data['treatment'] as List).isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text('Treatment: ${(data['treatment'] as List).join(', ')}', style: theme.textTheme.bodyMedium),
                      ],
                      if (data['notes'].toString().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text('Notes: ${data['notes']}', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _ToothWidget extends StatelessWidget {
  final int toothNumber;
  final bool hasData;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _ToothWidget({
    required this.toothNumber,
    required this.hasData,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 60,
        decoration: BoxDecoration(
          color: hasData ? colorScheme.tertiary.withValues(alpha: 0.2) : (isSelected ? colorScheme.primary.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? colorScheme.primary : (hasData ? colorScheme.tertiary : Colors.grey.withValues(alpha: 0.3)), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.approval, size: 20, color: hasData ? colorScheme.tertiary : Colors.grey),
            const SizedBox(height: 4),
            Text(toothNumber.toString(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: hasData ? colorScheme.tertiary : colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}
