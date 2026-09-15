import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import 'dashboard_metric_card.dart';
import 'filter_summary_card.dart';

class DashboardOverviewSection extends StatelessWidget {
  const DashboardOverviewSection({
    super.key,
    required this.filterLabel,
    required this.metrics,
  });

  final String filterLabel;
  final List<DashboardMetricModel> metrics;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FilterSummaryCard(),
          DashboardMetricsGrid(metrics: metrics, subtitle: filterLabel),
        ],
      ),
    );
  }
}
