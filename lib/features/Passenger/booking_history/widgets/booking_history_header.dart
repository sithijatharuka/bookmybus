import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class BookingHistoryHeader extends StatelessWidget {
  const BookingHistoryHeader({super.key, required this.totalCount});

  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking History',
          style: tt.titleLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        RichText(
          text: TextSpan(
            style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
            children: [
              const TextSpan(text: 'Passenger: '),
              TextSpan(
                text: 'Test Booking',
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: ' • Total '),
              TextSpan(
                text: '$totalCount ${totalCount == 1 ? 'booking' : 'bookings'}',
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
