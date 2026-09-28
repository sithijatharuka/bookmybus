import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import 'widgets/phone_otp_auth_card.dart';

class PassengerLoginPage extends StatelessWidget {
  const PassengerLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hero Header ───────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + AppSpacing.xxxl,
                bottom: AppSpacing.huge,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEEF3FF), Color(0xFFE8ECF8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(                
                children: [
                  // Welcome To text
                  const Text(
                    'Welcome To',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Bus logo
                  SizedBox(
                    width: size.width * 0.7,
                    child: Image.asset(
                      'assets/images/bus-logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Sign in to book your next journey',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),

            // ── OTP Auth Card ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width >= 768
                    ? size.width * 0.15
                    : AppSpacing.lg,
                vertical: AppSpacing.xxxl,
              ),
              child: const PhoneOtpAuthCard(),
            ),
          ],
        ),
      ),
    );
  }
}
