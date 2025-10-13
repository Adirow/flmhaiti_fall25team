import 'package:flutter/material.dart';
import 'encounter_screen_new.dart';
import '../../screens/encounters/encounter_screen.dart';

class EncounterTestPage extends StatelessWidget {
  const EncounterTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encounter System Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'New Encounter Architecture',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewEncounterScreen(
                      patientId: '00000000-0000-0000-0000-000000000001', // 使用有效的UUID格式
                      // providerId 和 clinicId 将从 SupabaseUtils 获取
                    ),
                  ),
                );
              },
              child: const Text('Create New Encounter'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EncounterScreen(
                      patientId: '00000000-0000-0000-0000-000000000002', // 使用有效的UUID格式
                      // providerId 和 clinicId 将从 SupabaseUtils 获取
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Test Original EncounterScreen'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                _showArchitectureInfo(context);
              },
              child: const Text('Show Architecture Info'),
            ),
          ],
        ),
      ),
    );
  }

  void _showArchitectureInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Encounter Architecture'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Dynamic department selection'),
              Text('• Configurable tools per department'),
              Text('• Tool data persistence'),
              Text('• Event-driven architecture'),
              Text('• Extensible design'),
              SizedBox(height: 16),
              Text(
                'Current Tools:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Progress Notes (Universal)'),
              Text('• Tooth Map (Dental)'),
              Text('• Pelvic Diagram (Gynecology)'),
              SizedBox(height: 16),
              Text(
                'Current Departments:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Dental'),
              Text('• Gynecology'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
