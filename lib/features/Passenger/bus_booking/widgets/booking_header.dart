import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:flutter/material.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader({super.key, required this.bus, required this.date});

  final JourneyBusModel bus;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final formattedDate = '${months[date.month - 1]} ${date.day}, ${date.year}';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title bar ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Row(
              children: [
                const Icon(Icons.directions_bus,
                    color: AppColors.white, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    bus.busName,
                    style: tt.titleSmall?.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'LKR ${bus.ticketPrice.toStringAsFixed(2)}',
                  style: tt.titleSmall?.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // ── Details card ───────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _HeaderDetail(
                      icon: Icons.trip_origin,
                      label: 'From',
                      value: bus.from,
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward,
                        color: AppColors.white, size: 18),
                    const Spacer(),
                    _HeaderDetail(
                      icon: Icons.location_on,
                      label: 'To',
                      value: bus.to,
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Divider(color: AppColors.white.withOpacity(0.2), height: 1),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _HeaderDetail(
                      icon: Icons.schedule,
                      label: 'Departure',
                      value: bus.departureTime,
                    ),
                    const Spacer(),
                    _HeaderDetail(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value: formattedDate,
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderDetail extends StatelessWidget {
  const _HeaderDetail({
    required this.icon,
    required this.label,
    required this.value,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final IconData icon;
  final String label;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (crossAxisAlignment == CrossAxisAlignment.start) ...[
              Icon(icon, color: AppColors.white, size: 12),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(label,
                style: tt.bodySmall?.copyWith(
                    color: AppColors.white.withOpacity(0.7), fontSize: 11)),
            if (crossAxisAlignment == CrossAxisAlignment.end) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(icon, color: AppColors.white, size: 12),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(value,
            style: tt.bodyMedium?.copyWith(
                color: AppColors.white, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
