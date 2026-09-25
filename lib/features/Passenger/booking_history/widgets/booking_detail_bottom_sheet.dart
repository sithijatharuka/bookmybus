import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/booking_history/models/passenger_booking_model.dart';
import 'package:bookmybus/features/Passenger/booking_history/widgets/booking_status_badge.dart';
import 'package:flutter/material.dart';

class BookingDetailBottomSheet extends StatelessWidget {
  const BookingDetailBottomSheet({super.key, required this.booking});

  final PassengerBookingModel booking;

  static void show(BuildContext context, PassengerBookingModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingDetailBottomSheet(booking: booking),
    );
  }

  String get _expiredAtLabel {
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
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: AppColors.scaffold,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title row
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.sm, AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Booking Details',
                      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.divider, height: 1),
            // Scrollable content
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(AppSpacing.lg),
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
                            style: tt.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      BookingStatusBadge(status: booking.status),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Section(
                    title: 'Passenger Details',
                    icon: Icons.person_outline,
                    children: [
                      _Row('Passenger Name', booking.passengerName.isNotEmpty ? booking.passengerName : '—'),
                      _Row('Account Phone', booking.passengerPhone.isNotEmpty ? booking.passengerPhone : '—'),
                      _Row('Contact No', booking.passengerPhone.isNotEmpty ? booking.passengerPhone : '—'),
                      const _Row('NIC / Passport', '—'),
                      const _Row('Email', '—'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Section(
                    title: 'Journey Details',
                    icon: Icons.route_outlined,
                    children: [
                      _Row('Route From', booking.from),
                      _Row('Route To', booking.to),
                      _Row('Pickup Point', booking.pickupPoint),
                      _Row('Drop Point', booking.dropPoint),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Section(
                    title: 'Payment Details',
                    icon: Icons.payment_outlined,
                    children: [
                      _Row('Payment Method', booking.paymentStatus),
                      _Row('Total', 'LKR ${booking.totalAmount.toStringAsFixed(2)}'),
                      _Row('Ticket Ref', booking.ticketRef.toUpperCase()),
                      _Row('Expired At', _expiredAtLabel),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
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
