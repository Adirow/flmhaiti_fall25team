enum PaymentMethod { cash, card, check, mobileMoney, other }

class Payment {
  final String id;
  final String invoiceId;
  final String clinicId;
  final double amount;
  final PaymentMethod method;
  final String? reference;
  final DateTime receivedAt;
  final String? notes;
  final Map<String, dynamic> metadata;
  final String createdBy;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.invoiceId,
    required this.clinicId,
    required this.amount,
    required this.method,
    this.reference,
    required this.receivedAt,
    this.notes,
    this.metadata = const {},
    required this.createdBy,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'] as String,
        invoiceId: json['invoice_id'] as String,
        clinicId: json['clinic_id'] as String,
        amount: _toDouble(json['amount']),
        method: PaymentMethod.values.firstWhere(
          (method) => method.name == _normalize(json['method']),
          orElse: () => PaymentMethod.cash,
        ),
        reference: json['reference'] as String?,
        receivedAt: DateTime.parse(json['received_at'] as String),
        notes: json['notes'] as String?,
        metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
        createdBy: json['created_by'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'invoice_id': invoiceId,
        'clinic_id': clinicId,
        'amount': amount,
        'method': _serialize(method),
        'reference': reference,
        'received_at': receivedAt.toIso8601String(),
        'notes': notes,
        'metadata': metadata,
        'created_by': createdBy,
        'created_at': createdAt.toIso8601String(),
      };

  Payment copyWith({
    String? id,
    String? invoiceId,
    String? clinicId,
    double? amount,
    PaymentMethod? method,
    String? reference,
    DateTime? receivedAt,
    String? notes,
    Map<String, dynamic>? metadata,
    String? createdBy,
    DateTime? createdAt,
  }) =>
      Payment(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        clinicId: clinicId ?? this.clinicId,
        amount: amount ?? this.amount,
        method: method ?? this.method,
        reference: reference ?? this.reference,
        receivedAt: receivedAt ?? this.receivedAt,
        notes: notes ?? this.notes,
        metadata: metadata ?? this.metadata,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
      );

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static String _normalize(dynamic value) =>
      value?.toString().toLowerCase().replaceAll(' ', '') ?? 'cash';

  static String _serialize(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.mobileMoney:
        return 'mobile_money';
      default:
        return method.name;
    }
  }
}
