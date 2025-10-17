import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flmhaiti_fall25team/models/appointment.dart';
import 'package:flmhaiti_fall25team/models/patient.dart';
import 'package:flmhaiti_fall25team/services/appointment_service.dart';
import 'package:flmhaiti_fall25team/screens/appointments/appointment_form_screen.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;
  final Patient? patient;
  final VoidCallback onUpdated;

  const AppointmentDetailScreen({
    super.key,
    required this.appointment,
    this.patient,
    required this.onUpdated,
  });

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final _appointmentService = AppointmentService();
  late Appointment _appointment;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
  }

  Color _getStatusColor(AppointmentStatus status, ColorScheme colorScheme) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return const Color(0xFF43A047);
      case AppointmentStatus.inProgress:
        return colorScheme.primary;
      case AppointmentStatus.completed:
        return colorScheme.secondary;
      case AppointmentStatus.cancelled:
        return colorScheme.error;
      default:
        return const Color(0xFFFFA726);
    }
  }

  String _getStatusLabel(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.inProgress:
        return 'In Progress';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  Future<void> _updateAppointmentStatus(AppointmentStatus newStatus) async {
    setState(() => _isLoading = true);
    
    try {
      final updatedAppointment = await _appointmentService.updateAppointmentStatus(
        _appointment.id,
        newStatus,
      );
      
      setState(() {
        _appointment = updatedAppointment;
        _isLoading = false;
      });
      
      widget.onUpdated();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment status updated to ${_getStatusLabel(newStatus)}')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $e')),
        );
      }
    }
  }

  void _editAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentFormScreen(
          appointment: _appointment,
          onSaved: () {
            widget.onUpdated();
            Navigator.pop(context); // Go back to appointments list
          },
        ),
      ),
    );
  }

  void _showRescheduleDialog() {
    DateTime selectedDate = _appointment.startTime;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(_appointment.startTime);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Reschedule Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Date: ${DateFormat('MMM dd, yyyy').format(selectedDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
              ),
              ListTile(
                title: Text('Time: ${selectedTime.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (time != null) {
                    setState(() => selectedTime = time);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final newStartTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  final duration = _appointment.endTime?.difference(_appointment.startTime) ?? const Duration(hours: 1);
                  final newEndTime = newStartTime.add(duration);
                  
                  final updatedAppointment = await _appointmentService.rescheduleAppointment(
                    _appointment.id,
                    newStartTime,
                    newEndTime,
                  );
                  
                  Navigator.pop(context);
                  setState(() => _appointment = updatedAppointment);
                  widget.onUpdated();
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Appointment rescheduled')),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to reschedule: $e')),
                    );
                  }
                }
              },
              child: const Text('Reschedule'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColor(_appointment.status, colorScheme);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editAppointment,
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'confirm':
                  await _updateAppointmentStatus(AppointmentStatus.confirmed);
                  break;
                case 'start':
                  await _updateAppointmentStatus(AppointmentStatus.inProgress);
                  break;
                case 'complete':
                  await _updateAppointmentStatus(AppointmentStatus.completed);
                  break;
                case 'cancel':
                  await _updateAppointmentStatus(AppointmentStatus.cancelled);
                  break;
                case 'reschedule':
                  _showRescheduleDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              if (_appointment.status == AppointmentStatus.scheduled)
                const PopupMenuItem(value: 'confirm', child: Text('Confirm')),
              if (_appointment.status == AppointmentStatus.confirmed)
                const PopupMenuItem(value: 'start', child: Text('Start Appointment')),
              if (_appointment.status == AppointmentStatus.inProgress)
                const PopupMenuItem(value: 'complete', child: Text('Complete')),
              if (_appointment.status != AppointmentStatus.cancelled && 
                  _appointment.status != AppointmentStatus.completed)
                const PopupMenuItem(value: 'reschedule', child: Text('Reschedule')),
              if (_appointment.status != AppointmentStatus.cancelled)
                const PopupMenuItem(value: 'cancel', child: Text('Cancel')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStatusIcon(_appointment.status),
                                size: 16,
                                color: statusColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _getStatusLabel(_appointment.status),
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'ID: ${_appointment.id.substring(0, 8)}...',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Patient Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient Information',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.person,
                          'Name',
                          widget.patient?.name ?? 'Unknown Patient',
                        ),
                        if (widget.patient != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.phone,
                            'Phone',
                            widget.patient!.phone,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.cake,
                            'Age',
                            '${widget.patient!.age} years old',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Appointment Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment Information',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.medical_services,
                          'Reason',
                          _appointment.reason,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.calendar_today,
                          'Date',
                          DateFormat('EEEE, MMM dd, yyyy').format(_appointment.startTime),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.access_time,
                          'Time',
                          '${DateFormat('h:mm a').format(_appointment.startTime)} - ${DateFormat('h:mm a').format(_appointment.endTime ?? _appointment.startTime.add(const Duration(hours: 1)))}',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.schedule,
                          'Duration',
                          '${(_appointment.endTime?.difference(_appointment.startTime) ?? const Duration(hours: 1)).inMinutes} minutes',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Timestamps
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timestamps',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.add_circle_outline,
                          'Created',
                          DateFormat('MMM dd, yyyy h:mm a').format(_appointment.createdAt),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.update,
                          'Last Updated',
                          DateFormat('MMM dd, yyyy h:mm a').format(_appointment.updatedAt),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Icons.schedule;
      case AppointmentStatus.confirmed:
        return Icons.check_circle;
      case AppointmentStatus.inProgress:
        return Icons.play_circle;
      case AppointmentStatus.completed:
        return Icons.check_circle_outline;
      case AppointmentStatus.cancelled:
        return Icons.cancel;
    }
  }
}
