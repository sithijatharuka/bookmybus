import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import 'bus_type_dropdown.dart';
import 'flip_seat_toggle.dart';
import 'seat_layout_selector.dart';

class BusConfigurationStep extends StatefulWidget {
  const BusConfigurationStep({super.key});

  @override
  State<BusConfigurationStep> createState() => _BusConfigurationStepState();
}

class _BusConfigurationStepState extends State<BusConfigurationStep> {
  String? _busType;
  String? _seatLayout;
  bool _flipLayout = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bus Configuration', style: tt.titleMedium),
        const SizedBox(height: AppSpacing.xl),

        _RequiredFieldLabel('Bus Type'),
        const SizedBox(height: AppSpacing.xs),
        BusTypeDropdown(
          value: _busType,
          onChanged: (v) => setState(() => _busType = v),
        ),
        const SizedBox(height: AppSpacing.xl),

        _RequiredFieldLabel('Seat Layout'),
        const SizedBox(height: AppSpacing.sm),
        SeatLayoutSelector(
          selected: _seatLayout,
          onChanged: (v) => setState(() => _seatLayout = v),
        ),
        const SizedBox(height: AppSpacing.xl),

        FlipSeatToggle(
          value: _flipLayout,
          onChanged: (v) => setState(() => _flipLayout = v),
        ),
      ],
    );
  }
}

class _RequiredFieldLabel extends StatelessWidget {
  const _RequiredFieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
