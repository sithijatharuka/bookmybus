import 'package:bookmybus/shared/widgets/bus_seat_layouts/bus_seat_layout.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/two_by_two_45_seat_layout.dart';
import 'package:flutter/material.dart';

/// Passenger-specific wrapper around [TwoByTwo45SeatLayout].
///
/// Adds:
/// - [maxSelectable] cap enforced before any seat is added.
/// - [onSeatTappedForGender] intercept: fires instead of toggling when a new
///   available seat is tapped, so the caller can show a gender picker first.
///
/// Deselecting a seat always works without interception.
/// The Bus Owner layout ([TwoByTwo45SeatLayout]) is left completely unchanged.
class PassengerTwoByTwo45Layout extends StatelessWidget {
  const PassengerTwoByTwo45Layout({
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
  Widget build(BuildContext context) {
    return TwoByTwo45SeatLayout(
      seatStatuses: seatStatuses,
      selectedSeats: selectedSeats,
      onSeatTapped: (seat) {
        final isSelected = selectedSeats.contains(seat);
        if (isSelected) {
          onSeatDeselected(seat);
        } else {
          if (selectedSeats.length >= maxSelectable) return;
          onSeatTappedForGender(seat);
        }
      },
      // onSeatSelected is intentionally not wired — all state changes go
      // through onSeatTappedForGender / onSeatDeselected so the parent
      // controls the seat list and gender map together.
    );
  }
}
