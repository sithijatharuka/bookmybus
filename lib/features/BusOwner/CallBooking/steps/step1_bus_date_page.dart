import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/data/call_booking_dummy_data.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/models/call_booking_model.dart';
import 'package:flutter/material.dart';

class Step1BusDatePage extends StatefulWidget {
  const Step1BusDatePage({super.key, required this.booking, required this.onChanged});

  final CallBookingModel booking;
  final VoidCallback onChanged;

  @override
  State<Step1BusDatePage> createState() => _Step1BusDatePageState();
}

class _Step1BusDatePageState extends State<Step1BusDatePage> {
  final _searchController = TextEditingController();
  List<CallBusTripModel> _filtered = CallBookingDummyData.trips;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _fmtDate(DateTime d) =>
      '${(d.month).toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  void _onSearch(String q) {
    final lower = q.toLowerCase();
    setState(() {
      _filtered = CallBookingDummyData.trips.where((t) {
        return t.busName.toLowerCase().contains(lower) ||
            t.busNumber.toLowerCase().contains(lower) ||
            t.route.toLowerCase().contains(lower);
      }).toList();
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.booking.travelDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      widget.booking.travelDate = picked;
      widget.onChanged();
    }
  }

  void _selectTrip(CallBusTripModel trip) {
    setState(() => widget.booking.selectedTrip = trip);
    widget.onChanged();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final date = widget.booking.travelDate;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Travel Date ──────────────────────────────────────
          _SectionCard(
            title: 'Travel Date',
            icon: Icons.calendar_today_outlined,
            child: GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date != null ? _fmtDate(date) : 'MM/DD/YYYY',
                      style: tt.bodyLarge?.copyWith(
                        color: date != null ? AppColors.textPrimary : AppColors.textHint,
                      ),
                    ),
                    const Icon(Icons.calendar_today_outlined,
                        size: 18, color: AppColors.textHint),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Select Bus ───────────────────────────────────────
          _SectionCard(
            title: 'Select Bus',
            icon: Icons.directions_bus_outlined,
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search by name, number or route...',
                    hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded,
                        size: 20, color: AppColors.textHint),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Bus cards
                if (_filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Center(
                      child: Text(
                        'No buses found.',
                        style: tt.bodyMedium?.copyWith(color: AppColors.textHint),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (_, i) => _BusTripCard(
                      trip: _filtered[i],
                      isSelected:
                          widget.booking.selectedTrip == _filtered[i],
                      onTap: () => _selectTrip(_filtered[i]),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }
}

// ── Bus Trip Card ─────────────────────────────────────────────────────────────

class _BusTripCard extends StatelessWidget {
  const _BusTripCard({
    required this.trip,
    required this.isSelected,
    required this.onTap,
  });

  final CallBusTripModel trip;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.section : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? AppShadows.card : null,
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: bus info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bus name + number
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${trip.busName} ${trip.busNumber}',
                          style: tt.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Departure time
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        trip.departureTime,
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Route
                  Row(
                    children: [
                      Text(
                        trip.from,
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.arrow_forward_rounded,
                            size: 12, color: AppColors.primary),
                      ),
                      Text(
                        trip.to,
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Right: price + seats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'LKR ${trip.pricePerSeat.toStringAsFixed(0)} / seat',
                  style: tt.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                  child: Text(
                    '${trip.seatsLeft} seats left',
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const Icon(Icons.check_circle_rounded,
                      size: 18, color: AppColors.primary),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section Card ──────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ],
      ),
    );
  }
}
