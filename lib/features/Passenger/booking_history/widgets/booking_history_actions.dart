import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/booking_history/models/passenger_booking_model.dart';
import 'package:flutter/material.dart';

class BookingHistoryActions extends StatelessWidget {
  const BookingHistoryActions({
    super.key,
    required this.booking,
    required this.onView,
    required this.onPayNow,
    required this.onCancel,
  });

  final PassengerBookingModel booking;
  final VoidCallback onView;
  final VoidCallback onPayNow;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        if (booking.status == PassengerBookingStatus.pending) ...[
          _ActionButton(
            label: 'Pay Now',
            icon: Icons.payment_outlined,
            color: AppColors.primary,
            onTap: onPayNow,
          ),
          _ActionButton(
            label: 'Cancel Booking',
            icon: Icons.cancel_outlined,
            color: AppColors.error,
            onTap: onCancel,
          ),
        ],
        if (booking.status == PassengerBookingStatus.cancelled)
          _ActionButton(
            label: 'Cancelled',
            icon: Icons.block_outlined,
            color: AppColors.textSecondary,
            onTap: null,
          ),
        _ActionButton(
          label: 'View',
          icon: Icons.visibility_outlined,
          color: AppColors.secondary,
          onTap: onView,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.section : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: isDisabled ? AppColors.border : color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: isDisabled ? AppColors.textHint : color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDisabled ? AppColors.textHint : color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
