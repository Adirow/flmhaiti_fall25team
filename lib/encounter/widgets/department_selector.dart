import 'package:flutter/material.dart';
import '../models/department.dart';
import '../services/department_service.dart';
import 'package:flmhaiti_fall25team/localization/l10n_extension.dart';

class DepartmentSelector extends StatefulWidget {
  final String? selectedDepartmentId;
  final Function(Department department)? onDepartmentChanged;
  final bool enabled;

  const DepartmentSelector({
    super.key,
    this.selectedDepartmentId,
    this.onDepartmentChanged,
    this.enabled = true,
  });

  @override
  State<DepartmentSelector> createState() => _DepartmentSelectorState();
}

class _DepartmentSelectorState extends State<DepartmentSelector> {
  final DepartmentService _departmentService = DepartmentService();
  List<Department> _departments = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final departments = await _departmentService.getDepartments();
      
      setState(() {
        _departments = departments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_departments.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSelector();
  }

  Widget _buildLoadingState() {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(l10n.encountersDepartmentsLoading),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.error),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.encountersDepartmentsLoadError,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          IconButton(
            onPressed: _loadDepartments,
            icon: const Icon(Icons.refresh),
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 20),
          const SizedBox(width: 12),
          Text(l10n.encountersDepartmentsEmpty),
        ],
      ),
    );
  }

  Widget _buildSelector() {
    final selectedDepartment = _departments.firstWhere(
      (dept) => dept.id == widget.selectedDepartmentId,
      orElse: () => _departments.first,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<Department>(
        value: selectedDepartment,
        decoration: InputDecoration(
          labelText: context.l10n.encountersDepartmentLabel,
          prefixIcon: Icon(
            Icons.local_hospital,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        items: _departments.map((department) {
          return DropdownMenuItem<Department>(
            value: department,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getDepartmentColor(department.code),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    department.description != null 
                        ? '${department.name} - ${department.description}'
                        : department.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: widget.enabled
            ? (Department? department) {
                if (department != null) {
                  widget.onDepartmentChanged?.call(department);
                }
              }
            : null,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Color _getDepartmentColor(String departmentCode) {
    switch (departmentCode.toLowerCase()) {
      case 'dental':
        return Colors.blue;
      case 'gynecology':
        return Colors.pink;
      case 'dermatology':
        return Colors.orange;
      case 'cardiology':
        return Colors.red;
      case 'neurology':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
