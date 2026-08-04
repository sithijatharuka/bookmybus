import 'package:flutter/material.dart';
import '../../../app/theme/app_spacing.dart';
import 'image_drop_zone.dart';
import 'image_preview_card.dart';
import 'upload_progress_bar.dart';

class Step1UploadImagesView extends StatelessWidget {
  const Step1UploadImagesView({super.key});

  static const _images = [
    (label: 'Exterior Front', icon: Icons.directions_bus_outlined),
    (label: 'Interior', icon: Icons.airline_seat_recline_normal_outlined),
    (label: 'Air Conditioned Bus', icon: Icons.ac_unit_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          Text('Step 1: Upload Bus Images', style: tt.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Upload exterior and interior images of your bus for passengers to preview.',
            style: tt.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Drag & Drop Area ─────────────────────────────────
          const ImageDropZone(),
          const SizedBox(height: AppSpacing.xxl),

          // ── Preview Gallery Header ───────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Preview Gallery', style: tt.titleMedium),
              _CountBadge(count: _images.length),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Image Cards ──────────────────────────────────────
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (_, i) => ImagePreviewCard(
              label: _images[i].label,
              icon: _images[i].icon,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // ── Upload Progress ──────────────────────────────────
          const UploadProgressBar(
            fileName: 'bus_exterior.jpg',
            progress: 0.75,
          ),
        ],
      ),
    );
  }
}

// ── Count Badge ───────────────────────────────────────────────────────────────

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count images selected',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF3557A8),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
      ),
    );
  }
}
