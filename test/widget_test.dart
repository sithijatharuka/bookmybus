import 'package:bookmybus/features/BusOwner/CallBooking/models/call_booking_model.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/steps/step2_seats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Step 2 shows the trip banner and the seat selection contract', (WidgetTester tester) async {
    final trip = CallBusTripModel(
      busName: 'THEUEU',
      busNumber: 'E454P',
      departureTime: '00:33',
      from: 'Trincomalee',
      to: 'Colombo',
      pricePerSeat: 1500,
      seatsLeft: 45,
    );

    final booking = CallBookingModel(
      travelDate: DateTime(2026, 9, 1),
      selectedTrip: trip,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Step2SeatsPage(
          booking: booking,
          onChanged: () {},
        ),
      ),
    );

    expect(find.text('THEUEU · Trincomalee → Colombo · 00:33'), findsOneWidget);
    expect(find.text('Select Seats (max 10)'), findsOneWidget);
    expect(find.text('Available'), findsWidgets);
    expect(find.text('Booked (M)'), findsOneWidget);
    expect(find.text('Booked (F)'), findsOneWidget);
  });
}
