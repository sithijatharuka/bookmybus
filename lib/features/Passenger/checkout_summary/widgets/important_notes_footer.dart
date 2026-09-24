import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

const _kNotes = [
  'Arrive at the pickup point at least 15 minutes before departure.',
  'A valid government-issued ID must be presented for passenger verification.',
  'Full payment is required to confirm your booking. Unpaid bookings will be automatically released.',
  'Cancellations made within 24 hours of departure are non-refundable.',
];

class ImportantNotesFooter extends StatelessWidget {
  const ImportantNotesFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline,
                  size: 16, color: Color(0xFF92400E)),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Important Notes',
                style: tt.titleSmall?.copyWith(
                    color: const Color(0xFF92400E),
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ..._kNotes.map(
            (note) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.circle,
                        size: 5, color: Color(0xFF92400E)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      note,
                      style: tt.bodySmall?.copyWith(
                          color: const Color(0xFF92400E), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
