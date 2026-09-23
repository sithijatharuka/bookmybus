import 'dart:async';
import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ReservationHoldBanner extends StatefulWidget {
  const ReservationHoldBanner({super.key, this.holdDuration = const Duration(minutes: 10)});

  final Duration holdDuration;

  @override
  State<ReservationHoldBanner> createState() => _ReservationHoldBannerState();
}

class _ReservationHoldBannerState extends State<ReservationHoldBanner> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.holdDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 0) {
        _timer?.cancel();
        return;
      }
      setState(() => _remaining -= const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timerLabel {
    final m = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      color: AppColors.warningLight,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.warning,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _timerLabel,
              style: tt.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: tt.bodySmall?.copyWith(color: const Color(0xFF92400E)),
                children: const [
                  TextSpan(
                    text: 'Your seats are reserved',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: ' — complete checkout before the timer runs out.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
