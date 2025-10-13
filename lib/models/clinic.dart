class Clinic {
  final String id;
  final String name;
  final String address;
  final String phone;
  final DateTime createdAt;

  Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.createdAt,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
    id: json['id'] as String,
    name: json['name'] as String,
    address: json['address'] as String,
    phone: json['phone'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'phone': phone,
    'created_at': createdAt.toIso8601String(),
  };

  Clinic copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    DateTime? createdAt,
  }) => Clinic(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    createdAt: createdAt ?? this.createdAt,
  );
}
