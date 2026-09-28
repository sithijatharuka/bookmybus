import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class JourneyEmptyResults extends StatelessWidget {
  const JourneyEmptyResults({super.key, required this.from, required this.to});

  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 48, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.md),
          Text('No buses available',
              style: tt.titleSmall?.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'No buses found from $from to $to.\nTry a different route or date.',
            style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
