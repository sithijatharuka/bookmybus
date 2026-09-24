import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/booking_section_card.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:flutter/material.dart';

class BusInformationCard extends StatefulWidget {
  const BusInformationCard({super.key, required this.bus});

  final JourneyBusModel bus;

  @override
  State<BusInformationCard> createState() => _BusInformationCardState();
}

class _BusInformationCardState extends State<BusInformationCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          // ── Header (always visible) ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.section,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.directions_bus_outlined,
                      size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bus.busName,
                        style: tt.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.bus.registrationNumber,
                        style: tt.bodySmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.section,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Expandable details ───────────────────────────────────────────
          if (_expanded) ...[
            const Divider(color: AppColors.divider, height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _InfoRow(label: 'Bus Number', value: widget.bus.registrationNumber),
                  const SizedBox(height: AppSpacing.md),
                  _InfoRow(label: 'Bus Name', value: widget.bus.busName),
                  const SizedBox(height: AppSpacing.md),
                  _InfoRow(label: 'Bus Type', value: widget.bus.busType),
                  const SizedBox(height: AppSpacing.md),
                  _InfoRow(label: 'Frequency', value: widget.bus.frequency),
                  const SizedBox(height: AppSpacing.md),
                  _InfoRow(label: 'Departure Time', value: widget.bus.departureTime),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
        ),
        Text(value,
            style: tt.bodySmall?.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
