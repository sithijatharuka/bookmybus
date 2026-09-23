import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:flutter/material.dart';

class JourneyDetailsCard extends StatelessWidget {
  const JourneyDetailsCard({
    super.key,
    required this.bus,
    required this.date,
    required this.seatCount,
    required this.pickupPoint,
    required this.dropPoint,
  });

  final JourneyBusModel bus;
  final DateTime date;
  final int seatCount;
  final String pickupPoint;
  final String dropPoint;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dateLabel =
        '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
    final seatLabel = '$seatCount ${seatCount == 1 ? 'Seat' : 'Seats'}';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              _Badge(icon: Icons.calendar_today_outlined, label: dateLabel),
              _Badge(icon: Icons.event_seat_outlined, label: seatLabel),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Icon(Icons.trip_origin, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                bus.from,
                style: tt.titleSmall?.copyWith(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.arrow_forward,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                bus.to,
                style: tt.titleSmall?.copyWith(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _StopRow(
            icon: Icons.radio_button_checked,
            iconColor: const Color(0xFF059669),
            label: 'Pickup',
            value: pickupPoint,
          ),
          const SizedBox(height: AppSpacing.md),
          _StopRow(
            icon: Icons.location_on,
            iconColor: AppColors.error,
            label: 'Drop',
            value: dropPoint,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  const _StopRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '$label: ',
          style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: tt.bodySmall?.copyWith(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
