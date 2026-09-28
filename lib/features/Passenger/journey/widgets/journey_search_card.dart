import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/journey/widgets/journey_search_fields.dart';
import 'package:flutter/material.dart';

class JourneySearchCard extends StatelessWidget {
  const JourneySearchCard({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.onFromTap,
    required this.onToTap,
    required this.onDateTap,
    required this.onClearFrom,
    required this.onClearTo,
    required this.onClearSearch,
  });

  final String? from;
  final String? to;
  final DateTime date;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final VoidCallback onDateTap;
  final VoidCallback? onClearFrom;
  final VoidCallback? onClearTo;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          JourneySearchField(
            label: 'From',
            value: from,
            icon: Icons.trip_origin,
            iconColor: AppColors.primary,
            onTap: onFromTap,
            onClear: onClearFrom,
          ),
          const SizedBox(height: AppSpacing.md),
          JourneySearchField(
            label: 'To',
            value: to,
            icon: Icons.location_on,
            iconColor: AppColors.error,
            onTap: onToTap,
            onClear: onClearTo,
          ),
          const SizedBox(height: AppSpacing.md),
          JourneyDateField(date: date, onTap: onDateTap),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onClearSearch,
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Clear Search'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
