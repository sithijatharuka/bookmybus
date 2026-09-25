import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/booking_history/models/passenger_booking_model.dart';
import 'package:bookmybus/features/Passenger/booking_history/widgets/booking_history_actions.dart';
import 'package:bookmybus/features/Passenger/booking_history/widgets/booking_status_badge.dart';
import 'package:flutter/material.dart';

class BookingHistoryCard extends StatelessWidget {
  const BookingHistoryCard({
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

  String get _bookedAtLabel {
    final d = booking.bookedAt;
    final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final period = d.hour < 12 ? 'AM' : 'PM';
    final min = d.minute.toString().padLeft(2, '0');
    final sec = d.second.toString().padLeft(2, '0');
    return '${d.month}/${d.day}/${d.year}, $h:$min:$sec $period';
  }

  String get _travelDateLabel {
    final d = booking.travelDate;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _RefBadge(ref: booking.ticketRef),
                BookingStatusBadge(status: booking.status),
              ],
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),

          // Details grid
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _Cell(label: 'TRAVEL DATE', value: _travelDateLabel, icon: Icons.calendar_today_outlined)),
                    Expanded(child: _Cell(label: 'ROUTE', value: booking.route, icon: Icons.route_outlined)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: _Cell(label: 'BUS', value: booking.busName, icon: Icons.directions_bus_outlined)),
                    Expanded(child: _Cell(label: 'BUS NO', value: booking.busNumber, icon: Icons.confirmation_number_outlined)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: _Cell(label: 'DEPARTURE', value: booking.departureTime, icon: Icons.schedule_outlined)),
                    Expanded(child: _Cell(label: 'SEATS', value: booking.seatsLabel, icon: Icons.event_seat_outlined)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: _Cell(label: 'BOOKED AT', value: _bookedAtLabel, icon: Icons.access_time_outlined)),
                    Expanded(
                      child: _Cell(
                        label: 'TOTAL',
                        value: 'LKR ${booking.totalAmount.toStringAsFixed(2)}',
                        icon: Icons.account_balance_wallet_outlined,
                        valueColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),

          // Actions
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: BookingHistoryActions(
              booking: booking,
              onView: onView,
              onPayNow: onPayNow,
              onCancel: onCancel,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefBadge extends StatelessWidget {
  const _RefBadge({required this.ref});
  final String ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        'REF: ${ref.toUpperCase()}',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primaryLight,
              fontSize: 11,
              letterSpacing: 0.6,
            ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.section,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Icon(icon, size: 13, color: AppColors.primaryLight),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: tt.bodySmall?.copyWith(
                  fontSize: 10,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: tt.bodySmall?.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
