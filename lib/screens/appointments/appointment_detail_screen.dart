import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flmhaiti_fall25team/localization/l10n_extension.dart';
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
    final l10n = context.l10n;
    switch (status) {
      case AppointmentStatus.scheduled:
        return l10n.appointmentsStatusScheduled;
      case AppointmentStatus.confirmed:
        return l10n.appointmentsStatusConfirmed;
      case AppointmentStatus.inProgress:
        return l10n.appointmentsStatusInProgress;
      case AppointmentStatus.completed:
        return l10n.appointmentsStatusCompleted;
      case AppointmentStatus.cancelled:
        return l10n.appointmentsStatusCancelled;
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
          SnackBar(content: Text(context.l10n.appointmentsStatusUpdated(_getStatusLabel(newStatus)))),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.appointmentsStatusUpdateError('$e'))),
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
          title: Text(context.l10n.appointmentsRescheduleTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(context.l10n
                    .appointmentsRescheduleDate(DateFormat('MMM dd, yyyy').format(selectedDate))),
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
                title: Text(context.l10n
                    .appointmentsRescheduleTime(selectedTime.format(context))),
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
              child: Text(context.l10n.commonCancel),
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
                      SnackBar(content: Text(context.l10n.appointmentsRescheduleSuccess)),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(context.l10n
                              .appointmentsRescheduleError('$e'))),
                    );
                  }
                }
              },
              child: Text(context.l10n.appointmentsRescheduleButton),
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appointmentsDetailTitle),
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
                PopupMenuItem(value: 'confirm', child: Text(l10n.appointmentsActionConfirm)),
              if (_appointment.status == AppointmentStatus.confirmed)
                PopupMenuItem(value: 'start', child: Text(l10n.appointmentsActionStart)),
              if (_appointment.status == AppointmentStatus.inProgress)
                PopupMenuItem(value: 'complete', child: Text(l10n.appointmentsActionComplete)),
              if (_appointment.status != AppointmentStatus.cancelled &&
                  _appointment.status != AppointmentStatus.completed)
                PopupMenuItem(value: 'reschedule', child: Text(l10n.appointmentsActionReschedule)),
              if (_appointment.status != AppointmentStatus.cancelled)
                PopupMenuItem(value: 'cancel', child: Text(l10n.commonCancel)),
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
                          l10n.appointmentsIdLabel(_appointment.id.substring(0, 8)),
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
                          l10n.appointmentsPatientInformation,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                          _buildInfoRow(
                            Icons.person,
                            l10n.appointmentsFieldName,
                            widget.patient?.name ?? l10n.appointmentsUnknownPatient,
                          ),
                          if (widget.patient != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              Icons.phone,
                              l10n.appointmentsFieldPhone,
                              widget.patient!.phone,
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              Icons.cake,
                              l10n.appointmentsFieldAge,
                              l10n.appointmentsAgeValue(widget.patient!.age),
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
                          l10n.appointmentsInformation,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                          _buildInfoRow(
                            Icons.medical_services,
                            l10n.appointmentsFieldReason,
                            _appointment.reason,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.calendar_today,
                            l10n.appointmentsFieldDate,
                            DateFormat('EEEE, MMM dd, yyyy').format(_appointment.startTime),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.access_time,
                            l10n.appointmentsFieldTime,
                            '${DateFormat('h:mm a').format(_appointment.startTime)} - ${DateFormat('h:mm a').format(_appointment.endTime ?? _appointment.startTime.add(const Duration(hours: 1)))}',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.schedule,
                            l10n.appointmentsFieldDuration,
                            l10n.appointmentsDurationValue(
                                (_appointment.endTime?.difference(_appointment.startTime) ?? const Duration(hours: 1)).inMinutes),
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
                          l10n.appointmentsTimestamps,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                          _buildInfoRow(
                            Icons.add_circle_outline,
                            l10n.appointmentsFieldCreated,
                            DateFormat('MMM dd, yyyy h:mm a').format(_appointment.createdAt),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.update,
                            l10n.appointmentsFieldUpdated,
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
