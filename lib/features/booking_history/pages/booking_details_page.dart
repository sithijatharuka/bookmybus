import 'package:flutter/material.dart';
import '../../../shared/widgets/common_app_bar.dart';
import '../models/booking_history_model.dart';

class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({super.key, required this.booking});

  final BookingHistoryModel booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Booking Details'),
      body: const Center(
        child: Text('Booking Details — Coming Soon'),
      ),
    );
  }
}
