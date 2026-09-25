import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/booking_history/data/passenger_booking_store.dart';
import 'package:bookmybus/features/Passenger/booking_history/models/passenger_booking_model.dart';
import 'package:bookmybus/features/Passenger/booking_history/pages/passenger_booking_detail_page.dart';
import 'package:bookmybus/features/Passenger/booking_history/widgets/booking_history_filters.dart';
import 'package:bookmybus/features/Passenger/booking_history/widgets/booking_history_header.dart';
import 'package:bookmybus/features/Passenger/booking_history/widgets/booking_history_list.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class PassengerBookingHistoryPage extends StatefulWidget {
  const PassengerBookingHistoryPage({super.key});

  @override
  State<PassengerBookingHistoryPage> createState() => _PassengerBookingHistoryPageState();
}

class _PassengerBookingHistoryPageState extends State<PassengerBookingHistoryPage> {
  DateTime? _selectedDate;
  String _selectedStatus = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    PassengerBookingStore.instance.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    PassengerBookingStore.instance.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() => setState(() {});

  List<PassengerBookingModel> get _filtered {
    return PassengerBookingStore.instance.bookings.where((b) {
      // Date filter
      if (_selectedDate != null) {
        final d = _selectedDate!;
        if (b.travelDate.year != d.year ||
            b.travelDate.month != d.month ||
            b.travelDate.day != d.day) {
          return false;
        }
      }
      // Status filter
      if (_selectedStatus != 'All') {
        final match = switch (_selectedStatus) {
          'Pending' => PassengerBookingStatus.pending,
          'Confirmed' => PassengerBookingStatus.confirmed,
          'Cancelled' => PassengerBookingStatus.cancelled,
          _ => null,
        };
        if (match != null && b.status != match) {
          return false;
        }
      }
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final searchable = [
          b.route, b.busName, b.busNumber, b.pickupPoint,
          b.dropPoint, b.passengerName, b.passengerPhone, b.ticketRef,
        ].join(' ').toLowerCase();
        if (!searchable.contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final total = PassengerBookingStore.instance.bookings.length;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Booking History'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingHistoryHeader(totalCount: total),
            const SizedBox(height: AppSpacing.lg),
            BookingHistoryFilters(
              selectedDate: _selectedDate,
              selectedStatus: _selectedStatus,
              searchQuery: _searchQuery,
              onDateChanged: (d) => setState(() => _selectedDate = d),
              onStatusChanged: (s) => setState(() => _selectedStatus = s),
              onSearchChanged: (q) => setState(() => _searchQuery = q),
            ),
            const SizedBox(height: AppSpacing.lg),
            BookingHistoryList(
              bookings: filtered,
              onViewBooking: (b) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PassengerBookingDetailPage(booking: b)),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
