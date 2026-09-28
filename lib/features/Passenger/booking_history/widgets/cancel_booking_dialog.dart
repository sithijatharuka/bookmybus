import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/booking_history/data/passenger_booking_store.dart';
import 'package:bookmybus/features/Passenger/booking_history/models/passenger_booking_model.dart';
import 'package:flutter/material.dart';

// Must match the constants used at checkout
const double _kPlatformFee = 100.0;
const double _kGatewayFeeRate = 0.031;

const _kReasons = [
  'Change of plans',
  'Illness / emergency',
  'Booked by mistake',
  'Found alternative transport',
  'Other',
];

class CancelBookingDialog extends StatefulWidget {
  const CancelBookingDialog({super.key, required this.booking});

  final PassengerBookingModel booking;

  static Future<void> show(BuildContext context, PassengerBookingModel booking) {
    return showDialog(
      context: context,
      builder: (_) => CancelBookingDialog(booking: booking),
    );
  }

  @override
  State<CancelBookingDialog> createState() => _CancelBookingDialogState();
}

class _CancelBookingDialogState extends State<CancelBookingDialog> {
  String? _reason;

  // Reverse-engineer seat price from stored totalAmount:
  // total = (subtotal + platformFee) * (1 + gatewayRate)
  // subtotal = total / (1 + gatewayRate) - platformFee
  double get _subtotal =>
      widget.booking.totalAmount / (1 + _kGatewayFeeRate) - _kPlatformFee;

  double get _pricePerSeat =>
      _subtotal / widget.booking.selectedSeats.length;

  double get _gatewayFee =>
      (_subtotal + _kPlatformFee) * _kGatewayFeeRate;

  double get _refund =>
      widget.booking.totalAmount - _gatewayFee - _kPlatformFee;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final seatCount = widget.booking.selectedSeats.length;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Text(
              'Cancel Booking',
              style: tt.titleLarge?.copyWith(
                color: const Color(0xFF0F172A),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Refund Breakdown Card ────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Paid Amount',
                    style: tt.bodySmall?.copyWith(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'LKR ${widget.booking.totalAmount.toStringAsFixed(2)}',
                    style: tt.titleMedium?.copyWith(
                      color: const Color(0xFF0F172A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  const SizedBox(height: AppSpacing.md),

                  // Seat price row
                  _BreakdownRow(
                    label:
                        'Seat price ($seatCount × LKR ${_pricePerSeat.toStringAsFixed(2)})',
                    amount: 'LKR ${_subtotal.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // PayHere fee row (red)
                  _BreakdownRow(
                    label:
                        'PayHere fee (${(_kGatewayFeeRate * 100).toStringAsFixed(2)}%)',
                    amount: '- LKR ${_gatewayFee.toStringAsFixed(2)}',
                    isDeduction: true,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Platform charge row (red)
                  _BreakdownRow(
                    label: 'Platform charge (flat fee)',
                    amount: '- LKR ${_kPlatformFee.toStringAsFixed(2)}',
                    isDeduction: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  const SizedBox(height: AppSpacing.md),

                  // Refund total
                  Text(
                    'Refund — instantly credited to wallet',
                    style: tt.bodySmall?.copyWith(
                      color: const Color(0xFF16A34A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'LKR ${_refund.toStringAsFixed(2)}',
                    style: tt.headlineSmall?.copyWith(
                      color: const Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Cancellation Reason ──────────────────────────────────────
            Text(
              'Reason for cancellation',
              style: tt.bodyMedium?.copyWith(
                color: const Color(0xFF0F172A),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                value: _reason,
                isExpanded: true,
                hint: const Text('Select a reason',
                    style: TextStyle(fontWeight: FontWeight.w400)),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                ),
                style: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF0F172A)),
                items: _kReasons
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setState(() => _reason = v),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // ── Action Buttons ───────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F172A),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: _reason == null
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            PassengerBookingStore.instance
                                .cancelBooking(widget.booking.ticketRef);
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      disabledBackgroundColor:
                          const Color(0xFFDC2626).withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: const Text(
                      'Confirm Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.amount,
    this.isDeduction = false,
  });

  final String label;
  final String amount;
  final bool isDeduction;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final color =
        isDeduction ? const Color(0xFFDC2626) : const Color(0xFF475569);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: tt.bodySmall?.copyWith(color: color),
          ),
        ),
        Text(
          amount,
          style: tt.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
