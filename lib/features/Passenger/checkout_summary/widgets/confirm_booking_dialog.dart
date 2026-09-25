import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ConfirmBookingDialog extends StatelessWidget {
  const ConfirmBookingDialog({
    super.key,
    required this.seatCount,
    required this.travelDate,
    required this.onConfirm,
  });

  final int seatCount;
  final DateTime travelDate;
  final VoidCallback onConfirm;

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _dateLabel =>
      '${_days[travelDate.weekday - 1]}, ${_months[travelDate.month - 1]} ${travelDate.day}, ${travelDate.year}';

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.section,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Icons.confirmation_number_outlined, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('Confirm Booking', style: tt.titleMedium?.copyWith(color: AppColors.textPrimary)),
        ],
      ),
      content: Text(
        'Create booking for $seatCount ${seatCount == 1 ? 'seat' : 'seats'} on $_dateLabel?',
        style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
