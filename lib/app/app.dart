import 'package:bookmybus/features/BusOwner/dashboard/pages/operator_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import '../features/BusOwner/booking_history/pages/booking_history_page.dart';
import '../features/BusOwner/addbus/pages/add_bus_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMyBus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AddBusPage(),
    );
  }
}
