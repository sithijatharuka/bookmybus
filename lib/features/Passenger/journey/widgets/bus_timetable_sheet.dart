import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/journey_bus_model.dart';

class BusTimetableSheet extends StatelessWidget {
  const BusTimetableSheet({super.key, required this.boardingPoints});

  final List<BoardingPoint> boardingPoints;

  static void show(BuildContext context, List<BoardingPoint> boardingPoints) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => BusTimetableSheet(boardingPoints: boardingPoints),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text('Bus Timetable',
                    style:
                        tt.titleMedium?.copyWith(color: AppColors.textPrimary)),
              ],
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text('#',
                      style: tt.bodySmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  child: Text('Location',
                      style: tt.bodySmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600)),
                ),
                Text('Time',
                    style: tt.bodySmall?.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: controller,
              itemCount: boardingPoints.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: AppColors.divider, height: 1),
              itemBuilder: (_, i) {
                final stop = boardingPoints[i];
                return Container(
                  color: i.isEven ? AppColors.white : AppColors.section,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text('${i + 1}',
                            style: tt.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600)),
                      ),
                      Expanded(
                        child: Text(stop.location,
                            style: tt.bodyMedium
                                ?.copyWith(color: AppColors.textPrimary)),
                      ),
                      Text(stop.time,
                          style: tt.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
