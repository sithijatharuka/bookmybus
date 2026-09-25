import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/booking_history/models/passenger_booking_model.dart';
import 'package:flutter/material.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});

  final PassengerBookingStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, textColor, label) = switch (status) {
      PassengerBookingStatus.confirmed => (AppColors.successLight, const Color(0xFF15803D), 'CONFIRMED'),
      PassengerBookingStatus.cancelled => (AppColors.errorLight, AppColors.error, 'CANCELLED'),
      PassengerBookingStatus.pending   => (AppColors.warningLight, const Color(0xFFB45309), 'PENDING'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
