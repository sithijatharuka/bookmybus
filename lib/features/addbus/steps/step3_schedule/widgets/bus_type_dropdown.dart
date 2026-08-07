import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';

const _busTypes = ['Super Luxury', 'Luxury', 'Semi-Luxury', 'Normal'];

class BusTypeDropdown extends StatelessWidget {
  const BusTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  static const _fillColor = Color(0xFFF8FAFC);
  static const _borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      hint: Text(
        'Select Bus Type',
        style: tt.bodyMedium?.copyWith(color: AppColors.textHint),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.textHint),
      style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
      dropdownColor: AppColors.white,
      decoration: InputDecoration(
        filled: true,
        fillColor: _fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: _borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      items: _busTypes
          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
          .toList(),
    );
  }
}
