import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class Step4ReviewPage extends StatelessWidget {
  const Step4ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 4: Review', style: tt.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text('Review all the details before submitting your bus listing.', style: tt.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.construction_outlined, size: 48, color: AppColors.textHint),
                SizedBox(height: AppSpacing.md),
                Text('Review — coming soon', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
