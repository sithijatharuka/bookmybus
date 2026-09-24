import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/booking_section_card.dart';
import 'package:flutter/material.dart';

class SelectedSeatsCard extends StatelessWidget {
  const SelectedSeatsCard({
    super.key,
    required this.selectedSeats,
    required this.seatGenders,
    required this.ticketPrice,
  });

  final List<int> selectedSeats;
  final Map<int, String> seatGenders;
  final double ticketPrice;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BookingCardHeader(
            icon: Icons.event_seat_outlined,
            title: 'Selected Seats',
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 2.4,
            ),
            itemCount: selectedSeats.length,
            itemBuilder: (_, i) {
              final seat = selectedSeats[i];
              final gender = seatGenders[seat];
              final isMale = gender == 'Male';
              final color =
                  isMale ? const Color(0xFF1E3A8A) : const Color(0xFF880E4F);
              return Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Seat $seat',
                      style: tt.bodySmall?.copyWith(
                          color: color, fontWeight: FontWeight.w700),
                    ),
                    if (gender != null)
                      Text(
                        gender,
                        style: tt.bodySmall?.copyWith(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                  ],
                ),
              );
            },
          ),
          if (selectedSeats.isEmpty)
            Text(
              'No seats selected.',
              style: tt.bodySmall?.copyWith(color: AppColors.textHint),
            ),
        ],
      ),
    );
  }
}
