import 'package:flutter/material.dart';
import 'package:flmhaiti_fall25team/screens/medical_history/medical_history_screen.dart';
import 'package:flmhaiti_fall25team/screens/encounters/encounter_screen.dart';
import 'package:flmhaiti_fall25team/screens/patients/patient_edit_screen.dart';
import 'package:flmhaiti_fall25team/screens/questionnaires/questionnaires_home_page.dart';
import 'package:flmhaiti_fall25team/models/patient.dart';
import 'package:intl/intl.dart';

class PatientDetailScreen extends StatelessWidget {
  final Patient patient;

  const PatientDetailScreen({super.key, required this.patient});

  String _getGenderDisplayName(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Patient Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientEditScreen(patient: patient),
                ),
              );
              if (result == true) {
                Navigator.pop(context, true); // Return to list with refresh
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    radius: 48,
                    child: Text(
                      patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    patient.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${patient.age} years • ${_getGenderDisplayName(patient.gender)}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Born: ${DateFormat('MMM dd, yyyy').format(patient.dob)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _InfoChip(
                        icon: Icons.phone,
                        label: patient.phone,
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(width: 12),
                      _InfoChip(
                        icon: Icons.location_on,
                        label: patient.address.length > 20 
                            ? '${patient.address.substring(0, 20)}...'
                            : patient.address,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                  if (patient.bloodPressure.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _InfoChip(
                      icon: Icons.favorite,
                      label: 'BP: ${patient.bloodPressure}',
                      colorScheme: colorScheme,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Actions', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          title: 'Medical History',
                          icon: Icons.medical_information_outlined,
                          color: colorScheme.primary,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicalHistoryScreen())),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          title: 'New Encounter',
                          icon: Icons.add_circle_outline,
                          color: colorScheme.secondary,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EncounterScreen())),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          title: 'Questionnaires',
                          icon: Icons.description_outlined,
                          color: const Color(0xFF9C27B0),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuestionnairesHomePage(
                                patientId: patient.id,
                                patientName: patient.name,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _ActionCard(title: 'Appointments', icon: Icons.calendar_today, color: colorScheme.tertiary, onTap: () {})),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _ActionCard(title: 'Documents', icon: Icons.folder_outlined, color: const Color(0xFFFFA726), onTap: () {})),
                      const SizedBox(width: 12),
                      Expanded(child: _ActionCard(title: 'Reports', icon: Icons.analytics_outlined, color: const Color(0xFF43A047), onTap: () {})),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Recent Encounters', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _EncounterTile(
                    date: 'Jan 15, 2024',
                    type: 'Routine Checkup',
                    provider: 'Dr. Smith',
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _EncounterTile(
                    date: 'Dec 10, 2023',
                    type: 'Dental Cleaning',
                    provider: 'Dr. Johnson',
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _EncounterTile(
                    date: 'Nov 5, 2023',
                    type: 'Tooth Extraction',
                    provider: 'Dr. Smith',
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _InfoChip({required this.icon, required this.label, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: colorScheme.onSurface, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EncounterTile extends StatelessWidget {
  final String date;
  final String type;
  final String provider;
  final ColorScheme colorScheme;

  const _EncounterTile({required this.date, required this.type, required this.provider, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.medical_services, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('$provider • $date', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: colorScheme.onSurface.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}
