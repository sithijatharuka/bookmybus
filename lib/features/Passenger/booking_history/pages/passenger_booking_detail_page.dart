import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/booking_history/models/passenger_booking_model.dart';
import 'package:bookmybus/features/Passenger/booking_history/widgets/booking_status_badge.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class PassengerBookingDetailPage extends StatelessWidget {
  const PassengerBookingDetailPage({super.key, required this.booking});

  final PassengerBookingModel booking;

  String get _travelDateLabel {
    final d = booking.travelDate;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String get _bookedAtLabel {
    final d = booking.bookedAt;
    final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final period = d.hour < 12 ? 'AM' : 'PM';
    final min = d.minute.toString().padLeft(2, '0');
    final sec = d.second.toString().padLeft(2, '0');
    return '${d.month}/${d.day}/${d.year}, $h:$min:$sec $period';
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Booking Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket ref + status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ticket Reference', style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    Text(
                      booking.ticketRef.toUpperCase(),
                      style: tt.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700, letterSpacing: 1),
                    ),
                  ],
                ),
                BookingStatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _Section(
              title: 'Journey Details',
              icon: Icons.route_outlined,
              children: [
                _Row('Route', booking.route),
                _Row('Travel Date', _travelDateLabel),
                _Row('Departure', booking.departureTime),
                _Row('Pickup', booking.pickupPoint),
                _Row('Drop', booking.dropPoint),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _Section(
              title: 'Bus Details',
              icon: Icons.directions_bus_outlined,
              children: [
                _Row('Bus Name', booking.busName),
                _Row('Bus Number', booking.busNumber),
                _Row('Bus Type', booking.busType),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _Section(
              title: 'Seat Details',
              icon: Icons.event_seat_outlined,
              children: [
                _Row('Selected Seats', booking.seatsLabel),
                ...booking.seatGenders.entries.map(
                  (e) => _Row('Seat ${e.key}', e.value),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _Section(
              title: 'Passenger Details',
              icon: Icons.person_outline,
              children: [
                _Row('Phone', booking.passengerPhone),
                if (booking.passengerName.isNotEmpty) _Row('Name', booking.passengerName),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _Section(
              title: 'Payment Details',
              icon: Icons.payment_outlined,
              children: [
                _Row('Total Amount', 'LKR ${booking.totalAmount.toStringAsFixed(2)}'),
                _Row('Payment Status', booking.paymentStatus),
                _Row('Booked At', _bookedAtLabel),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.icon, required this.children});
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.section,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodySmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
