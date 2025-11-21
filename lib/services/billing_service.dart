import 'package:flmhaiti_fall25team/models/invoice.dart';
import 'package:flmhaiti_fall25team/models/payment.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_config.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_utils.dart';

class BillingService {
  static final BillingService _instance = BillingService._();
  factory BillingService() => _instance;
  BillingService._();

  static const double defaultConsultationFee = 50.0;

  String _generateInvoiceNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'INV-$timestamp';
  }

  Future<List<Invoice>> getInvoices({InvoiceStatus? status}) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      var query = SupabaseConfig.client
          .from('billing_invoices')
          .select('*')
          .eq('clinic_id', clinicId);

      if (status != null) {
        final value = status == InvoiceStatus.voided ? 'void' : status.name;
        query = query.eq('status', value);
      }

      final data = await query.order('created_at', ascending: false);
      return data.map<Invoice>((json) => Invoice.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load invoices: $e');
    }
  }

  Future<Invoice?> getInvoiceById(String id) async {
    try {
      final data = await SupabaseService.selectSingle(
        'billing_invoices',
        filters: {'id': id},
      );
      return data != null ? Invoice.fromJson(data) : null;
    } catch (e) {
      throw Exception('Failed to load invoice: $e');
    }
  }

  Future<List<InvoiceItem>> getInvoiceItems(String invoiceId) async {
    try {
      final data = await SupabaseService.select(
        'billing_invoice_items',
        filters: {'invoice_id': invoiceId},
        orderBy: 'created_at',
        ascending: true,
      );
      return data.map((json) => InvoiceItem.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load invoice items: $e');
    }
  }

  Future<List<Payment>> getPayments(String invoiceId) async {
    try {
      final data = await SupabaseService.select(
        'billing_payments',
        filters: {'invoice_id': invoiceId},
        orderBy: 'received_at',
        ascending: false,
      );
      return data.map((json) => Payment.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load payments: $e');
    }
  }

  Future<Invoice> createInvoice(Invoice invoice) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      final userId = await SupabaseUtils.getCurrentUserId();

      final data = invoice.toJson();
      data
        ..remove('id')
        ..remove('created_at')
        ..remove('updated_at')
        ..remove('created_by')
        ..remove('updated_by');

      data['clinic_id'] = clinicId;
      data['created_by'] = userId;
      data['status'] = invoice.status == InvoiceStatus.voided ? 'void' : invoice.status.name;

      final response = await SupabaseService.insert('billing_invoices', data);
      return Invoice.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to create invoice: $e');
    }
  }

  Future<Invoice> updateInvoice(Invoice invoice) async {
    try {
      final userId = await SupabaseUtils.getCurrentUserId();
      final data = invoice.toJson();
      data
        ..remove('id')
        ..remove('created_at')
        ..remove('created_by')
        ..remove('clinic_id')
        ..remove('patient_id');

      data['updated_by'] = userId;
      data['status'] = invoice.status == InvoiceStatus.voided ? 'void' : invoice.status.name;

      final response = await SupabaseService.update(
        'billing_invoices',
        data,
        filters: {'id': invoice.id},
      );
      return Invoice.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to update invoice: $e');
    }
  }

  Future<Invoice> createInvoiceWithItems({
    required String patientId,
    String? encounterId,
    DateTime? dueDate,
    String? notes,
    String currency = 'USD',
    List<InvoiceLineInput> items = const [],
  }) async {
    if (items.isEmpty) {
      throw Exception('At least one line item is required.');
    }

    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      final userId = await SupabaseUtils.getCurrentUserId();

      final subtotal = items.fold<double>(
        0,
        (sum, item) => sum + (item.quantity * item.unitPrice),
      );
      final discount = items.fold<double>(
        0,
        (sum, item) => sum + item.discount,
      );
      final total = subtotal - discount;

      final invoiceInsert = {
        'clinic_id': clinicId,
        'patient_id': patientId,
        'encounter_id': encounterId,
        'invoice_number': _generateInvoiceNumber(),
        'status': 'draft',
        'currency': currency,
        'subtotal': subtotal,
        'discount': discount,
        'tax': 0,
        'total': total,
        'balance_due': total,
        'due_date': dueDate?.toIso8601String(),
        'notes': notes,
        'created_by': userId,
      };

      final invoiceResponse = await SupabaseService.insert(
        'billing_invoices',
        invoiceInsert,
      );

      final invoice = Invoice.fromJson(invoiceResponse.first);

      final itemPayload = items
          .map((item) => item.toJson()..addAll({'invoice_id': invoice.id}))
          .toList();

      if (itemPayload.isNotEmpty) {
        await SupabaseService.insertMultiple('billing_invoice_items', itemPayload);
      }

      return invoice;
    } catch (e) {
      throw Exception('Failed to create invoice: $e');
    }
  }

  Future<void> createConsultationInvoice({
    required String patientId,
    required String encounterId,
    double amount = defaultConsultationFee,
    String description = 'Consultation',
  }) async {
    if (amount <= 0) return;

    await createInvoiceWithItems(
      patientId: patientId,
      encounterId: encounterId,
      notes: 'Auto-generated consultation invoice for encounter $encounterId',
      items: [
        InvoiceLineInput(
          description: description,
          quantity: 1,
          unitPrice: amount,
        ),
      ],
    );
  }

  Future<Payment> addPayment({
    required String invoiceId,
    required double amount,
    required PaymentMethod method,
    String? reference,
    String? notes,
  }) async {
    try {
      final clinicId = await SupabaseUtils.getCurrentClinicId();
      final userId = await SupabaseUtils.getCurrentUserId();

      final data = {
        'invoice_id': invoiceId,
        'clinic_id': clinicId,
        'amount': amount,
        'method': method == PaymentMethod.mobileMoney ? 'mobile_money' : method.name,
        'reference': reference,
        'notes': notes,
        'created_by': userId,
      };

      final response = await SupabaseService.insert('billing_payments', data);
      return Payment.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to add payment: $e');
    }
  }
}
