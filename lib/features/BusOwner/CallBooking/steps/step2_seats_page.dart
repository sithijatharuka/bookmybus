import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/bus_seat_layout.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/two_by_two_45_seat_layout.dart';
import 'package:flutter/material.dart';
import '../models/call_booking_model.dart';

class Step2SeatsPage extends StatefulWidget {
  const Step2SeatsPage({
    super.key,
    required this.booking,
    required this.onChanged,
  });

  final CallBookingModel booking;
  final VoidCallback onChanged;

  @override
  State<Step2SeatsPage> createState() => _Step2SeatsPageState();
}

class _Step2SeatsPageState extends State<Step2SeatsPage> {
  Set<int> _pendingSeatSelection = {};

  void _onSeatSelected(List<int> seats) {
    final previous = widget.booking.selectedSeats.toSet();
    final next = seats.toSet();
    final newlySelected = next.difference(previous).toList();

    final kept = <int, String>{};
    for (final seat in seats) {
      final gender = widget.booking.seatGenders[seat];
      if (gender != null) {
        kept[seat] = gender;
      }
    }

    widget.booking.selectedSeats = List<int>.from(seats);
    widget.booking.seatGenders = kept;
    widget.onChanged();

    if (newlySelected.isNotEmpty) {
      final seat = newlySelected.first;
      if (!widget.booking.seatGenders.containsKey(seat)) {
        _pendingSeatSelection = {seat};
        WidgetsBinding.instance.addPostFrameCallback((_) => _showGenderPicker(seat));
      }
    }
  }

  void _assignGender(int seat, String gender) {
    final next = Map<int, String>.from(widget.booking.seatGenders)
      ..[seat] = gender;
    widget.booking.seatGenders = next;
    _pendingSeatSelection = {};
    setState(() {});
    widget.onChanged();
  }

  Future<void> _showGenderPicker(int seat) async {
    final selected = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text('Select gender'),
        content: const Text('Choose the passenger gender for this seat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('Male'),
            child: const Text('Male'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('Female'),
            child: const Text('Female'),
          ),
        ],
      ),
    );

    if (selected != null) {
      _assignGender(seat, selected);
    } else {
      widget.booking.selectedSeats = List<int>.from(
        widget.booking.selectedSeats.where((value) => value != seat),
      );
      _pendingSeatSelection = {};
      setState(() {});
      widget.onChanged();
    }
  }

  void _removeSeat(int seat) {
    final next = Map<int, String>.from(widget.booking.seatGenders);
    next.remove(seat);
    widget.booking.seatGenders = next;
    widget.booking.selectedSeats.remove(seat);
    setState(() {});
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.booking.selectedTrip!;
    final selected = widget.booking.selectedSeats;
    final total = selected.length * trip.pricePerSeat;
    final missingGender = selected
        .where((seat) => !widget.booking.seatGenders.containsKey(seat))
        .toList();

    final validSelectedSeats = Set<int>.from(selected)
      .difference(_pendingSeatSelection)
      .toSet();

    final seatStatuses = <int, SeatStatus>{};
    for (final seat in List<int>.generate(8, (index) => index + 1)) {
      seatStatuses[seat] = SeatStatus.blockedMale;
    }
    for (final seat in [9, 10, 11, 12]) {
      seatStatuses[seat] = SeatStatus.blockedFemale;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TripInfoBar(
            busName: trip.busName,
            from: trip.from,
            to: trip.to,
            departureTime: trip.departureTime,
          ),
          const SizedBox(height: AppSpacing.lg),
          _HeaderRow(
            selectedCount: selected.length,
            totalFare: total,
          ),
          const SizedBox(height: AppSpacing.sm),
          _LegendRow(),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF2F5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD8DEE8)),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 32, 18, 18),
                  child: TwoByTwo45SeatLayout(
                    seatStatuses: seatStatuses,
                    selectedSeats: validSelectedSeats,
                    onSeatSelected: _onSeatSelected,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1D4ED8),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'DRV',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 220,
                      height: 2,
                      color: const Color(0xFFCBD5E1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (validSelectedSeats.isNotEmpty)
            _SelectionSummary(
              selected: validSelectedSeats.toList()..sort(),
              seatGenders: widget.booking.seatGenders,
              onGenderSelected: _assignGender,
              onRemove: _removeSeat,
            ),
          if (missingGender.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4D5),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: const Color(0xFFE4B95F)),
              ),
              child: Text(
                'Please select a gender (Male/Female) for every seat before continuing. Seats without a gender are not held and you can\'t proceed to the next step.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF7A4F00),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }
}

class _TripInfoBar extends StatelessWidget {
  const _TripInfoBar({
    required this.busName,
    required this.from,
    required this.to,
    required this.departureTime,
  });

  final String busName;
  final String from;
  final String to;
  final String departureTime;

  @override
  Widget build(BuildContext context) {
    final text = '$busName · $from → $to · $departureTime';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: const Color(0xFF1D4ED8),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.selectedCount,
    required this.totalFare,
  });

  final int selectedCount;
  final double totalFare;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            'Select Seats (max 10)',
            style: tt.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '${selectedCount == 0 ? 0 : selectedCount} selected · LKR ${totalFare.toStringAsFixed(0)}',
          style: tt.titleSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (label: 'Available', color: Colors.white, border: const Color(0xFF2ECC71)),
      (label: 'Booked (M)', color: const Color(0xFF2563EB), border: const Color(0xFF2563EB)),
      (label: 'Booked (F)', color: const Color(0xFFFCE7F3), border: const Color(0xFFEC4899)),
      (label: 'Pending', color: const Color(0xFFFDE68A), border: const Color(0xFFEAB308)),
      (label: 'Unavailable', color: const Color(0xFFD1D5DB), border: const Color(0xFF6B7280)),
      (label: 'Selected', color: const Color(0xFF1D4ED8), border: const Color(0xFF1D4ED8)),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: item.border, width: 1.5),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _SelectionSummary extends StatelessWidget {
  const _SelectionSummary({
    required this.selected,
    required this.seatGenders,
    required this.onGenderSelected,
    required this.onRemove,
  });

  final List<int> selected;
  final Map<int, String> seatGenders;
  final void Function(int, String) onGenderSelected;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: selected.map((seat) {
          final gender = seatGenders[seat];
          final label = '#$seat $gender';

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => onRemove(seat),
                  child: const Icon(Icons.close, size: 16, color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
