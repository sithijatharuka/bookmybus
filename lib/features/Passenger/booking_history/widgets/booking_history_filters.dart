import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class BookingHistoryFilters extends StatelessWidget {
  const BookingHistoryFilters({
    super.key,
    required this.selectedDate,
    required this.selectedStatus,
    required this.searchQuery,
    required this.onDateChanged,
    required this.onStatusChanged,
    required this.onSearchChanged,
  });

  final DateTime? selectedDate;
  final String selectedStatus;
  final String searchQuery;
  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onSearchChanged;

  static const _statuses = ['All', 'Pending', 'Confirmed', 'Cancelled'];

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    onDateChanged(picked);
  }

  String get _dateLabel {
    if (selectedDate == null) return 'mm/dd/yyyy';
    final d = selectedDate!;
    return '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          children: [
            // Date filter
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 15, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _dateLabel,
                          style: tt.bodySmall?.copyWith(
                            color: selectedDate != null ? AppColors.textPrimary : AppColors.textHint,
                          ),
                        ),
                      ),
                      if (selectedDate != null)
                        GestureDetector(
                          onTap: () => onDateChanged(null),
                          child: const Icon(Icons.close, size: 14, color: AppColors.textHint),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Status filter
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedStatus,
                    isExpanded: true,
                    style: tt.bodySmall?.copyWith(color: AppColors.textPrimary),
                    items: _statuses
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => onStatusChanged(v ?? 'All'),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        // Search field
        TextField(
          onChanged: onSearchChanged,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Search route, pickup/drop, name, phone, bus...',
            hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
            prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
