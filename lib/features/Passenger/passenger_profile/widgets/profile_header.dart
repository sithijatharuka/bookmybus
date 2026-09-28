import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'View / Update Your Profile',
          style: tt.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Manage your personal information and preferences.',
          style: tt.bodyMedium,
        ),
      ],
    );
  }
}
