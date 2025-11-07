import 'package:flutter/material.dart';
import 'package:flmhaiti_fall25team/screens/patients/patient_list_screen.dart';
import 'package:flmhaiti_fall25team/screens/appointments/appointments_screen.dart';
import 'package:flmhaiti_fall25team/screens/encounters/encounter_screen.dart';
import 'package:flmhaiti_fall25team/screens/forms/template_list_page.dart';
import 'package:flmhaiti_fall25team/localization/language_selector.dart';
import 'package:flmhaiti_fall25team/localization/l10n_extension.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: LanguageSelector(compact: true),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dashboardWelcome,
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(l10n.dashboardSubheading,
                style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6))),
            const SizedBox(height: 32),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260, 
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              children: [
                _DashboardCard(
                  title: l10n.patientsCardTitle,
                  subtitle: l10n.patientsCardSubtitle,
                  icon: Icons.people_outline,
                  color: colorScheme.primary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PatientListScreen()),
                  ),
                ),
                _DashboardCard(
                  title: l10n.appointmentsCardTitle,
                  subtitle: l10n.appointmentsCardSubtitle,
                  icon: Icons.calendar_today_outlined,
                  color: colorScheme.secondary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AppointmentsScreen()),
                  ),
                ),
                _DashboardCard(
                  title: l10n.encountersCardTitle,
                  subtitle: l10n.encountersCardSubtitle,
                  icon: Icons.medical_services_outlined,
                  color: colorScheme.tertiary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EncounterScreen()),
                  ),
                ),
                _DashboardCard(
                  title: l10n.formsCardTitle,
                  subtitle: l10n.formsCardSubtitle,
                  icon: Icons.description_outlined,
                  color: const Color(0xFF9C27B0),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TemplateListPage()),
                  ),
                ),
                _DashboardCard(
                  title: l10n.reportsCardTitle,
                  subtitle: l10n.reportsCardSubtitle,
                  icon: Icons.analytics_outlined,
                  color: const Color(0xFF43A047),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(l10n.recentActivity,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _ActivityCard(
              title: l10n.todaysAppointments,
              count: '8',
              icon: Icons.calendar_today,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 12),
            _ActivityCard(
              title: l10n.pendingReviews,
              count: '3',
              icon: Icons.pending_actions,
              color: colorScheme.tertiary,
            ),
            const SizedBox(height: 12),
            _ActivityCard(
              title: l10n.newPatientsThisWeek,
              count: '5',
              icon: Icons.person_add,
              color: colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 16),
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6))),
            ],
          ),
        ),
        onSecondaryTap: () {},
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _ActivityCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: theme.textTheme.bodyLarge)),
          Text(count,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
