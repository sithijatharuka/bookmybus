import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/journey_details_card.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/widgets/reservation_hold_banner.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class CheckoutSummary extends StatelessWidget {
  const CheckoutSummary({
    super.key,
    required this.bus,
    required this.date,
    required this.seatCount,
    required this.pickupPoint,
    required this.dropPoint,
  });

  final JourneyBusModel bus;
  final DateTime date;
  final int seatCount;
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
              child: JourneyDetailsCard(
                bus: bus,
                date: date,
                seatCount: seatCount,
                pickupPoint: pickupPoint,
                dropPoint: dropPoint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
