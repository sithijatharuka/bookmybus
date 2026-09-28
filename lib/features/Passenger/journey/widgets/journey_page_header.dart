import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class JourneyPageHeader extends StatelessWidget {
  const JourneyPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Find Your Perfect Journey',
            style: tt.titleLarge?.copyWith(color: AppColors.primary)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Search and book bus tickets across thousands of routes',
          style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
