import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ProfileHelpSupport extends StatelessWidget {
  const ProfileHelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Need help? Visit our ',
          style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text(
                'Help & Support',
                style: tt.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.open_in_new, size: 13, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }
}
