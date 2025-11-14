import 'package:flutter/material.dart';
import 'package:flmhaiti_fall25team/models/appointment.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_config.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_utils.dart';

class AppointmentService {
  static final AppointmentService _instance = AppointmentService._();
  factory AppointmentService() => _instance;
  AppointmentService._();

  /// Get all appointments for a specific clinic
  Future<List<Appointment>> getAllAppointments() async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();

      // First get all patients for this clinic
      final patients = await SupabaseConfig.client
          .from('patients')
          .select('id')
          .eq('clinic_id', clinicId);
      
      final patientIds = patients.map((p) => p['id'] as String).toList();
      
      if (patientIds.isEmpty) {
        return []; // No patients, no appointments
      }

      // Then get appointments for those patients
      final data = await SupabaseConfig.client
          .from('appointments')
          .select('*')
          .inFilter('patient_id', patientIds)
          .order('start_time');

      return data.map<Appointment>((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load appointments: $e');
    }
  }

  /// Get appointments for a specific date
  Future<List<Appointment>> getAppointmentsByDate(DateTime date) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // First get all patients for this clinic
      final patients = await SupabaseConfig.client
          .from('patients')
          .select('id')
          .eq('clinic_id', clinicId);
      
      final patientIds = patients.map((p) => p['id'] as String).toList();
      
      if (patientIds.isEmpty) {
        return []; // No patients, no appointments
      }

      // Then get appointments for those patients
      final data = await SupabaseConfig.client
          .from('appointments')
          .select('*')
          .inFilter('patient_id', patientIds)
          .gte('start_time', startOfDay.toIso8601String())
          .lt('start_time', endOfDay.toIso8601String())
          .order('start_time');

      return data.map<Appointment>((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load appointments for date: $e');
    }
  }

  /// Get appointments for a date range
  Future<List<Appointment>> getAppointmentsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();

      // First get all patients for this clinic
      final patients = await SupabaseConfig.client
          .from('patients')
          .select('id')
          .eq('clinic_id', clinicId);
      
      final patientIds = patients.map((p) => p['id'] as String).toList();
      
      if (patientIds.isEmpty) {
        return []; // No patients, no appointments
      }

      // Then get appointments for those patients in the date range
      final data = await SupabaseConfig.client
          .from('appointments')
          .select('*')
          .inFilter('patient_id', patientIds)
          .gte('start_time', startDate.toIso8601String())
          .lte('start_time', endDate.toIso8601String())
          .order('start_time');

      return data.map<Appointment>((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load appointments for date range: $e');
    }
  }

  /// Get appointments for a specific patient
  Future<List<Appointment>> getAppointmentsByPatient(String patientId) async {
    try {
      final data = await SupabaseService.select(
        'appointments',
        filters: {'patient_id': patientId},
        orderBy: 'start_time',
        ascending: false,
      );
      
      return data.map((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load patient appointments: $e');
    }
  }

  /// Get appointments for a specific provider
  Future<List<Appointment>> getAppointmentsByProvider(String providerId) async {
    try {
      final data = await SupabaseService.select(
        'appointments',
        filters: {'provider_id': providerId},
        orderBy: 'start_time',
        ascending: true,
      );
      
      return data.map((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load provider appointments: $e');
    }
  }

  /// Get a specific appointment by ID
  Future<Appointment?> getAppointmentById(String id) async {
    try {
      final data = await SupabaseService.selectSingle(
        'appointments',
        filters: {'id': id},
      );
      
      return data != null ? Appointment.fromJson(data) : null;
    } catch (e) {
      throw Exception('Failed to load appointment: $e');
    }
  }

  /// Create a new appointment
  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      final appointmentData = appointment.toJson();
      
      // Remove auto-generated fields
      appointmentData.remove('id');
      appointmentData.remove('created_at');
      appointmentData.remove('updated_at');

      // Check for conflicts before creating
      await _checkAppointmentConflicts(
        appointment.providerId,
        appointment.startTime,
        appointment.endTime,
      );

      final result = await SupabaseService.insert('appointments', appointmentData);
      return Appointment.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to create appointment: $e');
    }
  }

  /// Update an existing appointment
  Future<Appointment> updateAppointment(Appointment appointment) async {
    try {
      final appointmentData = appointment.toJson();
      // Remove fields that shouldn't be updated
      appointmentData.remove('id');
      appointmentData.remove('created_at');
      appointmentData.remove('updated_at');

      // Check for conflicts if time or provider changed
      await _checkAppointmentConflicts(
        appointment.providerId,
        appointment.startTime,
        appointment.endTime,
        excludeAppointmentId: appointment.id,
      );

      final result = await SupabaseService.update(
        'appointments',
        appointmentData,
        filters: {'id': appointment.id},
      );
      
      return Appointment.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }

  /// Update appointment status
  Future<Appointment> updateAppointmentStatus(String appointmentId, AppointmentStatus status) async {
    try {
      final result = await SupabaseService.update(
        'appointments',
        {'status': status.dbValue},
        filters: {'id': appointmentId},
      );
      
      return Appointment.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to update appointment status: $e');
    }
  }

  /// Cancel an appointment
  Future<Appointment> cancelAppointment(String appointmentId) async {
    return await updateAppointmentStatus(appointmentId, AppointmentStatus.cancelled);
  }

  /// Confirm an appointment
  Future<Appointment> confirmAppointment(String appointmentId) async {
    return await updateAppointmentStatus(appointmentId, AppointmentStatus.confirmed);
  }

  /// Reschedule an appointment
  Future<Appointment> rescheduleAppointment(String appointmentId, DateTime newStartTime, DateTime newEndTime) async {
    try {
      final appointment = await getAppointmentById(appointmentId);
      if (appointment == null) {
        throw Exception('Appointment not found');
      }

      // Check for conflicts with new time
      await _checkAppointmentConflicts(
        appointment.providerId,
        newStartTime,
        newEndTime,
        excludeAppointmentId: appointmentId,
      );

      final result = await SupabaseService.update(
        'appointments',
        {
          'start_time': newStartTime.toIso8601String(),
          'end_time': newEndTime.toIso8601String(),
          'status': AppointmentStatus.scheduled.dbValue,
        },
        filters: {'id': appointmentId},
      );
      
      return Appointment.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to reschedule appointment: $e');
    }
  }

  /// Delete an appointment
  Future<void> deleteAppointment(String id) async {
    try {
      await SupabaseService.delete(
        'appointments',
        filters: {'id': id},
      );
    } catch (e) {
      throw Exception('Failed to delete appointment: $e');
    }
  }

  /// Search appointments by patient name or reason
  Future<List<Appointment>> searchAppointments(String query) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();

      if (query.trim().isEmpty) {
        return await getAllAppointments();
      }

      // First get all patients for this clinic that match the search
      final patients = await SupabaseConfig.client
          .from('patients')
          .select('id, name')
          .eq('clinic_id', clinicId)
          .ilike('name', '%$query%');
      
      final patientIds = patients.map((p) => p['id'] as String).toList();

      // Get appointments that match by reason OR by patient
      List<Appointment> appointments = [];
      
      // Search by reason
      final reasonResults = await SupabaseConfig.client
          .from('appointments')
          .select('*')
          .ilike('reason', '%$query%')
          .order('start_time');
      
      appointments.addAll(reasonResults.map<Appointment>((json) => Appointment.fromJson(json)));
      
      // Search by patient if we found matching patients
      if (patientIds.isNotEmpty) {
        final patientResults = await SupabaseConfig.client
            .from('appointments')
            .select('*')
            .inFilter('patient_id', patientIds)
            .order('start_time');
        
        appointments.addAll(patientResults.map<Appointment>((json) => Appointment.fromJson(json)));
      }
      
      // Remove duplicates and filter by clinic patients
      final allClinicPatients = await SupabaseConfig.client
          .from('patients')
          .select('id')
          .eq('clinic_id', clinicId);
      
      final allClinicPatientIds = allClinicPatients.map((p) => p['id'] as String).toSet();
      
      final uniqueAppointments = <String, Appointment>{};
      for (final appointment in appointments) {
        if (allClinicPatientIds.contains(appointment.patientId)) {
          uniqueAppointments[appointment.id] = appointment;
        }
      }
      
      final result = uniqueAppointments.values.toList();
      result.sort((a, b) => a.startTime.compareTo(b.startTime));
      
      return result;
    } catch (e) {
      throw Exception('Failed to search appointments: $e');
    }
  }

  /// Get appointments count for a clinic
  Future<int> getAppointmentsCount() async {
    try {
      final appointments = await getAllAppointments();
      return appointments.length;
    } catch (e) {
      throw Exception('Failed to get appointments count: $e');
    }
  }

  /// Get today's appointments count
  Future<int> getTodayAppointmentsCount() async {
    try {
      final today = DateTime.now();
      final appointments = await getAppointmentsByDate(today);
      return appointments.length;
    } catch (e) {
      throw Exception('Failed to get today\'s appointments count: $e');
    }
  }

  /// Get upcoming appointments (next 7 days)
  Future<List<Appointment>> getUpcomingAppointments({int days = 7}) async {
    try {
      final now = DateTime.now();
      final endDate = now.add(Duration(days: days));
      
      return await getAppointmentsByDateRange(now, endDate);
    } catch (e) {
      throw Exception('Failed to load upcoming appointments: $e');
    }
  }

  /// Get appointments by status
  Future<List<Appointment>> getAppointmentsByStatus(AppointmentStatus status) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();

      // First get all patients for this clinic
      final patients = await SupabaseConfig.client
          .from('patients')
          .select('id')
          .eq('clinic_id', clinicId);
      
      final patientIds = patients.map((p) => p['id'] as String).toList();
      
      if (patientIds.isEmpty) {
        return []; // No patients, no appointments
      }

      // Then get appointments for those patients with the specified status
      final data = await SupabaseConfig.client
          .from('appointments')
          .select('*')
          .inFilter('patient_id', patientIds)
          .eq('status', status.dbValue)
          .order('start_time');
      
      return data.map<Appointment>((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load appointments by status: $e');
    }
  }

  /// Check for appointment conflicts
  Future<void> _checkAppointmentConflicts(
    String? providerId,
    DateTime startTime,
    DateTime? endTime, {
    String? excludeAppointmentId,
  }) async {
    try {
      // Skip conflict check if no provider or end time
      if (providerId == null || endTime == null) {
        return;
      }

      var query = SupabaseConfig.client
          .from('appointments')
          .select('id')
          .eq('provider_id', providerId)
          .neq('status', AppointmentStatus.cancelled.dbValue)
          .lt('start_time', endTime.toIso8601String())
          .gt('end_time', startTime.toIso8601String());

      if (excludeAppointmentId != null) {
        query = query.neq('id', excludeAppointmentId);
      }

      final conflicts = await query;
      
      if (conflicts.isNotEmpty) {
        throw Exception('Appointment time conflicts with existing appointment');
      }
    } catch (e) {
      if (e.toString().contains('conflicts with existing appointment')) {
        rethrow;
      }
      throw Exception('Failed to check appointment conflicts: $e');
    }
  }

  /// Get available time slots for a provider on a specific date
  Future<List<DateTime>> getAvailableTimeSlots(
    String providerId,
    DateTime date, {
    Duration slotDuration = const Duration(minutes: 30),
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0),
    TimeOfDay endTime = const TimeOfDay(hour: 17, minute: 0),
  }) async {
    try {
      final appointments = await SupabaseConfig.client
          .from('appointments')
          .select('start_time, end_time')
          .eq('provider_id', providerId)
          .neq('status', AppointmentStatus.cancelled.dbValue)
          .gte('start_time', DateTime(date.year, date.month, date.day).toIso8601String())
          .lt('start_time', DateTime(date.year, date.month, date.day + 1).toIso8601String());

      final bookedSlots = appointments.map((apt) => {
        'start': DateTime.parse(apt['start_time']),
        'end': DateTime.parse(apt['end_time']),
      }).toList();

      final availableSlots = <DateTime>[];
      final dayStart = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute);
      final dayEnd = DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);

      DateTime currentSlot = dayStart;
      while (currentSlot.add(slotDuration).isBefore(dayEnd) || currentSlot.add(slotDuration).isAtSameMomentAs(dayEnd)) {
        final slotEnd = currentSlot.add(slotDuration);
        
        bool isAvailable = true;
        for (final booked in bookedSlots) {
          if (currentSlot.isBefore(booked['end']!) && slotEnd.isAfter(booked['start']!)) {
            isAvailable = false;
            break;
          }
        }
        
        if (isAvailable) {
          availableSlots.add(currentSlot);
        }
        
        currentSlot = currentSlot.add(slotDuration);
      }

      return availableSlots;
    } catch (e) {
      throw Exception('Failed to get available time slots: $e');
    }
  }
}
