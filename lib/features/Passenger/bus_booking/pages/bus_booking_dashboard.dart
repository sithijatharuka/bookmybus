import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/booking_header.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/passenger_details_section.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/passenger_form_section.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/seat_selection_section.dart';
import 'package:bookmybus/features/Passenger/checkout_summary/page/checkout_summary.dart';
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
  Map<int, String> _seatGenders = {};

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
    final seatCount = _selectedSeats.length;
    final total = seatCount * widget.bus.ticketPrice;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Book Bus'),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE6E9F5))),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$seatCount ${seatCount == 1 ? 'Seat' : 'Seats'}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  'LKR ${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: FilledButton(
                onPressed: seatCount > 0
                    ? () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CheckoutSummary(
                              bus: widget.bus,
                              date: widget.date,
                              seatCount: seatCount,
                              selectedSeats: _selectedSeats,
                              seatGenders: _seatGenders,
                              accountPhone:
                                  '+94${_phoneController.text.trim()}',
                              pickupPoint: widget.bus.boardingPoints.isNotEmpty
                                  ? widget.bus.boardingPoints.first.location
                                  : widget.bus.from,
                              dropPoint: widget.bus.boardingPoints.length > 1
                                  ? widget.bus.boardingPoints.last.location
                                  : widget.bus.to,
                            ),
                          ),
                        )
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: const Color(0xFFD8DEEF),
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
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
            const PassengerFormSection(),
            const SizedBox(height: AppSpacing.xl),
            SeatSelectionSection(
              bus: widget.bus,
              selectedSeats: _selectedSeats,
              onSeatsChanged: (seats) => setState(() => _selectedSeats = seats),
              onGendersChanged: (genders) =>
                  setState(() => _seatGenders = genders),
            ),
          ],
        ),
      ),
    );
  }
}
