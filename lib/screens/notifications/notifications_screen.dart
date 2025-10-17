import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flmhaiti_fall25team/services/notification_service.dart';
import 'package:flmhaiti_fall25team/screens/appointments/appointment_detail_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _notificationService = NotificationService();

  List<AppointmentReminder> _todayReminders = [];
  List<AppointmentReminder> _upcomingReminders = [];
  List<AppointmentReminder> _overdueReminders = [];
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    
    try {
      final today = await _notificationService.getTodayAppointments();
      final upcoming = await _notificationService.getUpcomingReminders();
      final overdue = await _notificationService.getOverdueAppointments();
      
      setState(() {
        _todayReminders = today;
        _upcomingReminders = upcoming;
        _overdueReminders = overdue;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load notifications: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Today',
              icon: Badge(
                isLabelVisible: _todayReminders.isNotEmpty,
                label: Text('${_todayReminders.length}'),
                child: const Icon(Icons.today),
              ),
            ),
            Tab(
              text: 'Upcoming',
              icon: Badge(
                isLabelVisible: _upcomingReminders.isNotEmpty,
                label: Text('${_upcomingReminders.length}'),
                child: const Icon(Icons.schedule),
              ),
            ),
            Tab(
              text: 'Overdue',
              icon: Badge(
                isLabelVisible: _overdueReminders.isNotEmpty,
                label: Text('${_overdueReminders.length}'),
                child: const Icon(Icons.warning),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsList(_todayReminders, 'No appointments today'),
                _buildNotificationsList(_upcomingReminders, 'No upcoming reminders'),
                _buildNotificationsList(_overdueReminders, 'No overdue appointments'),
              ],
            ),
    );
  }

  Widget _buildNotificationsList(List<AppointmentReminder> reminders, String emptyMessage) {
    if (reminders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return _buildNotificationCard(reminder);
        },
      ),
    );
  }

  Widget _buildNotificationCard(AppointmentReminder reminder) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToAppointmentDetail(reminder),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: reminder.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  reminder.icon,
                  color: reminder.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            reminder.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: reminder.color,
                            ),
                          ),
                        ),
                        Text(
                          _formatAppointmentTime(reminder.appointment.startTime),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reminder.patient.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reminder.appointment.reason,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 14,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          reminder.patient.phone,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                onSelected: (value) => _handleNotificationAction(reminder, value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'call',
                    child: Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 8),
                        Text('Call Patient'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'remind',
                    child: Row(
                      children: [
                        Icon(Icons.send),
                        SizedBox(width: 8),
                        Text('Send Reminder'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAppointmentDetail(AppointmentReminder reminder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailScreen(
          appointment: reminder.appointment,
          patient: reminder.patient,
          onUpdated: () => _loadNotifications(),
        ),
      ),
    );
  }

  void _handleNotificationAction(AppointmentReminder reminder, String action) async {
    switch (action) {
      case 'view':
        _navigateToAppointmentDetail(reminder);
        break;
      case 'call':
        _showCallDialog(reminder.patient.phone);
        break;
      case 'remind':
        await _sendReminder(reminder);
        break;
    }
  }

  void _showCallDialog(String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Patient'),
        content: Text('Call $phoneNumber?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would open the phone dialer
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling $phoneNumber...')),
              );
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendReminder(AppointmentReminder reminder) async {
    try {
      await _notificationService.sendReminder(reminder);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder sent to ${reminder.patient.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send reminder: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatAppointmentTime(DateTime dateTime) {
    if (_isToday(dateTime)) {
      return DateFormat('h:mm a').format(dateTime);
    } else if (_isTomorrow(dateTime)) {
      return 'Tomorrow ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      return DateFormat('MMM dd, h:mm a').format(dateTime);
    }
  }

  bool _isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  bool _isTomorrow(DateTime dateTime) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dateTime.year == tomorrow.year &&
        dateTime.month == tomorrow.month &&
        dateTime.day == tomorrow.day;
  }
}
