import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/bus_seat_layout.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/two_by_two_51_seat_layout.dart';
import 'package:flutter/material.dart';
import '../models/call_booking_model.dart';

class Step2SeatsPage extends StatefulWidget {
  const Step2SeatsPage({super.key, required this.booking, required this.onChanged});

  final CallBookingModel booking;
  final VoidCallback onChanged;

  @override
  State<Step2SeatsPage> createState() => _Step2SeatsPageState();
}

class _Step2SeatsPageState extends State<Step2SeatsPage> {
  void _onSeatSelected(List<int> seats) {
    widget.booking.selectedSeats = List.from(seats);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final trip = widget.booking.selectedTrip!;
    final selected = widget.booking.selectedSeats;
    final total = selected.length * trip.pricePerSeat;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Trip summary banner ──────────────────────────────
          _TripSummaryBanner(trip: trip, travelDate: widget.booking.travelDate!),
          const SizedBox(height: AppSpacing.lg),

          // ── Seat layout ──────────────────────────────────────
          Container(
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
                      const Icon(Icons.event_seat_outlined,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Select Seats',
                        style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      if (selected.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.section,
                            borderRadius: BorderRadius.circular(AppRadius.round),
                          ),
                          child: Text(
                            '${selected.length} selected',
                            style: tt.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.divider, height: 1),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: TwoByTwo51SeatLayout(
                    onSeatSelected: _onSeatSelected,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Legend ───────────────────────────────────────────
          _LegendRow(),
          const SizedBox(height: AppSpacing.lg),

          // ── Price summary ────────────────────────────────────
          if (selected.isNotEmpty)
            _PriceSummary(
              seats: selected,
              pricePerSeat: trip.pricePerSeat,
              total: total,
            ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }
}

// ── Trip Summary Banner ───────────────────────────────────────────────────────

class _TripSummaryBanner extends StatelessWidget {
  const _TripSummaryBanner({required this.trip, required this.travelDate});

  final CallBusTripModel trip;
  final DateTime travelDate;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _fmtDate =>
      '${travelDate.day.toString().padLeft(2, '0')} ${_months[travelDate.month - 1]} ${travelDate.year}';

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_bus_rounded,
              size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${trip.busName} ${trip.busNumber}',
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${trip.route}  ·  ${trip.departureTime}  ·  $_fmtDate',
                  style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            'LKR ${trip.pricePerSeat.toStringAsFixed(0)}/seat',
            style: tt.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Legend ────────────────────────────────────────────────────────────────────

class _LegendRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    const items = [
      (color: Colors.white, border: Color(0xFF2563EB), label: 'Available'),
      (color: Color(0xFF2563EB), border: Color(0xFF2563EB), label: 'Selected'),
      (color: Color(0xFF1E3A8A), border: Color(0xFF1E3A8A), label: 'Booked'),
      (color: Color(0xFF64748B), border: Color(0xFF64748B), label: 'Blocked'),
    ];

    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: item.border, width: 1.5),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              item.label,
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        );
      }).toList(),
    );
  }
}

// ── Price Summary ─────────────────────────────────────────────────────────────

class _PriceSummary extends StatelessWidget {
  const _PriceSummary({
    required this.seats,
    required this.pricePerSeat,
    required this.total,
  });

  final List<int> seats;
  final double pricePerSeat;
  final double total;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price Summary',
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Selected Seats',
                  style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
              Wrap(
                spacing: AppSpacing.xs,
                children: seats.map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm, vertical: 2),
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
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${seats.length} × LKR ${pricePerSeat.toStringAsFixed(0)}',
                  style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
              Text('LKR ${total.toStringAsFixed(2)}',
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
