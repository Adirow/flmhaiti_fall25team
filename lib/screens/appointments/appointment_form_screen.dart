import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dental_roots/models/appointment.dart';
import 'package:dental_roots/models/patient.dart';
import 'package:dental_roots/services/appointment_service.dart';
import 'package:dental_roots/services/patient_service.dart';
import 'package:dental_roots/supabase/supabase_utils.dart';
import 'package:dental_roots/supabase/supabase_config.dart';

class AppointmentFormScreen extends StatefulWidget {
  final Appointment? appointment;
  final VoidCallback onSaved;

  const AppointmentFormScreen({
    super.key,
    this.appointment,
    required this.onSaved,
  });

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  
  final _appointmentService = AppointmentService();
  final _patientService = PatientService();
  
  List<Patient> _patients = [];
  Patient? _selectedPatient;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  AppointmentStatus _status = AppointmentStatus.scheduled;
  
  bool _isLoading = false;
  bool _isLoadingPatients = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.appointment != null) {
      final appointment = widget.appointment!;
      _reasonController.text = appointment.reason;
      _selectedDate = appointment.startTime;
      _startTime = TimeOfDay.fromDateTime(appointment.startTime);
      _endTime = TimeOfDay.fromDateTime(appointment.endTime ?? appointment.startTime.add(const Duration(hours: 1)));
      _status = appointment.status;
      
      // Load the selected patient
      _loadSelectedPatient(appointment.patientId);
    }
  }

  Future<void> _loadPatients() async {
    try {
      final patients = await _patientService.getAllPatients();
      setState(() {
        _patients = patients;
        _isLoadingPatients = false;
      });
    } catch (e) {
      setState(() => _isLoadingPatients = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load patients: $e')),
        );
      }
    }
  }

  Future<void> _loadSelectedPatient(String patientId) async {
    try {
      final patient = await _patientService.getPatientById(patientId);
      if (patient != null) {
        setState(() {
          _selectedPatient = patient;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load patient: $e')),
        );
      }
    }
  }

  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate() || _selectedPatient == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime.hour,
        _startTime.minute,
      );

      final endDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        throw Exception('End time must be after start time');
      }

      if (widget.appointment == null) {
        // Create new appointment
        final currentUserId = await SupabaseUtils.getCurrentUserId();
        
        // Check if user has a profile, create one if it doesn't exist
        String? providerId;
        try {
          final profile = await SupabaseConfig.client
              .from('profiles')
              .select('user_id')
              .eq('user_id', currentUserId)
              .maybeSingle();
          
          if (profile != null) {
            providerId = currentUserId;
          } else {
            // Create a basic profile for the user
            try {
              await SupabaseConfig.client
                  .from('profiles')
                  .insert({
                    'user_id': currentUserId,
                    'name': 'Provider', // Default name
                    'role': 'provider',
                    'created_at': DateTime.now().toIso8601String(),
                    'updated_at': DateTime.now().toIso8601String(),
                  });
              providerId = currentUserId;
            } catch (profileError) {
              print('Warning: Could not create user profile: $profileError');
              // Leave provider_id as null if profile creation fails
            }
          }
        } catch (e) {
          // If there's an error checking the profile, leave provider_id as null
          print('Warning: Could not verify user profile: $e');
        }
        
        final newAppointment = Appointment(
          id: '', // Will be generated by the database
          patientId: _selectedPatient!.id,
          providerId: providerId, // This can be null
          reason: _reasonController.text.trim(),
          startTime: startDateTime,
          endTime: endDateTime,
          status: _status,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _appointmentService.createAppointment(newAppointment);
      } else {
        // Update existing appointment
        final updatedAppointment = widget.appointment!.copyWith(
          patientId: _selectedPatient!.id,
          reason: _reasonController.text.trim(),
          startTime: startDateTime,
          endTime: endDateTime,
          status: _status,
        );

        await _appointmentService.updateAppointment(updatedAppointment);
      }

      widget.onSaved();
      Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.appointment == null 
                ? 'Appointment created successfully' 
                : 'Appointment updated successfully'),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save appointment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appointment == null ? 'New Appointment' : 'Edit Appointment'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveAppointment,
              child: const Text('Save'),
            ),
        ],
      ),
      body: _isLoadingPatients
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Patient Selection
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
                          DropdownButtonFormField<Patient>(
                            value: _selectedPatient,
                            decoration: const InputDecoration(
                              labelText: 'Select Patient',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            items: _patients.map((patient) {
                              return DropdownMenuItem(
                                value: patient,
                                child: Text(
                                  '${patient.name} - ${patient.phone}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (patient) {
                              setState(() {
                                _selectedPatient = patient;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a patient';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Appointment Details
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Details',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Reason
                          TextFormField(
                            controller: _reasonController,
                            decoration: const InputDecoration(
                              labelText: 'Reason for Visit',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.medical_services),
                            ),
                            maxLines: 2,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a reason for the visit';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Status (only for editing)
                          if (widget.appointment != null)
                            DropdownButtonFormField<AppointmentStatus>(
                              value: _status,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.info),
                              ),
                              items: AppointmentStatus.values.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(_getStatusLabel(status)),
                                );
                              }).toList(),
                              onChanged: (status) {
                                if (status != null) {
                                  setState(() {
                                    _status = status;
                                  });
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Date and Time
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date & Time',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Date
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Date'),
                            subtitle: Text(DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate)),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() {
                                  _selectedDate = date;
                                });
                              }
                            },
                          ),
                          
                          const Divider(),
                          
                          // Start Time
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.access_time),
                            title: const Text('Start Time'),
                            subtitle: Text(_startTime.format(context)),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _startTime,
                              );
                              if (time != null) {
                                setState(() {
                                  _startTime = time;
                                  // Auto-adjust end time to be 1 hour later
                                  _endTime = time.replacing(
                                    hour: (time.hour + 1) % 24,
                                  );
                                });
                              }
                            },
                          ),
                          
                          const Divider(),
                          
                          // End Time
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.access_time_filled),
                            title: const Text('End Time'),
                            subtitle: Text(_endTime.format(context)),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _endTime,
                              );
                              if (time != null) {
                                setState(() {
                                  _endTime = time;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(widget.appointment == null ? 'Create Appointment' : 'Update Appointment'),
                    ),
                  ),
                ],
              ),
            ),
    );
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

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
