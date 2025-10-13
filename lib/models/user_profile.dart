enum UserRole { admin, dentist, assistant, clerk }

class UserProfile {
  final String id;
  final String clinicId;
  final String email;
  final String fullName;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.clinicId,
    required this.email,
    required this.fullName,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    clinicId: json['clinic_id'] as String,
    email: json['email'] as String,
    fullName: json['full_name'] as String,
    role: UserRole.values.firstWhere((e) => e.name == json['role']),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'clinic_id': clinicId,
    'email': email,
    'full_name': fullName,
    'role': role.name,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  UserProfile copyWith({
    String? id,
    String? clinicId,
    String? email,
    String? fullName,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserProfile(
    id: id ?? this.id,
    clinicId: clinicId ?? this.clinicId,
    email: email ?? this.email,
    fullName: fullName ?? this.fullName,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
