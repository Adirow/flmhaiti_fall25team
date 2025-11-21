import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flmhaiti_fall25team/localization/l10n_extension.dart';
import 'package:flmhaiti_fall25team/models/appointment.dart';
import 'package:flmhaiti_fall25team/models/patient.dart';
import 'package:flmhaiti_fall25team/services/appointment_service.dart';
import 'package:flmhaiti_fall25team/services/patient_service.dart';
import 'package:flmhaiti_fall25team/screens/appointments/appointment_form_screen.dart';
import 'package:flmhaiti_fall25team/screens/appointments/appointment_detail_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Appointment> _appointments = [];
  Map<String, Patient> _patients = {};
  bool _isLoading = true;
  String _searchQuery = '';
  AppointmentStatus? _statusFilter;
  
  final _appointmentService = AppointmentService();
  final _patientService = PatientService();
  
  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      _loadAppointments();
    });
  }
  
  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);
    try {
      final appointments = await _appointmentService.getAppointmentsByDate(_selectedDate);
      final patientIds = appointments.map((a) => a.patientId).toSet();
      
      // Load patient data for all appointments
      final patients = <String, Patient>{};
      for (final patientId in patientIds) {
        final patient = await _patientService.getPatientById(patientId);
        if (patient != null) {
          patients[patientId] = patient;
        }
      }
      
      setState(() {
        _appointments = appointments;
        _patients = patients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.appointmentsLoadError('$e'))),
        );
      }
    }
  }
  
  Future<void> _searchAppointments(String query) async {
    setState(() {
      _searchQuery = query;
      _isLoading = true;
    });
    
    try {
      final appointments = query.isEmpty 
          ? await _appointmentService.getAppointmentsByDate(_selectedDate)
          : await _appointmentService.searchAppointments(query);
      
      final patientIds = appointments.map((a) => a.patientId).toSet();
      final patients = <String, Patient>{};
      for (final patientId in patientIds) {
        final patient = await _patientService.getPatientById(patientId);
        if (patient != null) {
          patients[patientId] = patient;
        }
      }
      
      setState(() {
        _appointments = appointments;
        _patients = patients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.appointmentsSearchError('$e'))),
        );
      }
    }
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
      case AppointmentStatus.inProgress:
        return l10n.appointmentsStatusInProgress;
      case AppointmentStatus.scheduled:
        return l10n.appointmentsStatusScheduled;
      case AppointmentStatus.confirmed:
        return l10n.appointmentsStatusConfirmed;
      case AppointmentStatus.completed:
        return l10n.appointmentsStatusCompleted;
      case AppointmentStatus.cancelled:
        return l10n.appointmentsStatusCancelled;
    }
  }
  
  List<Appointment> get _filteredAppointments {
    var filtered = _appointments;
    
    if (_statusFilter != null) {
      filtered = filtered.where((a) => a.status == _statusFilter).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.appointmentsCardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          PopupMenuButton<AppointmentStatus?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (status) {
              setState(() {
                _statusFilter = status;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: null,
                child: Text(l10n.appointmentsFilterAll),
              ),
              ...AppointmentStatus.values.map((status) => PopupMenuItem(
                value: status,
                child: Text(_getStatusLabel(status)),
              )),
            ],
          ),
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAppointments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 64,
                              color: colorScheme.onSurface.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.appointmentsEmptyTitle,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.appointmentsEmptySubtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadAppointments,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = _filteredAppointments[index];
                            final patient = _patients[appointment.patientId];
                            final statusColor = _getStatusColor(appointment.status, colorScheme);

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
                                      Text(
                                        DateFormat('HH:mm').format(appointment.startTime),
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Text(
                                  patient?.name ?? l10n.appointmentsUnknownPatient,
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      appointment.reason,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${DateFormat('HH:mm').format(appointment.startTime)} - ${DateFormat('HH:mm').format(appointment.endTime ?? appointment.startTime.add(const Duration(hours: 1)))}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        _getStatusLabel(appointment.status),
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                                  onSelected: (value) => _handleAppointmentAction(appointment, value),
                                  itemBuilder: (context) => [
                                    if (appointment.status == AppointmentStatus.scheduled)
                                      PopupMenuItem(value: 'confirm', child: Text(l10n.appointmentsActionConfirm)),
                                    PopupMenuItem(value: 'edit', child: Text(l10n.appointmentsActionEdit)),
                                    PopupMenuItem(value: 'reschedule', child: Text(l10n.appointmentsActionReschedule)),
                                    if (appointment.status != AppointmentStatus.cancelled)
                                      PopupMenuItem(value: 'cancel', child: Text(l10n.commonCancel)),
                                    PopupMenuItem(value: 'delete', child: Text(l10n.commonDelete)),
                                  ],
                                ),
                                onTap: () => _showAppointmentDetails(appointment, patient),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAppointmentDialog(),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: Text(l10n.appointmentsNewButton),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final searchController = TextEditingController(text: _searchQuery);
        
        return AlertDialog(
          title: Text(l10n.appointmentsSearchTitle),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: l10n.appointmentsSearchLabel,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
            ),
            autofocus: true,
            onSubmitted: (value) {
              Navigator.pop(context);
              _searchAppointments(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _searchAppointments(searchController.text);
              },
              child: Text(l10n.appointmentsSearchButton),
            ),
          ],
        );
      },
    );
  }

  void _showAddAppointmentDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentFormScreen(
          onSaved: () {
            _loadAppointments();
          },
        ),
      ),
    );
  }

  void _handleAppointmentAction(Appointment appointment, String action) async {
    try {
      switch (action) {
        case 'confirm':
          await _appointmentService.confirmAppointment(appointment.id);
          _loadAppointments();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.appointmentsConfirmSuccess)),
            );
          }
          break;
        case 'edit':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentFormScreen(
                appointment: appointment,
                onSaved: () {
                  _loadAppointments();
                },
              ),
            ),
          );
          break;
        case 'reschedule':
          _showRescheduleDialog(appointment);
          break;
        case 'cancel':
          await _appointmentService.cancelAppointment(appointment.id);
          _loadAppointments();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.appointmentsCancelSuccess)),
            );
          }
          break;
        case 'delete':
          _showDeleteConfirmation(appointment);
          break;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.appointmentsActionError(action, '$e'))),
        );
      }
    }
  }

  void _showRescheduleDialog(Appointment appointment) {
    DateTime selectedDate = appointment.startTime;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(appointment.startTime);
    
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
                  final duration = appointment.endTime?.difference(appointment.startTime) ?? const Duration(hours: 1);
                  final newEndTime = newStartTime.add(duration);
                  
                  await _appointmentService.rescheduleAppointment(
                    appointment.id,
                    newStartTime,
                    newEndTime,
                  );
                  
                  Navigator.pop(context);
                  _loadAppointments();

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

  void _showDeleteConfirmation(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.appointmentsDeleteTitle),
        content: Text(context.l10n.appointmentsDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.commonCancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () async {
              try {
                await _appointmentService.deleteAppointment(appointment.id);
                Navigator.pop(context);
                _loadAppointments();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.appointmentsDeleteSuccess)),
                  );
                }
              } catch (e) {
                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.appointmentsDeleteError('$e'))),
                  );
                }
              }
            },
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetails(Appointment appointment, Patient? patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailScreen(
          appointment: appointment,
          patient: patient,
          onUpdated: () => _loadAppointments(),
        ),
      ),
    );
  }
}
