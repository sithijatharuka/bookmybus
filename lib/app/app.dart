import 'package:bookmybus/features/dashboard/pages/operator_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import '../features/booking_history/pages/booking_history_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMyBus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const OperatorDashboardScreen(),
    );
  }
}
