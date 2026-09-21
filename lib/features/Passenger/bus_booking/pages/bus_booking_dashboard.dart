import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/booking_header.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/passenger_details_section.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/seat_selection_section.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class BusBookingDashboard extends StatefulWidget {
  const BusBookingDashboard({
    super.key,
    required this.bus,
    required this.date,
  });

  final JourneyBusModel bus;
  final DateTime date;

  @override
  State<BusBookingDashboard> createState() => _BusBookingDashboardState();
}

class _BusBookingDashboardState extends State<BusBookingDashboard> {
  final _phoneController = TextEditingController();
  bool _otpSent = false;
  List<int> _selectedSeats = [];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_phoneController.text.trim().isEmpty) return;
    setState(() => _otpSent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Book Bus'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingHeader(bus: widget.bus, date: widget.date),
            const SizedBox(height: AppSpacing.xl),
            PassengerDetailsSection(
              phoneController: _phoneController,
              otpSent: _otpSent,
              onSendOtp: _sendOtp,
            ),
            const SizedBox(height: AppSpacing.xl),
            SeatSelectionSection(
              bus: widget.bus,
              selectedSeats: _selectedSeats,
              onSeatsChanged: (seats) => setState(() => _selectedSeats = seats),
            ),
          ],
        ),
      ),
    );
  }
}
