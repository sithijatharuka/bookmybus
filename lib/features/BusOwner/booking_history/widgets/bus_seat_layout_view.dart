import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/bus_seat_layout.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/two_by_two_45_seat_layout.dart';
import 'package:flutter/material.dart';
import '../models/booking_history_model.dart';

class BusSeatLayoutView extends StatefulWidget {
  const BusSeatLayoutView({
    super.key,
    required this.busNumber,
    required this.travelDate,
    required this.bookings,
  });

  final String busNumber;
  final String travelDate;
  final List<BookingHistoryModel> bookings;

  static void show(
    BuildContext context, {
    required String busNumber,
    required String travelDate,
    required List<BookingHistoryModel> bookings,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BusSeatLayoutView(
        busNumber: busNumber,
        travelDate: travelDate,
        bookings: bookings,
      ),
    );
  }

  @override
  State<BusSeatLayoutView> createState() => _BusSeatLayoutViewState();
}

class _BusSeatLayoutViewState extends State<BusSeatLayoutView> {
  int? _selectedSeat;

  // Aggregate booked seats → SeatStatus map and callBookingSeats map
  Map<int, SeatStatus> get _seatStatuses {
    final map = <int, SeatStatus>{};
    for (final booking in widget.bookings) {
      for (final s in booking.seats) {
        final match = RegExp(r'(\d+)\s*\((Male|Female)\)', caseSensitive: false)
            .firstMatch(s);
        if (match != null) {
          final seatNum = int.parse(match.group(1)!);
          final isFemale = match.group(2)!.toLowerCase() == 'female';
          map[seatNum] = isFemale ? SeatStatus.blockedFemale : SeatStatus.blockedMale;
        }
      }
    }
    return map;
  }

  Map<int, ({String gender, String phone})> get _callBookingSeats {
    final map = <int, ({String gender, String phone})>{};
    for (final booking in widget.bookings) {
      if (!booking.isCallBooking) continue;
      for (final s in booking.seats) {
        final match = RegExp(r'(\d+)\s*\((Male|Female)\)', caseSensitive: false)
            .firstMatch(s);
        if (match != null) {
          map[int.parse(match.group(1)!)] = (
            gender: match.group(2)!.toLowerCase() == 'male' ? 'M' : 'F',
            phone: booking.passengerPhone,
          );
        }
      }
    }
    return map;
  }

  // Keep _bookedSeats for the detail card lookup
  Map<int, ({String gender, String phone, bool isCall, String name})> get _bookedSeats {
    final map = <int, ({String gender, String phone, bool isCall, String name})>{};
    for (final booking in widget.bookings) {
      for (final s in booking.seats) {
        final match = RegExp(r'(\d+)\s*\((Male|Female)\)', caseSensitive: false)
            .firstMatch(s);
        if (match != null) {
          map[int.parse(match.group(1)!)] = (
            gender: match.group(2)!.toLowerCase() == 'male' ? 'M' : 'F',
            phone: booking.passengerPhone,
            isCall: booking.isCallBooking,
            name: booking.passengerName,
          );
        }
      }
    }
    return map;
  }

  String get _busLabel {
    if (widget.bookings.isNotEmpty) {
      return '${widget.bookings.first.busName.toUpperCase()} (${widget.busNumber})';
    }
    return widget.busNumber;
  }

  String get _routeLabel {
    if (widget.bookings.isNotEmpty) {
      return '${widget.bookings.first.from} → ${widget.bookings.first.to}';
    }
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final booked = _bookedSeats;
    final seatStatuses = _seatStatuses;
    const totalSeats = 45;
    final bookedCount = seatStatuses.length;
    final availableCount = totalSeats - bookedCount;
    final maleCount = seatStatuses.values.where((v) => v == SeatStatus.blockedMale).length;
    final femaleCount = seatStatuses.values.where((v) => v == SeatStatus.blockedFemale).length;
    final selectedInfo = _selectedSeat != null ? booked[_selectedSeat!] : null;

    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(
              busLabel: _busLabel,
              routeLabel: _routeLabel,
              travelDate: widget.travelDate,
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SummaryChips(
                      total: totalSeats,
                      booked: bookedCount,
                      available: availableCount,
                      male: maleCount,
                      female: femaleCount,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _Legend(),
                    const SizedBox(height: AppSpacing.lg),
                    TwoByTwo45SeatLayout(
                      seatStatuses: _seatStatuses,
                      callBookingSeats: _callBookingSeats,
                      onSeatTapped: (seatNum) => setState(() {
                        _selectedSeat = _selectedSeat == seatNum ? null : seatNum;
                      }),
                    ),
                    if (selectedInfo != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      SeatDetailCardWidget(
                        seatNumber: _selectedSeat!,
                        passengerName: selectedInfo.name,
                        gender: selectedInfo.gender,
                        phone: selectedInfo.phone,
                        isCallBooking: selectedInfo.isCall,
                        onDismiss: () => setState(() => _selectedSeat = null),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.busLabel,
    required this.routeLabel,
    required this.travelDate,
  });

  final String busLabel;
  final String routeLabel;
  final String travelDate;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.sm, AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  busLabel,
                  style: tt.titleMedium
                      ?.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  routeLabel,
                  style: tt.bodySmall?.copyWith(color: AppColors.white.withOpacity(0.85)),
                ),
                Text(
                  travelDate,
                  style: tt.bodySmall?.copyWith(color: AppColors.white.withOpacity(0.85)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

// ─── Summary Chips ────────────────────────────────────────────────────────────

class _SummaryChips extends StatelessWidget {
  const _SummaryChips({
    required this.total,
    required this.booked,
    required this.available,
    required this.male,
    required this.female,
  });

  final int total, booked, available, male, female;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _Chip('Total Seats: $total', const Color(0xFFEEEEEE), AppColors.textPrimary),
        _Chip('Booked: $booked', const Color(0xFFDCEEFD), const Color(0xFF1565C0)),
        _Chip('Available: $available', const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
        _Chip('Male: $male', AppColors.primary, AppColors.white),
        _Chip('Female: $female', const Color(0xFFFF4081), AppColors.white),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.bg, this.fg);
  final String label;
  final Color bg, fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Text(label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Legend ───────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: [
        _LegendItem(
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.border, width: 1.5),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
          label: 'Available',
          tt: tt,
        ),
        _LegendItem(
          child: _SeatSquare(color: AppColors.primary, label: 'M'),
          label: 'Male',
          tt: tt,
        ),
        _LegendItem(
          child: _SeatSquare(color: const Color(0xFFFF4081), label: 'F'),
          label: 'Female',
          tt: tt,
        ),
        _LegendItem(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: const Text('C',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold)),
              ),
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Text('C',
                      style: TextStyle(
                          color: Color(0xFF1E3A8A),
                          fontSize: 5,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          label: 'Call Booking',
          tt: tt,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.child, required this.label, required this.tt});
  final Widget child;
  final String label;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _SeatSquare extends StatelessWidget {
  const _SeatSquare({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.xs)),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

// ─── Seat Detail Card ─────────────────────────────────────────────────────────

class SeatDetailCardWidget extends StatelessWidget {
  const SeatDetailCardWidget({
    super.key,
    required this.seatNumber,
    required this.passengerName,
    required this.gender,
    required this.phone,
    required this.isCallBooking,
    required this.onDismiss,
  });

  final int seatNumber;
  final String passengerName;
  final String gender;
  final String phone;
  final bool isCallBooking;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isFemale = gender == 'F';
    final genderLabel = isFemale ? 'Female' : 'Male';
    final genderColor =
        isFemale ? const Color(0xFFDB2777) : const Color(0xFF2563EB);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seat $seatNumber Details',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: Text(
                  'Dismiss',
                  style: tt.bodySmall?.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // 2×2 grid
          Row(
            children: [
              Expanded(
                child: _DetailField(
                  label: 'Passenger',
                  value: passengerName,
                ),
              ),
              Expanded(
                child: _DetailField(
                  label: 'Gender',
                  value: genderLabel,
                  valueColor: genderColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _DetailField(
                  label: 'Contact',
                  value: phone,
                ),
              ),
              Expanded(
                child: _DetailField(
                  label: 'Booking Type',
                  value: isCallBooking ? 'Call Booking' : 'Online',
                  valueColor:
                      isCallBooking ? const Color(0xFFD97706) : AppColors.textPrimary,
                  icon: isCallBooking ? Icons.phone_in_talk_outlined : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.label,
    required this.value,
    this.valueColor,
    this.icon,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final color = valueColor ?? AppColors.textPrimary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.bodySmall?.copyWith(color: AppColors.textHint, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 3),
            ],
            Flexible(
              child: Text(
                value,
                style: tt.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
            label: const Text('Export PDF'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
