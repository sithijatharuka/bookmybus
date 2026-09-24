import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/booking_section_card.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/passenger_two_by_two_45_layout.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/bus_seat_layout.dart';
import 'package:flutter/material.dart';

const int _kMaxSeats = 10;

// ── Legend definition ─────────────────────────────────────────────────────────

const _legendItems = [
  (label: 'Available',        fill: Color(0xFFFFFFFF), border: Color(0xFF2563EB)),
  (label: 'Selected',         fill: Color(0xFF059669), border: Color(0xFF059669)),
  (label: 'Booked (Male)',    fill: Color(0xFF1E3A8A), border: Color(0xFF1E3A8A)),
  (label: 'Booked (Female)',  fill: Color(0xFF880E4F), border: Color(0xFF880E4F)),
  (label: 'Pending',          fill: Color(0xFFD97706), border: Color(0xFFD97706)),
  (label: 'Unavailable',      fill: Color(0xFF475569), border: Color(0xFF475569)),
];

// ── Public widget ─────────────────────────────────────────────────────────────

class SeatSelectionSection extends StatefulWidget {
  const SeatSelectionSection({
    super.key,
    required this.bus,
    required this.selectedSeats,
    required this.onSeatsChanged,
    this.onGendersChanged,
  });

  final JourneyBusModel bus;
  final List<int> selectedSeats;
  final OnSeatSelected onSeatsChanged;
  final ValueChanged<Map<int, String>>? onGendersChanged;

  @override
  State<SeatSelectionSection> createState() => _SeatSelectionSectionState();
}

class _SeatSelectionSectionState extends State<SeatSelectionSection> {
  /// seat → gender ('Male' | 'Female')
  final Map<int, String> _seatGenders = {};

  void _onSeatTappedForGender(int seat) async {
    final gender = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _GenderPickerDialog(seatNumber: seat),
    );

    if (gender == null) return; // dismissed — don't add seat

    setState(() => _seatGenders[seat] = gender);

    final next = List<int>.from(widget.selectedSeats)..add(seat);
    next.sort();
    widget.onSeatsChanged(List.unmodifiable(next));
    widget.onGendersChanged?.call(Map.unmodifiable(_seatGenders));
  }

  void _onSeatDeselected(int seat) {
    setState(() => _seatGenders.remove(seat));
    final next = List<int>.from(widget.selectedSeats)..remove(seat);
    widget.onSeatsChanged(List.unmodifiable(next));
    widget.onGendersChanged?.call(Map.unmodifiable(_seatGenders));
  }

  Map<int, SeatStatus> _buildSeatStatuses() {
    final statuses = <int, SeatStatus>{};
    for (final entry in _seatGenders.entries) {
      statuses[entry.key] = entry.value == 'Male'
          ? SeatStatus.blockedMale
          : SeatStatus.blockedFemale;
    }
    return statuses;
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final selectedCount = widget.selectedSeats.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seat Selection',
          style: tt.titleMedium?.copyWith(
              color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        RichText(
          text: TextSpan(
            style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
            children: [
              const TextSpan(text: 'Select your preferred seats. You can select up to '),
              TextSpan(
                text: '$_kMaxSeats seats',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        BookingSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Card header + counter ───────────────────────────────────
              Row(
                children: [
                  const Expanded(
                    child: BookingCardHeader(
                      icon: Icons.event_seat_outlined,
                      title: 'Bus Seat Layout',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: selectedCount > 0
                          ? const Color(0xFF059669).withValues(alpha: 0.1)
                          : AppColors.section,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: selectedCount > 0
                            ? const Color(0xFF059669)
                            : AppColors.border,
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: tt.bodySmall?.copyWith(
                            color: AppColors.textSecondary, fontSize: 12),
                        children: [
                          TextSpan(
                            text: '$selectedCount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedCount > 0
                                  ? const Color(0xFF059669)
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const TextSpan(text: ' / $_kMaxSeats seats selected'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Legend ──────────────────────────────────────────────────
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                children: _legendItems
                    .map((item) => _LegendItem(
                          label: item.label,
                          fill: item.fill,
                          border: item.border,
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: AppSpacing.lg),

              // ── Seat layout ─────────────────────────────────────────────
              _buildLayout(),

              // ── Selected seats summary ──────────────────────────────────
              if (widget.selectedSeats.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: AppSpacing.md),
                _SelectedSeatsSummary(
                  selectedSeats: widget.selectedSeats,
                  seatGenders: _seatGenders,
                  ticketPrice: widget.bus.ticketPrice,
                  onRemove: _onSeatDeselected,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLayout() {
    final seatStatuses = _buildSeatStatuses();
    // Confirmed (gender-assigned) seats are rendered via seatStatuses as
    // blockedMale/blockedFemale (non-clickable). Only pending seats that
    // haven't received a gender yet are passed as selectedSeats.
    final selectedSet = widget.selectedSeats
        .where((s) => !_seatGenders.containsKey(s))
        .toSet();

    // All layout types currently use the 45-seat layout.
    // The passenger wrapper owns max-limit and gender-interception logic;
    // the shared TwoByTwo45SeatLayout is not modified.
    return PassengerTwoByTwo45Layout(
      seatStatuses: seatStatuses,
      selectedSeats: selectedSet,
      maxSelectable: _kMaxSeats,
      onSeatTappedForGender: _onSeatTappedForGender,
      onSeatDeselected: _onSeatDeselected,
    );
  }
}

// ── Gender picker dialog ──────────────────────────────────────────────────────

class _GenderPickerDialog extends StatelessWidget {
  const _GenderPickerDialog({required this.seatNumber});
  final int seatNumber;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg)),
      title: Text('Seat $seatNumber — Passenger Gender'),
      content: const Text('Select the gender of the passenger for this seat.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop('Male'),
          child: const Text('Male',
              style: TextStyle(color: Color(0xFF1E3A8A))),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop('Female'),
          child: const Text('Female',
              style: TextStyle(color: Color(0xFF880E4F))),
        ),
      ],
    );
  }
}

// ── Legend item ───────────────────────────────────────────────────────────────

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.fill,
    required this.border,
  });

  final String label;
  final Color fill;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(color: border, width: 1.5),
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

// ── Selected seats summary ────────────────────────────────────────────────────

class _SelectedSeatsSummary extends StatelessWidget {
  const _SelectedSeatsSummary({
    required this.selectedSeats,
    required this.seatGenders,
    required this.ticketPrice,
    required this.onRemove,
  });

  final List<int> selectedSeats;
  final Map<int, String> seatGenders;
  final double ticketPrice;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final total = ticketPrice * selectedSeats.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: selectedSeats.map((s) {
            final gender = seatGenders[s];
            final chipColor = gender == 'Male'
                ? const Color(0xFF1E3A8A)
                : gender == 'Female'
                    ? const Color(0xFF880E4F)
                    : AppColors.primary;
            return Chip(
              label: Text(
                gender != null ? 'Seat $s · $gender' : 'Seat $s',
                style: tt.bodySmall
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              backgroundColor: chipColor,
              deleteIconColor: Colors.white70,
              onDeleted: () => onRemove(s),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Total  ',
                style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
            Text(
              'LKR ${total.toStringAsFixed(2)}',
              style: tt.titleSmall?.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
