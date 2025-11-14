enum AppointmentStatus { scheduled, confirmed, inProgress, completed, cancelled }

extension AppointmentStatusX on AppointmentStatus {
  static const Map<AppointmentStatus, String> _dbValues = {
    AppointmentStatus.scheduled: 'scheduled',
    AppointmentStatus.confirmed: 'confirmed',
    AppointmentStatus.inProgress: 'in_progress',
    AppointmentStatus.completed: 'completed',
    AppointmentStatus.cancelled: 'cancelled',
  };

  String get dbValue => _dbValues[this]!;

  static AppointmentStatus fromDbValue(String value) {
    switch (value) {
      case 'scheduled':
        return AppointmentStatus.scheduled;
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'in_progress':
        return AppointmentStatus.inProgress;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      default:
        throw ArgumentError('Unknown appointment status: $value');
    }
  }
}

class Appointment {
  final String id;
  final String patientId;
  final String? providerId;
  final String reason;
  final DateTime startTime;
  final DateTime? endTime;
  final AppointmentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.patientId,
    this.providerId,
    required this.reason,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'] as String,
    patientId: json['patient_id'] as String,
    providerId: json['provider_id'] as String?,
    reason: json['reason'] as String? ?? '',
    startTime: DateTime.parse(json['start_time'] as String),
    endTime: json['end_time'] != null ? DateTime.parse(json['end_time'] as String) : null,
    status: AppointmentStatusX.fromDbValue(json['status'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_id': patientId,
    'provider_id': providerId,
    'reason': reason,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime?.toIso8601String(),
    'status': status.dbValue,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  Appointment copyWith({
    String? id,
    String? patientId,
    String? providerId,
    String? reason,
    DateTime? startTime,
    DateTime? endTime,
    AppointmentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Appointment(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    providerId: providerId ?? this.providerId,
    reason: reason ?? this.reason,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
