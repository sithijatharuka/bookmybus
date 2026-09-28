import 'package:bookmybus/shared/widgets/bus_seat_layouts/bus_seat_layout.dart';
import 'package:flutter/material.dart';

/// Passenger-facing 2+2 — 49-seat interactive layout.
///
/// Rows 1–11 : 4 seats (2 left | aisle | 2 right)
/// Row  12   : 5-seat back bench (45, 46, 47, 48, 49)
///
/// - [maxSelectable] cap enforced before any seat is added.
/// - [onSeatTappedForGender] fires when a new available seat is tapped,
///   so the caller can show a gender picker before confirming selection.
/// - Deselecting a seat always works without interception.
class PassengerTwoByTwo49Layout extends StatefulWidget {
  const PassengerTwoByTwo49Layout({
    super.key,
    required this.seatStatuses,
    required this.selectedSeats,
    required this.maxSelectable,
    required this.onSeatTappedForGender,
    required this.onSeatDeselected,
  });

  final Map<int, SeatStatus> seatStatuses;
  final Set<int> selectedSeats;
  final int maxSelectable;

  /// Called with the seat number when an available seat is tapped and the
  /// max limit has not been reached. The caller is responsible for confirming
  /// the selection (e.g. after a gender dialog).
  final ValueChanged<int> onSeatTappedForGender;

  /// Called with the seat number when a selected seat is tapped to deselect.
  final ValueChanged<int> onSeatDeselected;

  @override
  State<PassengerTwoByTwo49Layout> createState() =>
      _PassengerTwoByTwo49LayoutState();
}

class _PassengerTwoByTwo49LayoutState extends State<PassengerTwoByTwo49Layout> {
  static const List<List<int?>> _rows = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16],
    [17, 18, 19, 20],
    [21, 22, 23, 24],
    [25, 26, 27, 28],
    [29, 30, 31, 32],
    [33, 34, 35, 36],
    [37, 38, 39, 40],
    [41, 42, 43, 44],
  ];

  static const List<int> _backRow = [45, 46, 47, 48, 49];

  void _onTap(int seat) {
    final status = widget.seatStatuses[seat] ?? SeatStatus.available;
    if (!status.isClickable) return;

    if (widget.selectedSeats.contains(seat)) {
      widget.onSeatDeselected(seat);
    } else {
      if (widget.selectedSeats.length >= widget.maxSelectable) return;
      widget.onSeatTappedForGender(seat);
    }
  }

  SeatStatus _status(int seat) =>
      widget.seatStatuses[seat] ?? SeatStatus.available;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._rows.asMap().entries.map((entry) {
              final seats = entry.value;
              return _SeatRow(
                rowNumber: entry.key + 1,
                left: [seats[0], seats[1]],
                right: [seats[2], seats[3]],
                effectiveStatus: _status,
                isSelected: widget.selectedSeats.contains,
                onTap: _onTap,
              );
            }),
            const SizedBox(height: 8),
            _BackRow(
              rowNumber: 12,
              seats: _backRow,
              effectiveStatus: _status,
              isSelected: widget.selectedSeats.contains,
              onTap: _onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _SeatRow extends StatelessWidget {
  const _SeatRow({
    required this.rowNumber,
    required this.left,
    required this.right,
    required this.effectiveStatus,
    required this.isSelected,
    required this.onTap,
  });

  final int rowNumber;
  final List<int?> left;
  final List<int?> right;
  final SeatStatus Function(int) effectiveStatus;
  final bool Function(int) isSelected;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$rowNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(width: 4),
          ...left.map((s) => s != null
              ? _SeatCell(
                  seat: s,
                  status: effectiveStatus(s),
                  isSelected: isSelected(s),
                  onTap: onTap,
                )
              : const _EmptyCell()),
          const SizedBox(width: 36),
          ...right.map((s) => s != null
              ? _SeatCell(
                  seat: s,
                  status: effectiveStatus(s),
                  isSelected: isSelected(s),
                  onTap: onTap,
                )
              : const _EmptyCell()),
        ],
      ),
    );
  }
}

class _BackRow extends StatelessWidget {
  const _BackRow({
    required this.rowNumber,
    required this.seats,
    required this.effectiveStatus,
    required this.isSelected,
    required this.onTap,
  });

  final int rowNumber;
  final List<int> seats;
  final SeatStatus Function(int) effectiveStatus;
  final bool Function(int) isSelected;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$rowNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(width: 4),
          ...seats.map((s) => _SeatCell(
                seat: s,
                status: effectiveStatus(s),
                isSelected: isSelected(s),
                onTap: onTap,
              )),
        ],
      ),
    );
  }
}

class _SeatCell extends StatelessWidget {
  const _SeatCell({
    required this.seat,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  final int seat;
  final SeatStatus status;
  final bool isSelected;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final bg = status.fillColor;
    final border = status.borderColor;
    final effectiveBg = isSelected ? border : bg;
    final textColor = effectiveBg.computeLuminance() > 0.4
        ? const Color(0xFF1E293B)
        : Colors.white;

    return GestureDetector(
      onTap: status.isClickable ? () => onTap(seat) : null,
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          '$seat',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _EmptyCell extends StatelessWidget {
  const _EmptyCell();

  @override
  Widget build(BuildContext context) => const SizedBox(width: 50, height: 44);
}
