import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../data/dummy_dashboard_data.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_analytics_section.dart';
import '../widgets/dashboard_navigation.dart';
import '../widgets/dashboard_overview_section.dart';
import '../widgets/dashboard_top_lists_section.dart';

class OperatorDashboardScreen extends StatefulWidget {
  const OperatorDashboardScreen({super.key});

  @override
  State<OperatorDashboardScreen> createState() =>
      _OperatorDashboardScreenState();
}

class _OperatorDashboardScreenState extends State<OperatorDashboardScreen> {
  int _selectedFilter = 0;
  int _selectedNav = 0;

  @override
  Widget build(BuildContext context) {
    final filterLabel = DummyDashboardData.filters[_selectedFilter];

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: DashboardHeader(
                  greeting: 'Good Morning 👋',
                  operatorName: 'NCG Express',
                  totalRevenue: 'Rs 25,000.00',
                  onNotificationTap: () {},
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 36 + AppSpacing.lg),

                      DashboardOverviewSection(
                        filters: DummyDashboardData.filters,
                        selectedFilter: _selectedFilter,
                        filterLabel: filterLabel,
                        metrics: DummyDashboardData.metrics,
                        onFilterSelected: (i) =>
                            setState(() => _selectedFilter = i),
                      ),
                      DashboardAnalyticsSection(
                        bookingsTrend: DummyDashboardData.bookingsTrend,
                        revenueTrend: DummyDashboardData.revenueTrend,
                      ),
                      DashboardTopListsSection(
                        topRoutes: DummyDashboardData.topRoutes,
                        topBuses: DummyDashboardData.topBuses,
                        cancelledRoutes: DummyDashboardData.cancelledRoutes,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const DashboardFilterButton(),
        ],
      ),
      bottomNavigationBar: DashboardNavigation(
        selectedIndex: _selectedNav,
        onSelected: (i) => setState(() => _selectedNav = i),
      ),
    );
  }
}
