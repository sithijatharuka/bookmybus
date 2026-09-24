import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/bus_information_card.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/important_notes_footer.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/journey_details_card.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/passenger_details_card.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/payment_summary_card.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/reservation_hold_banner.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/selected_seats_card.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

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
                  // 1. Journey Details
                  JourneyDetailsCard(
                    bus: bus,
                    date: date,
                    seatCount: seatCount,
                    pickupPoint: pickupPoint,
                    dropPoint: dropPoint,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 2. Bus Information
                  BusInformationCard(bus: bus),
                  const SizedBox(height: AppSpacing.lg),

                  // 3. Passenger Details
                  PassengerDetailsCard(accountPhone: accountPhone),
                  const SizedBox(height: AppSpacing.lg),

                  // 4. Selected Seats
                  SelectedSeatsCard(
                    selectedSeats: selectedSeats,
                    seatGenders: seatGenders,
                    ticketPrice: bus.ticketPrice,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 5. Payment Summary & Breakdown
                  PaymentSummaryCard(
                    ticketPrice: bus.ticketPrice,
                    seatCount: seatCount,
                    onConfirm: () {},
                    onCancel: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 6. Important Notes Footer
                  // const ImportantNotesFooter(),
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
