import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/booking_section_card.dart';
import 'package:flutter/material.dart';

const double _kPlatformFee = 100.0;
const double _kGatewayFeeRate = 0.031;

class PaymentSummaryCard extends StatefulWidget {
  const PaymentSummaryCard({
    super.key,
    required this.ticketPrice,
    required this.seatCount,
    this.onConfirm,
    this.onCancel,
  });

  final double ticketPrice;
  final int seatCount;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  State<PaymentSummaryCard> createState() => _PaymentSummaryCardState();
}

class _PaymentSummaryCardState extends State<PaymentSummaryCard> {
  bool _useWallet = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final subtotal = widget.ticketPrice * widget.seatCount;
    final gatewayFee = (subtotal + _kPlatformFee) * _kGatewayFeeRate;
    final total = subtotal + _kPlatformFee + gatewayFee;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BookingCardHeader(
            icon: Icons.payment_outlined,
            title: 'Payment Summary',
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.lg),

          // ── Wallet toggle ──────────────────────────────────────────────
          _PaymentOption(
            label: 'Use wallet balance',
            selected: _useWallet,
            onTap: () => setState(() => _useWallet = true),
          ),
          const SizedBox(height: AppSpacing.sm),
          _PaymentOption(
            label: 'Pay full amount via PayHere',
            selected: !_useWallet,
            onTap: () => setState(() => _useWallet = false),
          ),
          const SizedBox(height: AppSpacing.md),
          _AmountSummaryRow(
            walletUsed: 0.0,
            payhereAmount: total,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.lg),

          // ── Price breakdown ────────────────────────────────────────────
          _PriceRow(
            label: 'Ticket Price',
            value:
                '${widget.seatCount} × LKR ${widget.ticketPrice.toStringAsFixed(2)}',
          ),
          const SizedBox(height: AppSpacing.sm),
          _PriceRow(
            label: 'Platform Fee',
            value: 'LKR ${_kPlatformFee.toStringAsFixed(2)}',
          ),
          const SizedBox(height: AppSpacing.sm),
          _PriceRow(
            label: 'Payment Gateway Fee',
            value:
                '${(_kGatewayFeeRate * 100).toStringAsFixed(1)}% = LKR ${gatewayFee.toStringAsFixed(2)}',
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.lg),

          // ── Total ──────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: tt.titleSmall?.copyWith(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w700),
              ),
              Text(
                'LKR ${total.toStringAsFixed(2)}',
                style: tt.titleMedium?.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Action buttons ─────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onConfirm,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: const Text(
                'Cancel Booking',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 18,
              color: selected ? AppColors.primary : AppColors.textHint,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountSummaryRow extends StatelessWidget {
  const _AmountSummaryRow({
    required this.walletUsed,
    required this.payhereAmount,
  });

  final double walletUsed;
  final double payhereAmount;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _AmountBox(
              label: 'Wallet Used',
              amount: 'LKR ${walletUsed.toStringAsFixed(2)}',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _AmountBox(
              label: 'PayHere Amount',
              amount: 'LKR ${payhereAmount.toStringAsFixed(2)}',
              highlight: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountBox extends StatelessWidget {
  const _AmountBox({
    required this.label,
    required this.amount,
    this.highlight = false,
  });

  final String label;
  final String amount;
  final bool highlight;

  Color get _bgColor => highlight
      ? AppColors.primary.withValues(alpha: 0.05)
      : AppColors.section;

  Color get _borderColor => highlight
      ? AppColors.primary.withValues(alpha: 0.2)
      : AppColors.border;

  Color get _amountColor =>
      highlight ? AppColors.primary : AppColors.textPrimary;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xs),
          Text(amount,
              style: tt.bodyMedium?.copyWith(
                  color: _amountColor, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
        Text(value,
            style: tt.bodySmall?.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
