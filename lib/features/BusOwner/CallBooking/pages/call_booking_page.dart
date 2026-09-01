import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import '../models/call_booking_model.dart';
import '../steps/step1_bus_date_page.dart';
import '../steps/step2_seats_page.dart';
import '../steps/step3_passenger_page.dart';
import '../steps/step4_confirm_page.dart';
import '../widgets/call_booking_step_indicator.dart';
import '../widgets/call_booking_page_header.dart';
import '../widgets/call_booking_nav_bar.dart';
import '../widgets/call_booking_loading_overlay.dart';
import '../widgets/call_booking_success_dialog.dart';

class CallBookingPage extends StatefulWidget {
  const CallBookingPage({super.key});

  @override
  State<CallBookingPage> createState() => _CallBookingPageState();
}

class _CallBookingPageState extends State<CallBookingPage> {
  int _currentStep = 0;
  bool _isSubmitting = false;

  final _booking = CallBookingModel();

  static const _steps = [
    (label: 'Bus & Date', icon: Icons.directions_bus_outlined),
    (label: 'Seats', icon: Icons.event_seat_outlined),
    (label: 'Passenger', icon: Icons.person_outline_rounded),
    (label: 'Confirm', icon: Icons.check_circle_outline_rounded),
  ];

  // ── Validation per step ───────────────────────────────────────────────────

  bool get _canProceed => switch (_currentStep) {
    0 => _booking.travelDate != null && _booking.selectedTrip != null,
    1 => _booking.selectedSeats.isNotEmpty &&
        _booking.seatGenders.length == _booking.selectedSeats.length,
    2 =>
      _booking.passengerName.trim().split(RegExp(r'\s+')).length > 1 &&
          _booking.passengerPhone.isNotEmpty,
    _ => true,
  };

  // ── Step view ─────────────────────────────────────────────────────────────

  Widget get _stepView => switch (_currentStep) {
    0 => Step1BusDatePage(booking: _booking, onChanged: () => setState(() {})),
    1 => Step2SeatsPage(booking: _booking, onChanged: () => setState(() {})),
    2 => Step3PassengerPage(
      booking: _booking,
      onChanged: () => setState(() {}),
    ),
    3 => Step4ConfirmPage(booking: _booking),
    _ => const SizedBox.shrink(),
  };

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _onSubmit() async {
    setState(() => _isSubmitting = true);
    try {
      // TODO: API integration
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      _showSuccessDialog();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CallBookingSuccessDialog(
        onDone: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Call / Walk-in Booking'),
      body: Stack(
        children: [
          Column(
            children: [
              // ── Step indicator ─────────────────────────────
              CallBookingStepIndicator(
                steps: _steps,
                currentStep: _currentStep,
              ),

              // ── Page header ────────────────────────────────
              CallBookingPageHeader(onViewRecent: () {}),

              // ── Step content ───────────────────────────────
              Expanded(child: _stepView),

              // ── Nav bar ────────────────────────────────────
              CallBookingNavBar(
                currentStep: _currentStep,
                totalSteps: _steps.length,
                canProceed: _canProceed,
                onBack: () => setState(() => _currentStep--),
                onNext: () => setState(() => _currentStep++),
                onSubmit: _onSubmit,
              ),
            ],
          ),

          CallBookingLoadingOverlay(isVisible: _isSubmitting),
        ],
      ),
    );
  }
}
