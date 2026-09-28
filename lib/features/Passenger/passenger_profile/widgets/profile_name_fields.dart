import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ProfileNameFields extends StatelessWidget {
  const ProfileNameFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _NameField(
            label: 'First Name',
            controller: firstNameController,
            helperText: '2–50 letters; spaces and hyphens allowed',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _NameField(
            label: 'Last Name',
            controller: lastNameController,
            helperText: '2–50 letters; spaces and hyphens allowed',
          ),
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    required this.label,
    required this.controller,
    required this.helperText,
  });

  final String label;
  final TextEditingController controller;
  final String helperText;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            helperText: helperText,
            helperMaxLines: 2,
            helperStyle: tt.bodySmall?.copyWith(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
