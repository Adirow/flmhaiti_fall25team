enum Gender { male, female, other }

class Patient {
  final String id;
  final String clinicId;
  final String name;
  final Gender gender;
  final DateTime dob;
  final String phone;
  final String address;
  final String bloodPressure;
  final DateTime createdAt;
  final DateTime updatedAt;

  Patient({
    required this.id,
    required this.clinicId,
    required this.name,
    required this.gender,
    required this.dob,
    required this.phone,
    required this.address,
    required this.bloodPressure,
    required this.createdAt,
    required this.updatedAt,
  });

  int get age {
    final now = DateTime.now();
    int years = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    return years;
  }

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    id: json['id'] as String,
    clinicId: json['clinic_id'] as String,
    name: json['name'] as String,
    gender: Gender.values.firstWhere((e) => e.name == json['gender']),
    dob: DateTime.parse(json['dob'] as String),
    phone: json['phone'] as String,
    address: json['address'] as String,
    bloodPressure: json['blood_pressure'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'clinic_id': clinicId,
    'name': name,
    'gender': gender.name,
    'dob': dob.toIso8601String(),
    'phone': phone,
    'address': address,
    'blood_pressure': bloodPressure,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  Patient copyWith({
    String? id,
    String? clinicId,
    String? name,
    Gender? gender,
    DateTime? dob,
    String? phone,
    String? address,
    String? bloodPressure,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Patient(
    id: id ?? this.id,
    clinicId: clinicId ?? this.clinicId,
    name: name ?? this.name,
    gender: gender ?? this.gender,
    dob: dob ?? this.dob,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    bloodPressure: bloodPressure ?? this.bloodPressure,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
