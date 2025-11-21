import 'package:flutter/material.dart';
import 'package:flmhaiti_fall25team/auth/supabase_auth_manager.dart';
import 'package:flmhaiti_fall25team/localization/l10n_extension.dart';
import 'package:flmhaiti_fall25team/models/user_profile.dart';
import 'package:flmhaiti_fall25team/screens/appointments/appointments_screen.dart';
import 'package:flmhaiti_fall25team/screens/auth/login_screen.dart';
import 'package:flmhaiti_fall25team/screens/billing/billing_screen.dart';
import 'package:flmhaiti_fall25team/screens/encounters/encounter_screen.dart';
import 'package:flmhaiti_fall25team/screens/forms/template_list_page.dart';
import 'package:flmhaiti_fall25team/screens/patients/patient_list_screen.dart';
import 'package:flmhaiti_fall25team/localization/language_selector.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      endDrawer: const _DashboardProfileDrawer(),
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
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
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
                  title: 'Billing',
                  subtitle: 'Invoices & payments',
                  icon: Icons.receipt_long,
                  color: const Color(0xFFEF6C00),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BillingScreen()),
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

class _ProfileLoadingView extends StatelessWidget {
  final String message;

  const _ProfileLoadingView({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProfileErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 32, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePayload {
  _ProfilePayload({
    required this.user,
    this.profile,
  });

  final User user;
  final UserProfile? profile;

  String get displayName {
    final userProfile = profile;
    if (userProfile != null) {
      final value = userProfile.fullName.trim();
      if (value.isNotEmpty) {
        return value;
      }
    }

    final metadata = user.userMetadata;
    if (metadata != null) {
      final candidate = metadata['full_name'] ?? metadata['name'];
      if (candidate is String && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }

    final email = user.email ?? '';
    if (email.isNotEmpty) {
      return email;
    }

    return '';
  }

  String? get roleLabel {
    final role = profile?.role;
    if (role == null) {
      return null;
    }
    final name = role.name.replaceAll('_', ' ');
    if (name.isEmpty) {
      return null;
    }
    return name[0].toUpperCase() + name.substring(1);
  }

  String get email {
    final profileEmail = profile?.email.trim();
    if (profileEmail != null && profileEmail.isNotEmpty) {
      return profileEmail;
    }
    final userEmail = user.email ?? '';
    if (userEmail.isNotEmpty) {
      return userEmail;
    }
    final metadata = user.userMetadata;
    if (metadata != null) {
      final candidate = metadata['email'];
      if (candidate is String && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }
    return '';
  }

  String get initials {
    final source = displayName.trim();
    if (source.isEmpty) {
      return '?';
    }
    return source[0].toUpperCase();
  }
}

class _DashboardProfileDrawer extends StatefulWidget {
  const _DashboardProfileDrawer();

  @override
  State<_DashboardProfileDrawer> createState() => _DashboardProfileDrawerState();
}

class _DashboardProfileDrawerState extends State<_DashboardProfileDrawer> {
  final SupabaseAuthManager _authManager = SupabaseAuthManager();
  late Future<_ProfilePayload> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<_ProfilePayload> _loadProfile() async {
    final user = _authManager.currentUser;
    if (user == null) {
      throw StateError('User not authenticated');
    }
    final profile = await _authManager.getUserProfile(user.id);
    return _ProfilePayload(user: user, profile: profile);
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = _loadProfile();
    });
  }

  Future<void> _handleLogout() async {
    await _authManager.signOut();
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width < 360 ? width : 360,
      child: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.dashboardProfileTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: FutureBuilder<_ProfilePayload>(
                  future: _profileFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _ProfileLoadingView(message: l10n.dashboardProfileLoading);
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      return _ProfileErrorView(
                        message: l10n.dashboardProfileError,
                        onRetry: _refreshProfile,
                      );
                    }

                    final payload = snapshot.data!;
                    final displayName = payload.displayName.isNotEmpty
                        ? payload.displayName
                        : l10n.dashboardProfileNameLabel;
                    final roleLabel = payload.roleLabel ?? '—';
                    final email = payload.email.isNotEmpty ? payload.email : '—';

                    return ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        CircleAvatar(
                          radius: 32,
                          child: Text(
                            payload.initials,
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _ProfileInfoItem(
                          label: l10n.dashboardProfileNameLabel,
                          value: displayName,
                        ),
                        const SizedBox(height: 16),
                        _ProfileInfoItem(
                          label: l10n.dashboardProfileRoleLabel,
                          value: roleLabel,
                        ),
                        const SizedBox(height: 16),
                        _ProfileInfoItem(
                          label: l10n.dashboardProfileEmailLabel,
                          value: email,
                        ),
                        const SizedBox(height: 32),
                        const Divider(height: 1),
                        const SizedBox(height: 24),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.logout),
                          title: Text(l10n.dashboardProfileLogout),
                          onTap: _handleLogout,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium,
        ),
      ],
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
