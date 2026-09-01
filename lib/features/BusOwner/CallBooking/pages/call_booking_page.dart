import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import '../models/call_booking_model.dart';
import '../steps/step1_bus_date_page.dart';
import '../steps/step2_seats_page.dart';
import '../steps/step3_passenger_page.dart';
import '../steps/step4_confirm_page.dart';

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
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.xxl),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 36,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Booking Confirmed!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'The booking has been created successfully.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
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
              _CallBookingStepIndicator(
                steps: _steps,
                currentStep: _currentStep,
              ),

              // ── Page header ────────────────────────────────
              _PageHeader(onViewRecent: () {}),

              // ── Step content ───────────────────────────────
              Expanded(child: _stepView),

              // ── Nav bar ────────────────────────────────────
              _CallBookingNavBar(
                currentStep: _currentStep,
                totalSteps: _steps.length,
                canProceed: _canProceed,
                onBack: () => setState(() => _currentStep--),
                onNext: () => setState(() => _currentStep++),
                onSubmit: _onSubmit,
              ),
            ],
          ),

          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.white),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Page Header ───────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.onViewRecent});
  final VoidCallback onViewRecent;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Call / Walk-in Booking', style: tt.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Create an instant confirmed booking for a customer',
                  style: tt.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: onViewRecent,
            icon: const Icon(Icons.history_rounded, size: 18),
            label: const Text('View Recent'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step Indicator ────────────────────────────────────────────────────────────

class _CallBookingStepIndicator extends StatelessWidget {
  const _CallBookingStepIndicator({
    required this.steps,
    required this.currentStep,
  });

  final List<({String label, IconData icon})> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final done = (i ~/ 2) < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: done ? AppColors.primary : AppColors.border,
              ),
            );
          }

          final idx = i ~/ 2;
          final isDone = idx < currentStep;
          final isActive = idx == currentStep;

          return Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDone || isActive
                      ? AppColors.primary
                      : AppColors.section,
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: AppColors.primaryLight, width: 2)
                      : null,
                ),
                child: Icon(
                  isDone ? Icons.check_rounded : steps[idx].icon,
                  size: 18,
                  color: isDone || isActive
                      ? AppColors.white
                      : AppColors.textHint,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                steps[idx].label,
                style: tt.bodyMedium?.copyWith(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                  color: isActive ? AppColors.primary : AppColors.textHint,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Nav Bar ───────────────────────────────────────────────────────────────────

class _CallBookingNavBar extends StatelessWidget {
  const _CallBookingNavBar({
    required this.currentStep,
    required this.totalSteps,
    required this.canProceed,
    required this.onBack,
    required this.onNext,
    required this.onSubmit,
  });

  final int currentStep;
  final int totalSteps;
  final bool canProceed;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  bool get _isFirst => currentStep == 0;
  bool get _isLast => currentStep == totalSteps - 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Back button — always rendered to keep layout stable
          Expanded(
            child: OutlinedButton(
              onPressed: _isFirst ? null : onBack,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                disabledForegroundColor: AppColors.textDisabled,
                side: BorderSide(
                  color: _isFirst ? AppColors.textDisabled : AppColors.primary,
                ),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              child: const Text('← Back'),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Next / Confirm button
          Expanded(
            child: FilledButton(
              onPressed: canProceed ? (_isLast ? onSubmit : onNext) : null,
              style: FilledButton.styleFrom(
                backgroundColor: _isLast
                    ? AppColors.success
                    : AppColors.primary,
                disabledBackgroundColor: AppColors.textDisabled,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLast) ...[
                    const Icon(Icons.check_circle_outline_rounded, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(_isLast ? 'Confirm Booking' : 'Next →'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
