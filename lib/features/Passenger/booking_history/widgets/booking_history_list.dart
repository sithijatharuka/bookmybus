import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/booking_history/data/passenger_booking_store.dart';
import 'package:bookmybus/features/Passenger/booking_history/models/passenger_booking_model.dart';
import 'package:bookmybus/features/Passenger/booking_history/widgets/booking_history_card.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/dummy_payhere_widget.dart';
import 'package:flutter/material.dart';

class BookingHistoryList extends StatelessWidget {
  const BookingHistoryList({
    super.key,
    required this.bookings,
    required this.onViewBooking,
  });

  final List<PassengerBookingModel> bookings;
  final ValueChanged<PassengerBookingModel> onViewBooking;

  void _confirmCancel(BuildContext context, PassengerBookingModel booking) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text('Cancel booking ${booking.ticketRef}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              PassengerBookingStore.instance.cancelBooking(booking.ticketRef);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: [
              const Icon(Icons.history_outlined, size: 48, color: AppColors.textHint),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No bookings found',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textHint),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookings.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, i) {
        final b = bookings[i];
        return BookingHistoryCard(
          booking: b,
          onView: () => onViewBooking(b),
          onPayNow: () => DummyPayhereWidget.show(
            context,
            ticketRef: b.ticketRef,
            totalAmount: b.totalAmount,
            route: b.route,
            travelDate: b.travelDate,
            seatCount: b.selectedSeats.length,
            passengerName: b.passengerName,
            passengerPhone: b.passengerPhone,
          ),
          onCancel: () => _confirmCancel(context, b),
        );
      },
    );
  }
}
