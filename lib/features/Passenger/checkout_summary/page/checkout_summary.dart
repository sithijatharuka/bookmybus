import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/booking_history/data/passenger_booking_store.dart';
import 'package:bookmybus/features/Passenger/booking_history/models/passenger_booking_model.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/bus_information_card.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/confirm_booking_dialog.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/dummy_payhere_widget.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/journey_details_card.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/passenger_details_card.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/payment_summary_card.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/reservation_hold_banner.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/selected_seats_card.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

const double _kPlatformFee = 100.0;
const double _kGatewayFeeRate = 0.031;

class CheckoutSummary extends StatelessWidget {
  const CheckoutSummary({
    super.key,
    required this.bus,
    required this.date,
    required this.seatCount,
    required this.selectedSeats,
    required this.seatGenders,
    required this.accountPhone,
    required this.pickupPoint,
    required this.dropPoint,
  });

  final JourneyBusModel bus;
  final DateTime date;
  final int seatCount;
  final List<int> selectedSeats;
  final Map<int, String> seatGenders;
  final String accountPhone;
  final String pickupPoint;
  final String dropPoint;

  double get _total {
    final subtotal = bus.ticketPrice * seatCount;
    final gatewayFee = (subtotal + _kPlatformFee) * _kGatewayFeeRate;
    return subtotal + _kPlatformFee + gatewayFee;
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ConfirmBookingDialog(
        seatCount: seatCount,
        travelDate: date,
        onConfirm: () => _createBookingAndPay(context),
      ),
    );
  }

  void _createBookingAndPay(BuildContext context) {
    final ticketRef = PassengerBookingStore.generateTicketRef();
    final booking = PassengerBookingModel(
      ticketRef: ticketRef,
      travelDate: date,
      from: bus.from,
      to: bus.to,
      busName: bus.busName,
      busNumber: bus.registrationNumber,
      busType: bus.busType,
      departureTime: bus.departureTime,
      selectedSeats: selectedSeats,
      seatGenders: seatGenders,
      passengerName: '',
      passengerPhone: accountPhone,
      pickupPoint: pickupPoint,
      dropPoint: dropPoint,
      status: PassengerBookingStatus.pending,
      bookedAt: DateTime.now(),
      totalAmount: _total,
      paymentStatus: 'Unpaid',
    );

    PassengerBookingStore.instance.addBooking(booking);

    DummyPayhereWidget.show(
      context,
      ticketRef: ticketRef,
      totalAmount: _total,
      route: bus.routeName,
      travelDate: date,
      seatCount: seatCount,
      passengerName: '',
      passengerPhone: accountPhone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Checkout'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ReservationHoldBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  JourneyDetailsCard(
                    bus: bus,
                    date: date,
                    seatCount: seatCount,
                    pickupPoint: pickupPoint,
                    dropPoint: dropPoint,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BusInformationCard(bus: bus),
                  const SizedBox(height: AppSpacing.lg),
                  PassengerDetailsCard(accountPhone: accountPhone),
                  const SizedBox(height: AppSpacing.lg),
                  SelectedSeatsCard(
                    selectedSeats: selectedSeats,
                    seatGenders: seatGenders,
                    ticketPrice: bus.ticketPrice,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PaymentSummaryCard(
                    ticketPrice: bus.ticketPrice,
                    seatCount: seatCount,
                    onConfirm: () => _showConfirmDialog(context),
                    onCancel: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
