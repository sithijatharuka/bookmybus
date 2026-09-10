import 'package:bookmybus/features/BusOwner/dashboard/pages/operator_dashboard_screen.dart';
import 'package:bookmybus/features/Passenger/home/pages/passenger_home_page.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

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
