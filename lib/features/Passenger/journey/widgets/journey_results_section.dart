import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:bookmybus/features/Passenger/journey/widgets/journey_bus_card.dart';
import 'package:bookmybus/features/Passenger/journey/widgets/journey_empty_results.dart';
import 'package:flutter/material.dart';

class JourneyResultsSection extends StatelessWidget {
  const JourneyResultsSection({
    super.key,
    required this.results,
    required this.isCleared,
    required this.from,
    required this.to,
    required this.date,
  });

  final List<JourneyBusModel> results;
  final bool isCleared;
  final String? from;
  final String? to;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Buses',
            style: tt.titleMedium?.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          isCleared
              ? 'Showing all available buses'
              : 'Showing results for your selected route and date',
          style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          results.isEmpty
              ? 'No buses found for this route'
              : 'Found ${results.length} ${results.length == 1 ? 'bus' : 'buses'} matching your search',
          style: tt.bodySmall?.copyWith(
            color: results.isEmpty ? AppColors.error : AppColors.success,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (results.isEmpty)
          JourneyEmptyResults(from: from!, to: to!)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: results.length,
            itemBuilder: (_, i) => JourneyBusCard(bus: results[i], date: date),
          ),
      ],
    );
  }
}
