import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/call_booking_model.dart';

class Step3PassengerPage extends StatefulWidget {
  const Step3PassengerPage({super.key, required this.booking, required this.onChanged});

  final CallBookingModel booking;
  final VoidCallback onChanged;

  @override
  State<Step3PassengerPage> createState() => _Step3PassengerPageState();
}

class _Step3PassengerPageState extends State<Step3PassengerPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _nicCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.booking.passengerName);
    _phoneCtrl = TextEditingController(text: widget.booking.passengerPhone);
    _nicCtrl = TextEditingController(text: widget.booking.passengerNic);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _nicCtrl.dispose();
    super.dispose();
  }

  void _sync() {
    widget.booking.passengerName = _nameCtrl.text.trim();
    widget.booking.passengerPhone = _phoneCtrl.text.trim();
    widget.booking.passengerNic = _nicCtrl.text.trim();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Booking summary ──────────────────────────────────
          _BookingSummaryBanner(booking: widget.booking),
          const SizedBox(height: AppSpacing.lg),

          // ── Passenger form ───────────────────────────────────
          Container(
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
                      const Icon(Icons.person_outline_rounded,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Passenger Details',
                        style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.divider, height: 1),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      _FormField(
                        label: 'Full Name',
                        hint: 'Enter passenger full name',
                        controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        onChanged: (_) => _sync(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _FormField(
                        label: 'Phone Number',
                        hint: 'Enter contact number',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        onChanged: (_) => _sync(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _FormField(
                        label: 'NIC (Optional)',
                        hint: 'Enter NIC number',
                        controller: _nicCtrl,
                        keyboardType: TextInputType.text,
                        onChanged: (_) => _sync(),
                      ),
                    ],
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

// ── Booking Summary Banner ────────────────────────────────────────────────────

class _BookingSummaryBanner extends StatelessWidget {
  const _BookingSummaryBanner({required this.booking});

  final CallBookingModel booking;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final trip = booking.selectedTrip!;
    final seats = booking.selectedSeats;
    final total = seats.length * trip.pricePerSeat;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.confirmation_number_outlined,
                  size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Booking Summary',
                style: tt.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(label: 'Bus', value: '${trip.busName} ${trip.busNumber}'),
          _SummaryRow(label: 'Route', value: trip.route),
          _SummaryRow(label: 'Date', value: _fmtDate(booking.travelDate!)),
          _SummaryRow(
            label: 'Seats',
            value: seats.map((s) => '$s').join(', '),
          ),
          _SummaryRow(
            label: 'Total',
            value: 'LKR ${total.toStringAsFixed(2)}',
            bold: true,
            valueColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: tt.bodySmall?.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Form Field ────────────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textHint),
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
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
          ),
        ),
      ],
    );
  }
}
