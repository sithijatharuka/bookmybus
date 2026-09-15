import 'dart:async';

import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/auth/login/widgets/auth_form_field.dart';
import 'package:flutter/material.dart';

class PhoneOtpAuthCard extends StatefulWidget {
  const PhoneOtpAuthCard({super.key});

  @override
  State<PhoneOtpAuthCard> createState() => _PhoneOtpAuthCardState();
}

class _PhoneOtpAuthCardState extends State<PhoneOtpAuthCard> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();

  bool _submitted = false;
  bool _otpSent = false;
  int _countdown = 0;
  Timer? _timer;

  static const _sendColor = Color(0xFF1E3A8A);
  static const _resendColor = Color(0xFF5B73B4);
  static const _errorBorder = Color(0xFFFCA5A5);
  static const _focusBorder = Color(0xFF3B82F6);

  String? get _phoneError {
    if (!_submitted) return null;
    if (_phone.text.trim().isEmpty) return 'Phone number is required.';
    return null;
  }

  void _sendOtp() {
    setState(() => _submitted = true);
    if (_phoneError != null) return;
    setState(() {
      _otpSent = true;
      _countdown = 60;
    });
    _startCountdown();
    // TODO: trigger OTP send
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 1) {
        t.cancel();
        setState(() => _countdown = 0);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _verify() {
    // TODO: verify OTP
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hasError = _phoneError != null;

    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Phone label ──────────────────────────────────────────────
          const AuthFieldLabel('Phone Number'),

          // ── Country + phone row ──────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Static country selector
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: hasError ? _errorBorder : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🇱🇰', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Sri Lanka (+94)',
                      style: tt.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Phone number input
              Expanded(
                child: TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  onChanged: (_) { if (_submitted) setState(() {}); },
                  style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: '77XXXXXXX (no leading 0)',
                    hintStyle: tt.bodyMedium?.copyWith(color: AppColors.textHint),
                    errorText: _phoneError,
                    errorStyle: const TextStyle(color: Colors.red),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(
                          color: hasError ? _errorBorder : AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(
                          color: hasError ? _errorBorder : AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(
                        color: hasError ? _errorBorder : AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(color: _errorBorder),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide:
                          const BorderSide(color: _errorBorder, width: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── State 1: Send OTP button ─────────────────────────────────
          if (!_otpSent)
            FilledButton(
              onPressed: _sendOtp,
              style: FilledButton.styleFrom(
                backgroundColor: _sendColor,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: const Text(
                'Send OTP',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),

          // ── State 2: Resend countdown + OTP verify row ───────────────
          if (_otpSent) ...[
            FilledButton(
              onPressed: _countdown == 0 ? _sendOtp : null,
              style: FilledButton.styleFrom(
                backgroundColor:
                    _countdown == 0 ? _sendColor : _resendColor,
                disabledBackgroundColor: _resendColor,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                _countdown > 0 ? 'Resend in ${_countdown}s' : 'Resend OTP',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // OTP input + Verify button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _otp,
                    keyboardType: TextInputType.number,
                    style:
                        tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Enter OTP',
                      hintStyle: tt.bodyMedium
                          ?.copyWith(color: AppColors.textHint),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(
                            color: _focusBorder, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _verify,
                    style: FilledButton.styleFrom(
                      backgroundColor: _sendColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl),
                    ),
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
