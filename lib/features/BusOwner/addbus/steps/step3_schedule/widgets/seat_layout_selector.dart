import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'seat_layout_card.dart';

const seatLayouts = [
  '2 + 2 (51 seats)',
  '2 + 2 (49 seats)',
  '2 + 2 (45 seats)',
  '2 + 2 (39 seats)',
  '2 + 1 (40 seats)',
  '1 + 1 (30 seats)',
];

class SeatLayoutSelector extends StatelessWidget {
  const SeatLayoutSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String? selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...seatLayouts.map(
          (layout) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: SeatLayoutCard(
              label: layout,
              selected: selected == layout,
              onTap: () => onChanged(layout),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            const Icon(Icons.info_outline_rounded,
                size: 14, color: AppColors.textHint),
            const SizedBox(width: AppSpacing.xs),
            Text(
              "Seat count must match the selected layout's seat count.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textHint, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
