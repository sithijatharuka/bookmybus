import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

// ── Search Field ───────────────────────────────────────────────────────────────

class JourneySearchField extends StatelessWidget {
  const JourneySearchField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final String? value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.section,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: tt.bodySmall?.copyWith(
                          color: AppColors.textSecondary, fontSize: 11)),
                  Text(
                    value ?? 'Select city',
                    style: tt.bodyMedium?.copyWith(
                      color: value != null
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                      fontWeight:
                          value != null ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close,
                    size: 16, color: AppColors.textSecondary),
              ),
          ],
        ),
      ),
    );
  }
}

// ── City Picker ────────────────────────────────────────────────────────────────

class JourneyCityPicker extends StatefulWidget {
  const JourneyCityPicker({super.key, required this.cities, this.exclude});

  final List<String> cities;
  final String? exclude;

  @override
  State<JourneyCityPicker> createState() => _JourneyCityPickerState();
}

class _JourneyCityPickerState extends State<JourneyCityPicker> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final available = widget.cities
        .where((c) => c != widget.exclude)
        .where((c) => c.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboardInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
              child: Text('Select City',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search city...',
                  hintStyle: tt.bodyMedium?.copyWith(color: AppColors.textHint),
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.textSecondary, size: 20),
                  suffixIcon: _query.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _controller.clear();
                            setState(() => _query = '');
                          },
                          child: const Icon(Icons.close,
                              color: AppColors.textSecondary, size: 18),
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  filled: true,
                  fillColor: AppColors.section,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: available.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Center(
                        child: Text('No cities found',
                            style: tt.bodyMedium
                                ?.copyWith(color: AppColors.textHint)),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...available.map(
                            (city) => ListTile(
                              leading: const Icon(Icons.location_city,
                                  color: AppColors.primary, size: 20),
                              title: Text(city, style: tt.bodyMedium),
                              onTap: () => Navigator.pop(context, city),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Date Field ─────────────────────────────────────────────────────────────────

class JourneyDateField extends StatelessWidget {
  const JourneyDateField({super.key, required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.section,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date',
                      style: tt.bodySmall?.copyWith(
                          color: AppColors.textSecondary, fontSize: 11)),
                  Text(
                    '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}',
                    style: tt.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
