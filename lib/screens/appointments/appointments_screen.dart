import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dental_roots/models/appointment.dart';
import 'package:dental_roots/models/patient.dart';
import 'package:dental_roots/services/appointment_service.dart';
import 'package:dental_roots/services/patient_service.dart';
import 'package:dental_roots/screens/appointments/appointment_form_screen.dart';
import 'package:dental_roots/screens/appointments/appointment_detail_screen.dart';

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
          SnackBar(content: Text('Failed to load appointments: $e')),
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
          SnackBar(content: Text('Failed to search appointments: $e')),
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
    switch (status) {
      case AppointmentStatus.inProgress:
        return 'In Progress';
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Appointments'),
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
              const PopupMenuItem(
                value: null,
                child: Text('All Appointments'),
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
                              'No appointments found',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the + button to schedule a new appointment',
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
                                  patient?.name ?? 'Unknown Patient',
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
                                      const PopupMenuItem(value: 'confirm', child: Text('Confirm')),
                                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                    const PopupMenuItem(value: 'reschedule', child: Text('Reschedule')),
                                    if (appointment.status != AppointmentStatus.cancelled)
                                      const PopupMenuItem(value: 'cancel', child: Text('Cancel')),
                                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
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
        label: const Text('New Appointment'),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final searchController = TextEditingController(text: _searchQuery);
        
        return AlertDialog(
          title: const Text('Search Appointments'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search by patient name or reason',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
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
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _searchAppointments(searchController.text);
              },
              child: const Text('Search'),
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
              const SnackBar(content: Text('Appointment confirmed')),
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
              const SnackBar(content: Text('Appointment cancelled')),
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
          SnackBar(content: Text('Failed to $action appointment: $e')),
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

  void _showDeleteConfirmation(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment'),
        content: const Text('Are you sure you want to delete this appointment? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
                    const SnackBar(content: Text('Appointment deleted')),
                  );
                }
              } catch (e) {
                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete appointment: $e')),
                  );
                }
              }
            },
            child: const Text('Delete'),
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
