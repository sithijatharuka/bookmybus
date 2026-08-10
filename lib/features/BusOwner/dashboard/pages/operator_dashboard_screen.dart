import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../data/dummy_dashboard_data.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_list_cards.dart';
import '../widgets/dashboard_metric_card.dart';
import '../widgets/analytics_filter_bottom_sheet.dart';
import '../widgets/filter_summary_card.dart';

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

                      // 1. Date filter pills
                      DashboardFilterPills(
                        filters: DummyDashboardData.filters,
                        selectedIndex: _selectedFilter,
                        onSelect: (i) =>
                            setState(() => _selectedFilter = i),
                      ),
                      // const SizedBox(height: AppSpacing.sm),

                      // 2. Filter summary
                      const FilterSummaryCard(),
                      // const SizedBox(height: AppSpacing.md),

                      // 3. Metrics grid
                      DashboardMetricsGrid(
                        metrics: DummyDashboardData.metrics,
                        subtitle: filterLabel,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // 3. Trend charts
                      DashboardTrendCard(
                        title: 'Bookings Trend',
                        trend: DummyDashboardData.bookingsTrend,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DashboardTrendCard(
                        title: 'Revenue Trend',
                        trend: DummyDashboardData.revenueTrend,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // 4. Top lists
                      DashboardTopRoutesCard(
                          routes: DummyDashboardData.topRoutes),
                      const SizedBox(height: AppSpacing.md),
                      DashboardTopBusesCard(
                          buses: DummyDashboardData.topBuses),
                      const SizedBox(height: AppSpacing.md),
                      DashboardCancelledRoutesCard(
                          routes: DummyDashboardData.cancelledRoutes),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // FAB above bottom nav
          Positioned(
            bottom: 70,
            right: AppSpacing.lg,
            child: FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const FilterBottomSheet(),
              ),            
              child: const Icon(Icons.tune, color: AppColors.white),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedNav,
      //   onTap: (i) => setState(() => _selectedNav = i),
      //   selectedItemColor: AppColors.primary,
      //   unselectedItemColor: AppColors.textSecondary,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: AppColors.white,
      //   elevation: 12,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.dashboard_outlined),
      //       activeIcon: Icon(Icons.dashboard),
      //       label: 'Dashboard',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add_circle_outline),
      //       activeIcon: Icon(Icons.add_circle),
      //       label: 'Add',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.directions_bus_outlined),
      //       activeIcon: Icon(Icons.directions_bus),
      //       label: 'Buses',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.headset_mic_outlined),
      //       activeIcon: Icon(Icons.headset_mic),
      //       label: 'Support',
      //     ),
      //   ],
      // ),
    );
  }
}
