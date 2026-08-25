import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/call_booking_model.dart';

class Step4ConfirmPage extends StatelessWidget {
  const Step4ConfirmPage({super.key, required this.booking});

  final CallBookingModel booking;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final trip = booking.selectedTrip!;
    final seats = booking.selectedSeats;
    final total = seats.length * trip.pricePerSeat;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Confirm banner ───────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.info.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 20, color: AppColors.info),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Please review the booking details before confirming.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Trip details ─────────────────────────────────────
          _Section(
            title: 'Trip Details',
            icon: Icons.directions_bus_outlined,
            children: [
              _Row(label: 'Bus', value: '${trip.busName} ${trip.busNumber}'),
              _Row(label: 'Route', value: trip.route),
              _Row(label: 'Departure', value: trip.departureTime),
              _Row(label: 'Travel Date', value: _fmtDate(booking.travelDate!)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Passenger details ────────────────────────────────
          _Section(
            title: 'Passenger Details',
            icon: Icons.person_outline_rounded,
            children: [
              _Row(label: 'Name', value: booking.passengerName),
              _Row(label: 'Phone', value: booking.passengerPhone),
              if (booking.passengerNic.isNotEmpty)
                _Row(label: 'NIC', value: booking.passengerNic),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Seats & payment ──────────────────────────────────
          _Section(
            title: 'Seats & Payment',
            icon: Icons.receipt_long_outlined,
            children: [
              _SeatsRow(seats: seats),
              _Row(
                label: 'Seat Count',
                value: '${seats.length} ${seats.length == 1 ? 'Seat' : 'Seats'}',
              ),
              _Row(
                label: 'Price / Seat',
                value: 'LKR ${trip.pricePerSeat.toStringAsFixed(2)}',
              ),
              _Row(
                label: 'Total',
                value: 'LKR ${total.toStringAsFixed(2)}',
                bold: true,
                valueColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }
}

// ── Section Card ──────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.section,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Icon(icon, size: 14, color: AppColors.primaryLight),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// ── Row ───────────────────────────────────────────────────────────────────────

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: tt.bodyMedium?.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Seats Row ─────────────────────────────────────────────────────────────────

class _SeatsRow extends StatelessWidget {
  const _SeatsRow({required this.seats});
  final List<int> seats;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              'Seat(s)',
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: seats.map((s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.seatBooked,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Text(
                      '$s',
                      style: tt.labelSmall?.copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
