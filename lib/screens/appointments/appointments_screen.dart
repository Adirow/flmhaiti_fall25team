import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  DateTime _selectedDate = DateTime.now();

  final _mockAppointments = [
    {'time': '09:00', 'patient': 'Sarah Johnson', 'reason': 'Routine Checkup', 'status': 'confirmed'},
    {'time': '10:30', 'patient': 'Michael Chen', 'reason': 'Dental Cleaning', 'status': 'scheduled'},
    {'time': '11:45', 'patient': 'Emily Davis', 'reason': 'Tooth Extraction', 'status': 'confirmed'},
    {'time': '14:00', 'patient': 'James Wilson', 'reason': 'Root Canal', 'status': 'in_progress'},
    {'time': '15:30', 'patient': 'Maria Garcia', 'reason': 'Consultation', 'status': 'scheduled'},
  ];

  void _changeDate(int days) {
    setState(() => _selectedDate = _selectedDate.add(Duration(days: days)));
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'confirmed':
        return const Color(0xFF43A047);
      case 'in_progress':
        return colorScheme.primary;
      case 'completed':
        return colorScheme.secondary;
      case 'cancelled':
        return colorScheme.error;
      default:
        return const Color(0xFFFFA726);
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      default:
        return status[0].toUpperCase() + status.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: colorScheme.primary),
                  onPressed: () => _changeDate(-1),
                ),
                Column(
                  children: [
                    Text(DateFormat('EEEE').format(_selectedDate), style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                    const SizedBox(height: 4),
                    Text(DateFormat('MMM dd, yyyy').format(_selectedDate), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: colorScheme.primary),
                  onPressed: () => _changeDate(1),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mockAppointments.length,
              itemBuilder: (context, index) {
                final appointment = _mockAppointments[index];
                final statusColor = _getStatusColor(appointment['status']!, colorScheme);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, size: 16, color: colorScheme.primary),
                          const SizedBox(height: 4),
                          Text(appointment['time']!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.primary)),
                        ],
                      ),
                    ),
                    title: Text(appointment['patient']!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(appointment['reason']!, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(_getStatusLabel(appointment['status']!), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                      onSelected: (value) {},
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'confirm', child: Text('Confirm')),
                        const PopupMenuItem(value: 'reschedule', child: Text('Reschedule')),
                        const PopupMenuItem(value: 'cancel', child: Text('Cancel')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAppointmentDialog(),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('New Appointment'),
      ),
    );
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final patientController = TextEditingController();
        final reasonController = TextEditingController();
        TimeOfDay selectedTime = TimeOfDay.now();

        return AlertDialog(
          title: const Text('New Appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: patientController,
                  decoration: const InputDecoration(labelText: 'Patient Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text('Time: ${selectedTime.format(context)}'),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final time = await showTimePicker(context: context, initialTime: selectedTime);
                    if (time != null) selectedTime = time;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Appointment scheduled successfully')),
                );
              },
              child: const Text('Schedule'),
            ),
          ],
        );
      },
    );
  }
}
