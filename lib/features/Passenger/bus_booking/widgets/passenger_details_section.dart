import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/booking_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PassengerDetailsSection extends StatelessWidget {
  const PassengerDetailsSection({
    super.key,
    required this.phoneController,
    required this.otpSent,
    required this.onSendOtp,
  });

  final TextEditingController phoneController;
  final bool otpSent;
  final VoidCallback onSendOtp;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section title ──────────────────────────────────────────────────
        Text('Passenger Details',
            style: tt.titleMedium?.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Enter traveller information, contact number, and route details to continue.',
          style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),

        // ── Phone Verification card ────────────────────────────────────────
        BookingSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BookingCardHeader(
                icon: Icons.phone_android,
                title: 'Phone Verification',
              ),
              const SizedBox(height: AppSpacing.lg),

              // Country field
              const BookingFieldLabel(label: 'Country'),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.section,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Text('🇱🇰', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Sri Lanka (+94)',
                        style: tt.bodyMedium
                            ?.copyWith(color: AppColors.textPrimary)),
                    const Spacer(),
                    const Icon(Icons.lock_outline,
                        size: 16, color: AppColors.textHint),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Phone number field
              const BookingFieldLabel(label: 'Phone Number'),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  // Country code badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.section,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text('+94',
                        style: tt.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9),
                      ],
                      style: tt.bodyMedium
                          ?.copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: '77XXXXXXX',
                        hintStyle: tt.bodyMedium
                            ?.copyWith(color: AppColors.textHint),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.md),
                        filled: true,
                        fillColor: AppColors.white,
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
                              color: AppColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Send OTP button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onSendOtp,
                  icon: Icon(
                    otpSent ? Icons.check_circle : Icons.send,
                    size: 16,
                  ),
                  label: Text(otpSent ? 'OTP Sent' : 'Send OTP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        otpSent ? AppColors.success : AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              const BookingInfoBanner(
                icon: Icons.info_outline,
                text:
                    'By default, we use your registered account details. You can also save passenger profiles (e.g. Father, Friend) or change the traveller\'s contact number below.',
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Passenger Profiles card ────────────────────────────────────────
        BookingSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BookingCardHeader(
                icon: Icons.people_outline,
                title: 'Passenger Profiles',
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Save frequent travellers (e.g. Me, Father, Friend) to quickly fill details for future bookings. You can still book without saving.',
                style:
                    tt.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),

              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Passenger Details'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md, horizontal: AppSpacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              const BookingInfoBanner(
                icon: Icons.lightbulb_outline,
                text:
                    'You can save passenger profiles after verifying your phone number above. For now, continue with the Passenger Details form.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
