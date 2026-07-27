import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/common_app_bar.dart';
import '../data/dummy_booking_history.dart';
import '../models/booking_history_model.dart';
import '../widgets/booking_cards.dart';
import '../widgets/booking_history_card.dart';
import '../widgets/bus_seat_layout_view.dart';
import 'booking_details_page.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  // View Booking Card state
  String _viewBus = 'All Buses';
  DateTime _viewDate = DateTime(2026, 7, 21);

  // Booking Overview Card state
  String _overviewBus = 'All Buses';
  String _overviewRoute = 'All Routes';
  String _overviewStatus = 'All Bookings';
  DateTime _overviewDate = DateTime(2026, 7, 21);
  DateTime? _fromDate;
  DateTime? _toDate;

  List<BookingHistoryModel> _results = DummyBookingHistory.bookings;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _fmtDisplay(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  void _onView() {
    final filtered = _applyFilters(bus: _viewBus, date: _viewDate);
    setState(() => _results = filtered);
    BusSeatLayoutView.show(
      context,
      busNumber: _viewBus == 'All Buses' ? 'All Buses' : _viewBus,
      travelDate: _fmtDisplay(_viewDate),
      bookings: filtered,
    );
  }

  void _onOverviewFilterChanged() {
    setState(() => _results = _applyFilters(
          bus: _overviewBus,
          route: _overviewRoute,
          status: _overviewStatus,
          date: _overviewDate,
          from: _fromDate,
          to: _toDate,
        ));
  }

  void _onClearFilters() {
    setState(() {
      _overviewBus = 'All Buses';
      _overviewRoute = 'All Routes';
      _overviewStatus = 'All Bookings';
      _overviewDate = DateTime(2026, 7, 21);
      _fromDate = null;
      _toDate = null;
      _results = DummyBookingHistory.bookings;
    });
  }

  List<BookingHistoryModel> _applyFilters({
    String bus = 'All Buses',
    String route = 'All Routes',
    String status = 'All Bookings',
    DateTime? date,
    DateTime? from,
    DateTime? to,
  }) {
    return DummyBookingHistory.bookings.where((b) {
      if (bus != 'All Buses' && b.busNumber != bus) return false;
      if (route != 'All Routes' && b.route != route) return false;
      if (status == 'Confirmed Only' && b.status != 'confirmed') return false;
      if (status == 'Cancelled Only' && b.status != 'cancelled') return false;
      if (date != null) {
        final d = _fmtDisplay(date);
        if (b.travelDate != d) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Booking History'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header
            _Header(),
            const SizedBox(height: AppSpacing.lg),

            // 2. View Booking Card
            ViewBookingCard(
              selectedBus: _viewBus,
              selectedDate: _viewDate,
              onBusChanged: (v) => setState(() => _viewBus = v),
              onDateChanged: (v) => setState(() => _viewDate = v ?? _viewDate),
              onView: _onView,
            ),
            const SizedBox(height: AppSpacing.lg),

            // 3. Booking Overview Card
            BookingOverviewCard(
              selectedBus: _overviewBus,
              selectedRoute: _overviewRoute,
              selectedStatus: _overviewStatus,
              selectedDate: _overviewDate,
              fromDate: _fromDate,
              toDate: _toDate,
              onBusChanged: (v) {
                setState(() => _overviewBus = v);
                _onOverviewFilterChanged();
              },
              onRouteChanged: (v) {
                setState(() => _overviewRoute = v);
                _onOverviewFilterChanged();
              },
              onStatusChanged: (v) {
                setState(() => _overviewStatus = v);
                _onOverviewFilterChanged();
              },
              onDateChanged: (v) {
                setState(() => _overviewDate = v ?? _overviewDate);
                _onOverviewFilterChanged();
              },
              onFromDateChanged: (v) {
                setState(() => _fromDate = v);
                _onOverviewFilterChanged();
              },
              onToDateChanged: (v) {
                setState(() => _toDate = v);
                _onOverviewFilterChanged();
              },
              onClearFilters: _onClearFilters,
            ),
            const SizedBox(height: AppSpacing.lg),

            // 4. Selected Filter Summary
            _FilterSummary(
              bus: _overviewBus,
              route: _overviewRoute,
              status: _overviewStatus,
              date: _fmt(_overviewDate),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 5. Booking Count + Export
            _BookingCountBar(
              count: _results.length,
              onExport: _results.isEmpty ? null : () {},
            ),
            
            const SizedBox(height: AppSpacing.lg),

            // 6. Booking History List
            if (_results.isEmpty)
              _EmptyState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _results.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, i) => BookingHistoryCard(
                  booking: _results[i],
                  onViewBooking: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingDetailsPage(booking: _results[i]),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lion Super Line', style: tt.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
        Text('Booking History', style: tt.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Review, filter, and export your booking history.',
          style: tt.bodyMedium,
        ),
      ],
    );
  }
}

// ─── Filter Summary ───────────────────────────────────────────────────────────

class _FilterSummary extends StatelessWidget {
  const _FilterSummary({
    required this.bus,
    required this.route,
    required this.status,
    required this.date,
  });

  final String bus;
  final String route;
  final String status;
  final String date;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Filters',
            style: tt.labelLarge?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(label: 'Bus', value: bus),
          _SummaryRow(label: 'Route', value: route),
          _SummaryRow(label: 'Status', value: status),
          _SummaryRow(label: 'Date', value: date),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primary)),
          Text(
            '$label: ',
            style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(value, style: tt.bodyMedium),
        ],
      ),
    );
  }
}

// ─── Booking Count Bar ───────────────────────────────────────────────────────

class _BookingCountBar extends StatelessWidget {
  const _BookingCountBar({required this.count, required this.onExport});

  final int count;
  final VoidCallback? onExport;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hasBookings = count > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$count ${count == 1 ? 'Booking' : 'Bookings'}',
          style: tt.titleMedium,
        ),
        OutlinedButton.icon(
          onPressed: onExport,
          icon: Icon(
            Icons.download_outlined,
            size: 18,
            color: hasBookings ? AppColors.primary : AppColors.textDisabled,
          ),
          label: Text('Export'),
          style: OutlinedButton.styleFrom(
            foregroundColor:
                hasBookings ? AppColors.primary : AppColors.textDisabled,
            side: BorderSide(
              color: hasBookings ? AppColors.primary : AppColors.textDisabled,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.huge),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No bookings found for the selected filters.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
