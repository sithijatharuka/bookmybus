import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/booking_section_card.dart';
import 'package:flutter/material.dart';

class PassengerDetailsCard extends StatelessWidget {
  const PassengerDetailsCard({
    super.key,
    required this.accountPhone,
    this.fullName,
    this.travellerContact,
    this.nicPassport,
    this.email,
  });

  final String accountPhone;
  final String? fullName;
  final String? travellerContact;
  final String? nicPassport;
  final String? email;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BookingCardHeader(
            icon: Icons.person_outline,
            title: 'Passenger Details',
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.lg),
          _DetailRow(
            label: 'Full Name',
            value: fullName,
            placeholder: 'Not provided',
          ),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(label: 'Account Phone', value: accountPhone),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
            label: 'Traveller Contact No',
            value: travellerContact,
            placeholder: 'Not provided',
          ),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
            label: 'NIC / Passport',
            value: nicPassport,
            placeholder: 'Not provided',
          ),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
            label: 'Email Address',
            value: email,
            placeholder: 'Not provided',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    this.value,
    this.placeholder = '—',
  });

  final String label;
  final String? value;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hasValue = value != null && value!.isNotEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 148,
          child: Text(
            label,
            style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            hasValue ? value! : placeholder,
            style: tt.bodySmall?.copyWith(
              color: hasValue ? AppColors.textPrimary : AppColors.textHint,
              fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
