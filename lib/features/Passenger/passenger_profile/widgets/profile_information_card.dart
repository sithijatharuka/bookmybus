import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/passenger_profile/widgets/profile_email_field.dart';
import 'package:bookmybus/features/Passenger/passenger_profile/widgets/profile_name_fields.dart';
import 'package:bookmybus/features/Passenger/passenger_profile/widgets/profile_national_id_field.dart';
import 'package:bookmybus/features/Passenger/passenger_profile/widgets/profile_phone_number_field.dart';
import 'package:flutter/material.dart';

class ProfileInformationCard extends StatelessWidget {
  const ProfileInformationCard({
    super.key,
    required this.phoneNumber,
    required this.firstNameController,
    required this.lastNameController,
    required this.nicController,
    required this.emailController,
  });

  final String phoneNumber;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController nicController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfilePhoneNumberField(phoneNumber: phoneNumber),
          const SizedBox(height: AppSpacing.lg),
          ProfileNameFields(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileNationalIdField(controller: nicController),
          const SizedBox(height: AppSpacing.lg),
          ProfileEmailField(controller: emailController),
        ],
      ),
    );
  }
}
