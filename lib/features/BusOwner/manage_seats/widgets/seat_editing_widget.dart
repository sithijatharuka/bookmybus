import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'release_seats_dialog.dart';

enum _EditLevel { thisDate, permanent }

enum _GenderRestriction { none, male, female }

class SeatEditingWidget extends StatefulWidget {
  const SeatEditingWidget({super.key, required this.label});

  /// Human-readable label for the date or range being edited.
  final String label;

  @override
  State<SeatEditingWidget> createState() => _SeatEditingWidgetState();
}

class _SeatEditingWidgetState extends State<SeatEditingWidget> {
  _EditLevel _editLevel = _EditLevel.thisDate;
  _GenderRestriction _gender = _GenderRestriction.none;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.edit_calendar_outlined,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textSecondary),
                    children: [
                      const TextSpan(text: 'Editing seats for: '),
                      TextSpan(
                        text: widget.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),
          const _SectionLabel(text: 'Edit Level'),
          const SizedBox(height: AppSpacing.sm),

          // ── Edit Level tabs ──────────────────────────────────────
          _SegmentedTabs(
            tabs: const ['This date / range', 'Permanent (all dates)'],
            selectedIndex: _editLevel.index,
            activeColor: AppColors.primary,
            onChanged: (i) =>
                setState(() => _editLevel = _EditLevel.values[i]),
          ),

          const SizedBox(height: AppSpacing.lg),
          const _SectionLabel(text: 'Gender Restriction'),
          const SizedBox(height: AppSpacing.sm),

          // ── Gender Restriction tabs ──────────────────────────────
          _SegmentedTabs(
            tabs: const ['No Restriction', '♂ Male Only', '♀ Female Only'],
            selectedIndex: _gender.index,
            activeColor: _genderActiveColor,
            onChanged: (i) =>
                setState(() => _gender = _GenderRestriction.values[i]),
          ),

          if (_gender != _GenderRestriction.none) ...[
            const SizedBox(height: AppSpacing.sm),
            _GenderInfoChip(
              message: _gender == _GenderRestriction.male
                  ? 'Blocked seats will be reserved for male passengers only'
                  : 'Blocked seats will be reserved for female passengers only',
              bgColor: _gender == _GenderRestriction.male
                  ? const Color(0xFFE0F0FF)
                  : const Color(0xFFFFE6F2),
              textColor: _gender == _GenderRestriction.male
                  ? const Color(0xFF1565C0)
                  : const Color(0xFFC2185B),
            ),
          ],

          if (_editLevel == _EditLevel.permanent) ...[
            const SizedBox(height: AppSpacing.lg),
            const _ReleaseButton(),
          ],
        ],
      ),
    );
  }

  Color get _genderActiveColor {
    switch (_gender) {
      case _GenderRestriction.male:
        return const Color(0xFF1976D2);
      case _GenderRestriction.female:
        return const Color(0xFFD81B60);
      case _GenderRestriction.none:
        return AppColors.primary;
    }
  }
}

// ── Private helpers ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.activeColor,
    required this.onChanged,
  });

  final List<String> tabs;
  final int selectedIndex;
  final Color activeColor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: List.generate(tabs.length, (i) {
        final selected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: selected ? activeColor : AppColors.section,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? activeColor : AppColors.border,
              ),
            ),
            child: Text(
              tabs[i],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ReleaseButton extends StatelessWidget {
  const _ReleaseButton();

  static const _yellow = Color(0xFFB45309);
  static const _yellowBg = Color(0xFFFFFBEB);
  static const _yellowBorder = Color(0xFFFCD34D);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => showReleaseSeatsDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: _yellowBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _yellowBorder),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🔓', style: TextStyle(fontSize: 13)),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'Release for N Days',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _yellow,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Temporarily make permanently-blocked seats bookable for a date window.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _GenderInfoChip extends StatelessWidget {
  const _GenderInfoChip({
    required this.message,
    required this.bgColor,
    required this.textColor,
  });

  final String message;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 15, color: textColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
