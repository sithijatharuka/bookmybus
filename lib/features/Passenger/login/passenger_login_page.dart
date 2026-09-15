import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import 'widgets/phone_otp_auth_card.dart';

class PassengerLoginPage extends StatelessWidget {
  const PassengerLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 768;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 0 : AppSpacing.lg,
            vertical: AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ───────────────────────────────────────────────
              Text('Welcome', style: tt.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Sign in to book your next journey',
                style: tt.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // ── OTP Auth Card ─────────────────────────────────────────
              const Center(child: PhoneOtpAuthCard()),
            ],
          ),
        ),
      ),
    );
  }
}
