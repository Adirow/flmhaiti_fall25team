import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flmhaiti_fall25team/models/invoice.dart';
import 'package:flmhaiti_fall25team/models/patient.dart';
import 'package:flmhaiti_fall25team/services/billing_service.dart';
import 'package:flmhaiti_fall25team/services/patient_service.dart';
import 'package:flmhaiti_fall25team/screens/billing/invoice_form_screen.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final _billingService = BillingService();
  final _patientService = PatientService();
  final _currencyFormatter = NumberFormat.currency(symbol: '\$');

  List<Invoice> _invoices = [];
  Map<String, Patient> _patients = {};
  bool _isLoading = true;
  String? _error;
  InvoiceStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final invoices = await _billingService.getInvoices(status: _statusFilter);
      final patientIds = invoices.map((invoice) => invoice.patientId).toSet();
      final patients = <String, Patient>{};

      for (final patientId in patientIds) {
        final patient = await _patientService.getPatientById(patientId);
        if (patient != null) {
          patients[patientId] = patient;
        }
      }

      if (!mounted) return;
      setState(() {
        _invoices = invoices;
        _patients = patients;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _showInvoiceDetails(Invoice invoice) async {
    final items = await _billingService.getInvoiceItems(invoice.id);
    final payments = await _billingService.getPayments(invoice.id);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final patient = _patients[invoice.patientId];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invoice ${invoice.invoiceNumber}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (patient != null)
                  Text('${patient.name} • ${patient.phone}', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Text('Line Items', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...items.map(
                  (item) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.description),
                    subtitle: Text('Qty ${item.quantity} @ ${_currencyFormatter.format(item.unitPrice)}'),
                    trailing: Text(
                      _currencyFormatter.format((item.unitPrice * item.quantity) - item.discount),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Payments', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (payments.isEmpty)
                  Text('No payments recorded', style: Theme.of(context).textTheme.bodyMedium),
                ...payments.map(
                  (payment) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.payments, color: Theme.of(context).colorScheme.primary),
                    title: Text(_currencyFormatter.format(payment.amount)),
                    subtitle: Text('${payment.method.name} • ${DateFormat.yMMMd().format(payment.receivedAt)}'),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChips(ColorScheme colorScheme) {
    final statuses = InvoiceStatus.values;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _statusFilter == null,
            onSelected: (_) {
              setState(() => _statusFilter = null);
              _loadInvoices();
            },
          ),
          const SizedBox(width: 8),
          ...statuses.map(
            (status) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_labelForStatus(status)),
                selected: _statusFilter == status,
                selectedColor: colorScheme.primary.withValues(alpha: 0.15),
                onSelected: (_) {
                  setState(() => _statusFilter = status);
                  _loadInvoices();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _labelForStatus(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.draft:
        return 'Draft';
      case InvoiceStatus.sent:
        return 'Sent';
      case InvoiceStatus.partial:
        return 'Partial';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.voided:
        return 'Void';
    }
  }

  Color _statusColor(InvoiceStatus status, ColorScheme scheme) {
    switch (status) {
      case InvoiceStatus.draft:
        return scheme.outline;
      case InvoiceStatus.sent:
        return scheme.primary;
      case InvoiceStatus.partial:
        return scheme.tertiary;
      case InvoiceStatus.paid:
        return Colors.green;
      case InvoiceStatus.voided:
        return scheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInvoices,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const InvoiceFormScreen()),
          );
          if (!context.mounted) return;
          if (created == true) {
            await _loadInvoices();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invoice created')),
            );
          }
        },
        icon: const Icon(Icons.receipt_long),
        label: const Text('New Invoice'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildFilterChips(colorScheme),
          const SizedBox(height: 12),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState(colorScheme)
                    : _buildInvoiceList(colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load invoices',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.error),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadInvoices,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList(ColorScheme colorScheme) {
    if (_invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'No invoices yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first invoice to track clinic billing activity.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInvoices,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _invoices.length,
        itemBuilder: (context, index) {
          final invoice = _invoices[index];
          final patient = _patients[invoice.patientId];
          final statusColor = _statusColor(invoice.status, colorScheme);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: statusColor.withValues(alpha: 0.15),
                child: Icon(Icons.receipt_long, color: statusColor),
              ),
              title: Text(
                invoice.invoiceNumber,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(patient?.name ?? 'Unknown patient'),
                  const SizedBox(height: 4),
                  Text(
                    'Due ${invoice.dueDate != null ? DateFormat.yMMMd().format(invoice.dueDate!) : 'N/A'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                  ),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _currencyFormatter.format(invoice.balanceDue),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _labelForStatus(invoice.status),
                      style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              onTap: () => _showInvoiceDetails(invoice),
            ),
          );
        },
      ),
    );
  }
}
