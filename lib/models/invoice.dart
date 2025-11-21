enum InvoiceStatus { draft, sent, partial, paid, voided }

class Invoice {
  final String id;
  final String clinicId;
  final String patientId;
  final String? encounterId;
  final String invoiceNumber;
  final InvoiceStatus status;
  final String currency;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final double balanceDue;
  final DateTime? dueDate;
  final String? notes;
  final Map<String, dynamic> metadata;
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Invoice({
    required this.id,
    required this.clinicId,
    required this.patientId,
    this.encounterId,
    required this.invoiceNumber,
    required this.status,
    required this.currency,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.balanceDue,
    this.dueDate,
    this.notes,
    this.metadata = const {},
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json['id'] as String,
        clinicId: json['clinic_id'] as String,
        patientId: json['patient_id'] as String,
        encounterId: json['encounter_id'] as String?,
        invoiceNumber: json['invoice_number'] as String,
        status: InvoiceStatus.values.firstWhere(
          (status) => status.name == (json['status'] as String).replaceFirst('void', 'voided'),
          orElse: () => InvoiceStatus.draft,
        ),
        currency: json['currency'] as String? ?? 'USD',
        subtotal: _toDouble(json['subtotal']),
        discount: _toDouble(json['discount']),
        tax: _toDouble(json['tax']),
        total: _toDouble(json['total']),
        balanceDue: _toDouble(json['balance_due']),
        dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
        notes: json['notes'] as String?,
        metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
        createdBy: json['created_by'] as String,
        updatedBy: json['updated_by'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'clinic_id': clinicId,
        'patient_id': patientId,
        'encounter_id': encounterId,
        'invoice_number': invoiceNumber,
        'status': status == InvoiceStatus.voided ? 'void' : status.name,
        'currency': currency,
        'subtotal': subtotal,
        'discount': discount,
        'tax': tax,
        'total': total,
        'balance_due': balanceDue,
        'due_date': dueDate?.toIso8601String(),
        'notes': notes,
        'metadata': metadata,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  Invoice copyWith({
    String? id,
    String? clinicId,
    String? patientId,
    String? encounterId,
    String? invoiceNumber,
    InvoiceStatus? status,
    String? currency,
    double? subtotal,
    double? discount,
    double? tax,
    double? total,
    double? balanceDue,
    DateTime? dueDate,
    String? notes,
    Map<String, dynamic>? metadata,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Invoice(
        id: id ?? this.id,
        clinicId: clinicId ?? this.clinicId,
        patientId: patientId ?? this.patientId,
        encounterId: encounterId ?? this.encounterId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        status: status ?? this.status,
        currency: currency ?? this.currency,
        subtotal: subtotal ?? this.subtotal,
        discount: discount ?? this.discount,
        tax: tax ?? this.tax,
        total: total ?? this.total,
        balanceDue: balanceDue ?? this.balanceDue,
        dueDate: dueDate ?? this.dueDate,
        notes: notes ?? this.notes,
        metadata: metadata ?? this.metadata,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}

class InvoiceItem {
  final String id;
  final String invoiceId;
  final String? code;
  final String description;
  final double quantity;
  final double unitPrice;
  final double discount;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  const InvoiceItem({
    required this.id,
    required this.invoiceId,
    this.code,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    this.metadata = const {},
    required this.createdAt,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        id: json['id'] as String,
        invoiceId: json['invoice_id'] as String,
        code: json['code'] as String?,
        description: json['description'] as String,
        quantity: Invoice._toDouble(json['quantity']),
        unitPrice: Invoice._toDouble(json['unit_price']),
        discount: Invoice._toDouble(json['discount']),
        metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'invoice_id': invoiceId,
        'code': code,
        'description': description,
        'quantity': quantity,
        'unit_price': unitPrice,
        'discount': discount,
        'metadata': metadata,
        'created_at': createdAt.toIso8601String(),
      };
}

class InvoiceLineInput {
  final String? code;
  final String description;
  final double quantity;
  final double unitPrice;
  final double discount;
  final Map<String, dynamic> metadata;

  const InvoiceLineInput({
    this.code,
    required this.description,
    this.quantity = 1,
    required this.unitPrice,
    this.discount = 0,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'description': description,
        'quantity': quantity,
        'unit_price': unitPrice,
        'discount': discount,
        'metadata': metadata,
      };
}
