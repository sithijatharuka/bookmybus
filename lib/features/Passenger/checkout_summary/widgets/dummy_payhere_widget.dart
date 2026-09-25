import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class DummyPayhereWidget extends StatelessWidget {
  const DummyPayhereWidget({
    super.key,
    required this.ticketRef,
    required this.totalAmount,
    required this.route,
    required this.travelDate,
    required this.seatCount,
    required this.passengerName,
    required this.passengerPhone,
  });

  final String ticketRef;
  final double totalAmount;
  final String route;
  final DateTime travelDate;
  final int seatCount;
  final String passengerName;
  final String passengerPhone;

  static void show(
    BuildContext context, {
    required String ticketRef,
    required double totalAmount,
    required String route,
    required DateTime travelDate,
    required int seatCount,
    required String passengerName,
    required String passengerPhone,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DummyPayhereWidget(
        ticketRef: ticketRef,
        totalAmount: totalAmount,
        route: route,
        travelDate: travelDate,
        seatCount: seatCount,
        passengerName: passengerName,
        passengerPhone: passengerPhone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, AppSpacing.xxxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // PayHere logo area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFF0A2E6E),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.payment, color: Colors.white, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'PayHere',
                  style: tt.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: Text(
              'DEMO MODE — Payment not processed',
              style: tt.bodySmall?.copyWith(
                color: const Color(0xFFB45309),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Order details
          _OrderRow(label: 'Order ID', value: ticketRef),
          const SizedBox(height: AppSpacing.md),
          _OrderRow(label: 'Route', value: route),
          const SizedBox(height: AppSpacing.md),
          _OrderRow(
            label: 'Travel Date',
            value: '${travelDate.year}-${travelDate.month.toString().padLeft(2, '0')}-${travelDate.day.toString().padLeft(2, '0')}',
          ),
          const SizedBox(height: AppSpacing.md),
          _OrderRow(label: 'Seats', value: '$seatCount ${seatCount == 1 ? 'seat' : 'seats'}'),
          const SizedBox(height: AppSpacing.md),
          _OrderRow(label: 'Customer', value: passengerName.isNotEmpty ? passengerName : passengerPhone),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.divider),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Text(
                'LKR ${totalAmount.toStringAsFixed(2)}',
                style: tt.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Info note
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.info),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Your booking is saved as Pending. Complete payment to confirm your seats.',
                    style: tt.bodySmall?.copyWith(color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Close button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
        Text(value, style: tt.bodySmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
