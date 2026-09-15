import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

mixin _FilterMixin<T extends StatefulWidget> on State<T> {
  String selectedBus = 'All Buses';
  int selectedPreset = 0;
  final fromCtrl = TextEditingController();
  final toCtrl = TextEditingController();

  final buses = const ['All Buses', 'BATTI EXPRESS', 'TRIMAT', 'TST'];
  final presets = const ['Today', 'Last 7 Days', 'Last 30 Days'];

  static const _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  );

  static const inputDecoration = InputDecoration(
    filled: true,
    fillColor: Color(0xFFF4F5F7),
    border: _inputBorder,
    enabledBorder: _inputBorder,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.primary),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
  );

  @override
  void dispose() {
    fromCtrl.dispose();
    toCtrl.dispose();
    super.dispose();
  }

  Future<void> pickDate(TextEditingController ctrl) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.white,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        ctrl.text =
            '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void clearFilters() => setState(() {
        selectedBus = 'All Buses';
        selectedPreset = 0;
        fromCtrl.clear();
        toCtrl.clear();
      });

  Widget buildBusDropdown() => DropdownButtonFormField<String>(
        value: selectedBus,
        items: buses.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
        onChanged: (v) => setState(() => selectedBus = v!),
        decoration: inputDecoration,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        dropdownColor: AppColors.white,
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
      );

  Widget buildPresetChips() => Row(
        children: List.generate(presets.length, (i) {
          final active = selectedPreset == i;
          return Padding(
            padding: EdgeInsets.only(right: i < presets.length - 1 ? AppSpacing.sm : 0),
            child: GestureDetector(
              onTap: () => setState(() => selectedPreset = i),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : const Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  presets[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: active ? AppColors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      );

  Widget buildDateInputs() => Row(
        children: [
          Expanded(child: _dateField('FROM', fromCtrl)),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _dateField('TO', toCtrl)),
        ],
      );

  Widget _dateField(String label, TextEditingController ctrl) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: ctrl,
            readOnly: true,
            onTap: () => pickDate(ctrl),
            decoration: inputDecoration.copyWith(
              hintText: 'mm/dd/yyyy',
              hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
              suffixIcon: const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ),
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
        ],
      );

  Widget buildActionButtons({required VoidCallback onApply}) => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: clearFilters,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              child: const Text('Clear All', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      );
}

// ─── Inline Filter Card ───────────────────────────────────────────────────────

class DashboardInlineFilter extends StatefulWidget {
  const DashboardInlineFilter({super.key});

  @override
  State<DashboardInlineFilter> createState() => _DashboardInlineFilterState();
}

class _DashboardInlineFilterState extends State<DashboardInlineFilter>
    with _FilterMixin<DashboardInlineFilter> {
  void _apply() {
    // Filter applied inline — state is already held here.
    // Extend with a callback if parent needs the values.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Filter by Bus',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          buildBusDropdown(),
          const SizedBox(height: AppSpacing.lg),
          buildPresetChips(),
          const SizedBox(height: AppSpacing.lg),
          buildDateInputs(),
          const SizedBox(height: AppSpacing.xl),
          buildActionButtons(onApply: _apply),
        ],
      ),
    );
  }
}

// ─── Bottom Sheet ─────────────────────────────────────────────────────────────

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with _FilterMixin<FilterBottomSheet> {
  void _apply() => Navigator.pop(context, {
        'bus': selectedBus,
        'preset': presets[selectedPreset],
        'from': fromCtrl.text,
        'to': toCtrl.text,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Filter by Bus',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          buildBusDropdown(),
          const SizedBox(height: AppSpacing.lg),
          buildPresetChips(),
          const SizedBox(height: AppSpacing.lg),
          buildDateInputs(),
          const SizedBox(height: AppSpacing.xl),
          buildActionButtons(onApply: _apply),
        ],
      ),
    );
  }
}
