import 'package:bookmybus/features/BusOwner/CallBooking/pages/call_booking_page.dart';
import 'package:bookmybus/features/BusOwner/addbus/pages/add_bus_page.dart';
import 'package:bookmybus/features/BusOwner/dashboard/pages/operator_dashboard_screen.dart';
import 'package:bookmybus/features/BusOwner/manage_bus/pages/manage_bus_page.dart';
import 'package:bookmybus/features/auth/login/login_page.dart';
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
