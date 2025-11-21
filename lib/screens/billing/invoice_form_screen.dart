import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flmhaiti_fall25team/models/invoice.dart';
import 'package:flmhaiti_fall25team/models/patient.dart';
import 'package:flmhaiti_fall25team/services/billing_service.dart';
import 'package:flmhaiti_fall25team/services/patient_service.dart';

class InvoiceFormScreen extends StatefulWidget {
  const InvoiceFormScreen({super.key});

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _billingService = BillingService();
  final _patientService = PatientService();
  final _currencyFormatter = NumberFormat.currency(symbol: '\$');

  List<Patient> _patients = [];
  String? _selectedPatientId;
  DateTime? _dueDate;
  final _notesController = TextEditingController();

  final List<_ItemInput> _items = [ _ItemInput() ];

  bool _isLoadingPatients = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    try {
      final patients = await _patientService.getAllPatients();
      setState(() {
        _patients = patients;
        if (patients.isNotEmpty) {
          _selectedPatientId = patients.first.id;
        }
        _isLoadingPatients = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPatients = false;
        _error = 'Failed to load patient list: $e';
      });
    }
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (selected != null) {
      setState(() => _dueDate = selected);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPatientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient')),
      );
      return;
    }

    final items = _items
        .where((item) => item.descriptionController.text.trim().isNotEmpty)
        .map(
          (item) => InvoiceLineInput(
            code: item.codeController.text.trim().isEmpty ? null : item.codeController.text.trim(),
            description: item.descriptionController.text.trim(),
            quantity: double.tryParse(item.quantityController.text) ?? 1,
            unitPrice: double.tryParse(item.unitPriceController.text) ?? 0,
            discount: double.tryParse(item.discountController.text) ?? 0,
          ),
        )
        .toList();

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one line item')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _billingService.createInvoiceWithItems(
        patientId: _selectedPatientId!,
        dueDate: _dueDate,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        items: items,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create invoice: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  double get _projectedTotal {
    return _items.fold<double>(
      0,
      (sum, item) {
        final amount =
            (double.tryParse(item.quantityController.text) ?? 0) *
                (double.tryParse(item.unitPriceController.text) ?? 0);
        final discount = double.tryParse(item.discountController.text) ?? 0;
        return sum + (amount - discount);
      },
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Invoice'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _handleSubmit,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: _isLoadingPatients
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SafeArea(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _selectedPatientId,
                            decoration: const InputDecoration(
                              labelText: 'Patient',
                              border: OutlineInputBorder(),
                            ),
                            items: _patients
                                .map(
                                  (patient) => DropdownMenuItem(
                                    value: patient.id,
                                    child: Text(patient.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => setState(() => _selectedPatientId = value),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(_dueDate == null
                                ? 'No due date'
                                : 'Due ${DateFormat.yMMMd().format(_dueDate!)}'),
                            trailing: TextButton.icon(
                              onPressed: _pickDueDate,
                              icon: const Icon(Icons.date_range),
                              label: const Text('Select due date'),
                            ),
                          ),
                          TextFormField(
                            controller: _notesController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Notes',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Line Items',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  setState(() => _items.add(_ItemInput()));
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add item'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ..._items.map(
                            (item) => Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: item.descriptionController,
                                      decoration: const InputDecoration(
                                        labelText: 'Description *',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Description is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: item.quantityController,
                                            keyboardType:
                                                const TextInputType.numberWithOptions(decimal: true),
                                            decoration: const InputDecoration(
                                              labelText: 'Quantity',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextFormField(
                                            controller: item.unitPriceController,
                                            keyboardType:
                                                const TextInputType.numberWithOptions(decimal: true),
                                            decoration: const InputDecoration(
                                              labelText: 'Unit Price',
                                            ),
                                            validator: (value) {
                                              final amount = double.tryParse(value ?? '');
                                              if (amount == null || amount < 0) {
                                                return 'Enter valid price';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: item.discountController,
                                            keyboardType:
                                                const TextInputType.numberWithOptions(decimal: true),
                                            decoration: const InputDecoration(
                                              labelText: 'Discount',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextFormField(
                                            controller: item.codeController,
                                            decoration: const InputDecoration(
                                              labelText: 'Code',
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: _items.length == 1
                                              ? null
                                              : () {
                                                  setState(() {
                                                    _items.remove(item);
                                                  });
                                                  item.dispose();
                                                },
                                          icon: const Icon(Icons.delete_outline),
                                          color: colorScheme.error,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Projected total:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                _currencyFormatter.format(_projectedTotal),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}

class _ItemInput {
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final unitPriceController = TextEditingController();
  final discountController = TextEditingController(text: '0');
  final codeController = TextEditingController();

  void dispose() {
    descriptionController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    discountController.dispose();
    codeController.dispose();
  }
}
