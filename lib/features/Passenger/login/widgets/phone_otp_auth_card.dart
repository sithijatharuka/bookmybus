import 'dart:async';

import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/auth/login/widgets/auth_form_field.dart';
import 'package:flutter/material.dart';

class _Country {
  const _Country(this.name, this.flag, this.code);
  final String name;
  final String flag;
  final String code;
}

const _countries = [
  _Country('Sri Lanka', '🇱🇰', '+94'),
  _Country('India', '🇮🇳', '+91'),
  _Country('United Kingdom', '🇬🇧', '+44'),
  _Country('United States', '🇺🇸', '+1'),
  _Country('Australia', '🇦🇺', '+61'),
  _Country('Canada', '🇨🇦', '+1'),
  _Country('Singapore', '🇸🇬', '+65'),
  _Country('Malaysia', '🇲🇾', '+60'),
  _Country('United Arab Emirates', '🇦🇪', '+971'),
];

class PhoneOtpAuthCard extends StatefulWidget {
  const PhoneOtpAuthCard({super.key});

  @override
  State<PhoneOtpAuthCard> createState() => _PhoneOtpAuthCardState();
}

class _PhoneOtpAuthCardState extends State<PhoneOtpAuthCard> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();

  _Country _selectedCountry = _countries.first; // Sri Lanka default
  bool _submitted = false;
  bool _otpSent = false;
  int _countdown = 0;
  Timer? _timer;

  static const _sendColor = Color(0xFF1E3A8A);
  static const _resendColor = Color(0xFF5B73B4);
  static const _errorBorder = Color(0xFFFCA5A5);
  static const _fillColor = Color(0xFFF8FAFC);

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

  OutlineInputBorder _border(Color color, {double width = 1.0}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: color, width: width),
      );

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
          // ── Section title ────────────────────────────────────────────
          Text(
            'Passenger Login',
            style: tt.titleMedium?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Enter your mobile number to continue',
            style: tt.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xxl),

          // ── Country dropdown ─────────────────────────────────────────
          const AuthFieldLabel('Country'),
          Container(
            decoration: BoxDecoration(
              color: _fillColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<_Country>(
                value: _selectedCountry,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary),
                style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
                dropdownColor: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                items: _countries
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Text(c.flag,
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                '${c.name}  (${c.code})',
                                style: tt.bodyMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (c) {
                  if (c != null) setState(() => _selectedCountry = c);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Phone number input ───────────────────────────────────────
          const AuthFieldLabel('Phone Number'),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            onChanged: (_) {
              if (_submitted) setState(() {});
            },
            style: tt.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your phone number',
              hintStyle: tt.bodyMedium?.copyWith(color: AppColors.textHint),
              errorText: _phoneError,
              errorStyle: const TextStyle(color: AppColors.error),
              filled: true,
              fillColor: _fillColor,
              prefixIcon: Container(
                margin: const EdgeInsets.only(
                    left: AppSpacing.md, right: AppSpacing.sm),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.section,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  _selectedCountry.code,
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              border: _border(hasError ? _errorBorder : AppColors.border),
              enabledBorder:
                  _border(hasError ? _errorBorder : AppColors.border),
              focusedBorder: _border(
                  hasError ? _errorBorder : AppColors.primary,
                  width: 1.5),
              errorBorder: _border(_errorBorder),
              focusedErrorBorder: _border(_errorBorder, width: 1.5),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── State 1: Send OTP button ─────────────────────────────────
          if (!_otpSent)
            FilledButton(
              onPressed: _sendOtp,
              style: FilledButton.styleFrom(
                backgroundColor: _sendColor,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.lg),
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
                    const EdgeInsets.symmetric(vertical: AppSpacing.lg),
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
                    style: tt.bodyLarge
                        ?.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Enter OTP',
                      hintStyle: tt.bodyMedium
                          ?.copyWith(color: AppColors.textHint),
                      filled: true,
                      fillColor: _fillColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.lg,
                      ),
                      border: _border(AppColors.border),
                      enabledBorder: _border(AppColors.border),
                      focusedBorder:
                          _border(AppColors.info, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  height: 56,
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
