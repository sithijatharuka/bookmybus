import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/booking_section_card.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/bus_seat_layout.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/two_by_two_45_seat_layout.dart';
import 'package:flutter/material.dart';

class SeatSelectionSection extends StatelessWidget {
  const SeatSelectionSection({
    super.key,
    required this.bus,
    required this.selectedSeats,
    required this.onSeatsChanged,
  });

  final JourneyBusModel bus;
  final List<int> selectedSeats;
  final OnSeatSelected onSeatsChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seat Selection',
            style: tt.titleMedium?.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Select your preferred seat(s) from the layout below.',
          style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),

        BookingSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BookingCardHeader(
                icon: Icons.event_seat_outlined,
                title: 'Bus Seat Layout',
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Legend ─────────────────────────────────────────────────────
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                children: const [
                  _LegendItem(color: Colors.white, borderColor: Color(0xFF2ECC71), label: 'Available'),
                  _LegendItem(color: Color(0xFF1E3A8A), borderColor: Color(0xFF1E3A8A), label: 'Booked'),
                  _LegendItem(color: Color(0xFF64748B), borderColor: Color(0xFF64748B), label: 'Blocked'),
                  _LegendItem(color: Color(0xFF2ECC71), borderColor: Color(0xFF2ECC71), label: 'Selected'),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: AppSpacing.lg),

              // ── Layout ─────────────────────────────────────────────────────
              _buildLayout(),

              // ── Selected seats summary ─────────────────────────────────────
              if (selectedSeats.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: AppSpacing.md),
                _SelectedSeatsSummary(
                  selectedSeats: selectedSeats,
                  ticketPrice: bus.ticketPrice,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLayout() {
    switch (bus.layoutType) {
      case BusLayoutType.twoByTwo45:
        return TwoByTwo45SeatLayout(
          selectedSeats: Set<int>.from(selectedSeats),
          onSeatSelected: onSeatsChanged,
        );
      case BusLayoutType.twoByTwo51:
      case BusLayoutType.unknown:
        return TwoByTwo45SeatLayout(
          selectedSeats: Set<int>.from(selectedSeats),
          onSeatSelected: onSeatsChanged,
        );
    }
  }
}

// ── Legend item ────────────────────────────────────────────────────────────────

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.borderColor,
    required this.label,
  });

  final Color color;
  final Color borderColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(color: borderColor, width: 1.5),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

// ── Selected seats summary ─────────────────────────────────────────────────────

class _SelectedSeatsSummary extends StatelessWidget {
  const _SelectedSeatsSummary({
    required this.selectedSeats,
    required this.ticketPrice,
  });

  final List<int> selectedSeats;
  final double ticketPrice;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final total = ticketPrice * selectedSeats.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              Text('Selected: ',
                  style: tt.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500)),
              ...selectedSeats.map(
                (s) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text('$s',
                      style: tt.bodySmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Total',
                style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
            Text('LKR ${total.toStringAsFixed(2)}',
                style: tt.titleSmall?.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
