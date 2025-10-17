import 'package:flutter/material.dart';
import 'package:flmhaiti_fall25team/models/appointment.dart';
import 'package:flmhaiti_fall25team/models/patient.dart';
import 'package:flmhaiti_fall25team/services/appointment_service.dart';
import 'package:flmhaiti_fall25team/services/patient_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final _appointmentService = AppointmentService();
  final _patientService = PatientService();

  /// Get upcoming appointments that need reminders
  Future<List<AppointmentReminder>> getUpcomingReminders() async {
    try {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));
      
      // Get appointments for tomorrow
      final appointments = await _appointmentService.getAppointmentsByDate(tomorrow);
      
      final reminders = <AppointmentReminder>[];
      
      for (final appointment in appointments) {
        if (appointment.status == AppointmentStatus.scheduled || 
            appointment.status == AppointmentStatus.confirmed) {
          
          final patient = await _patientService.getPatientById(appointment.patientId);
          if (patient != null) {
            reminders.add(AppointmentReminder(
              appointment: appointment,
              patient: patient,
              reminderType: ReminderType.dayBefore,
            ));
          }
        }
      }
      
      return reminders;
    } catch (e) {
      throw Exception('Failed to get upcoming reminders: $e');
    }
  }

  /// Get today's appointments
  Future<List<AppointmentReminder>> getTodayAppointments() async {
    try {
      final today = DateTime.now();
      final appointments = await _appointmentService.getAppointmentsByDate(today);
      
      final reminders = <AppointmentReminder>[];
      
      for (final appointment in appointments) {
        if (appointment.status != AppointmentStatus.cancelled && 
            appointment.status != AppointmentStatus.completed) {
          
          final patient = await _patientService.getPatientById(appointment.patientId);
          if (patient != null) {
            final reminderType = _getReminderTypeForToday(appointment);
            if (reminderType != null) {
              reminders.add(AppointmentReminder(
                appointment: appointment,
                patient: patient,
                reminderType: reminderType,
              ));
            }
          }
        }
      }
      
      return reminders;
    } catch (e) {
      throw Exception('Failed to get today\'s appointments: $e');
    }
  }

  /// Get overdue appointments
  Future<List<AppointmentReminder>> getOverdueAppointments() async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      
      // Get appointments from the past 7 days that are still scheduled/confirmed
      final appointments = await _appointmentService.getAppointmentsByDateRange(
        yesterday.subtract(const Duration(days: 6)),
        yesterday,
      );
      
      final overdue = appointments.where((apt) => 
        apt.status == AppointmentStatus.scheduled || 
        apt.status == AppointmentStatus.confirmed
      ).toList();
      
      final reminders = <AppointmentReminder>[];
      
      for (final appointment in overdue) {
        final patient = await _patientService.getPatientById(appointment.patientId);
        if (patient != null) {
          reminders.add(AppointmentReminder(
            appointment: appointment,
            patient: patient,
            reminderType: ReminderType.overdue,
          ));
        }
      }
      
      return reminders;
    } catch (e) {
      throw Exception('Failed to get overdue appointments: $e');
    }
  }

  /// Send reminder notification (placeholder for actual implementation)
  Future<void> sendReminder(AppointmentReminder reminder) async {
    // In a real app, this would integrate with push notifications, SMS, or email
    // For now, we'll just simulate the action
    await Future.delayed(const Duration(milliseconds: 500));
    
    print('Reminder sent to ${reminder.patient.name} for appointment on ${reminder.appointment.startTime}');
  }

  /// Get notification count for dashboard
  Future<NotificationCounts> getNotificationCounts() async {
    try {
      final today = await getTodayAppointments();
      final upcoming = await getUpcomingReminders();
      final overdue = await getOverdueAppointments();
      
      return NotificationCounts(
        todayCount: today.length,
        upcomingCount: upcoming.length,
        overdueCount: overdue.length,
      );
    } catch (e) {
      throw Exception('Failed to get notification counts: $e');
    }
  }

  ReminderType? _getReminderTypeForToday(Appointment appointment) {
    final now = DateTime.now();
    final appointmentTime = appointment.startTime;
    
    // If appointment is in the past but still not completed/cancelled
    if (appointmentTime.isBefore(now)) {
      return ReminderType.overdue;
    }
    
    // If appointment is within the next 2 hours
    final timeDiff = appointmentTime.difference(now);
    if (timeDiff.inHours <= 2 && timeDiff.inMinutes > 0) {
      return ReminderType.twoHoursBefore;
    }
    
    // If appointment is today but more than 2 hours away
    if (timeDiff.inHours > 2) {
      return ReminderType.sameDay;
    }
    
    return null;
  }
}

enum ReminderType {
  dayBefore,
  sameDay,
  twoHoursBefore,
  overdue,
}

class AppointmentReminder {
  final Appointment appointment;
  final Patient patient;
  final ReminderType reminderType;

  AppointmentReminder({
    required this.appointment,
    required this.patient,
    required this.reminderType,
  });

  String get title {
    switch (reminderType) {
      case ReminderType.dayBefore:
        return 'Appointment Tomorrow';
      case ReminderType.sameDay:
        return 'Appointment Today';
      case ReminderType.twoHoursBefore:
        return 'Appointment in 2 Hours';
      case ReminderType.overdue:
        return 'Overdue Appointment';
    }
  }

  String get message {
    final timeStr = _formatTime(appointment.startTime);
    switch (reminderType) {
      case ReminderType.dayBefore:
        return 'Reminder: ${patient.name} has an appointment tomorrow at $timeStr for ${appointment.reason}';
      case ReminderType.sameDay:
        return 'Reminder: ${patient.name} has an appointment today at $timeStr for ${appointment.reason}';
      case ReminderType.twoHoursBefore:
        return 'Upcoming: ${patient.name}\'s appointment at $timeStr for ${appointment.reason}';
      case ReminderType.overdue:
        return 'Overdue: ${patient.name}\'s appointment was scheduled for $timeStr for ${appointment.reason}';
    }
  }

  Color get color {
    switch (reminderType) {
      case ReminderType.dayBefore:
        return const Color(0xFF2196F3); // Blue
      case ReminderType.sameDay:
        return const Color(0xFF4CAF50); // Green
      case ReminderType.twoHoursBefore:
        return const Color(0xFFFFA726); // Orange
      case ReminderType.overdue:
        return const Color(0xFFF44336); // Red
    }
  }

  IconData get icon {
    switch (reminderType) {
      case ReminderType.dayBefore:
        return Icons.schedule;
      case ReminderType.sameDay:
        return Icons.today;
      case ReminderType.twoHoursBefore:
        return Icons.access_time;
      case ReminderType.overdue:
        return Icons.warning;
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}

class NotificationCounts {
  final int todayCount;
  final int upcomingCount;
  final int overdueCount;

  NotificationCounts({
    required this.todayCount,
    required this.upcomingCount,
    required this.overdueCount,
  });

  int get totalCount => todayCount + upcomingCount + overdueCount;
}
