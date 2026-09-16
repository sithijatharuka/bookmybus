import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/journey/widgets/journey_search_fields.dart';
import 'package:flutter/material.dart';

class BookYourJourneyCard extends StatefulWidget {
  const BookYourJourneyCard({super.key, this.onSearch});

  final void Function(String from, String to, DateTime date)? onSearch;

  @override
  State<BookYourJourneyCard> createState() => _BookYourJourneyCardState();
}

class _BookYourJourneyCardState extends State<BookYourJourneyCard> {
  String? _from;
  String? _to;
  DateTime _date = DateTime.now();

  static const _cities = [
    'Colombo', 'Kandy', 'Jaffna', 'Mannar',
    'Galle', 'Trincomalee', 'Anuradhapura',
  ];

  Future<void> _pickCity({required bool isFrom}) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => JourneyCityPicker(
        cities: _cities,
        exclude: isFrom ? _to : _from,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) _from = picked;
        else _to = picked;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F7FA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.luggage, color: Colors.cyan, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Book your journey',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── From field ───────────────────────────────────────────
          JourneySearchField(
            label: 'From',
            value: _from,
            icon: Icons.trip_origin,
            iconColor: AppColors.primary,
            onTap: () => _pickCity(isFrom: true),
            onClear: _from != null ? () => setState(() => _from = null) : null,
          ),
          const SizedBox(height: AppSpacing.md),

          // ── To field ─────────────────────────────────────────────
          JourneySearchField(
            label: 'To',
            value: _to,
            icon: Icons.location_on,
            iconColor: AppColors.error,
            onTap: () => _pickCity(isFrom: false),
            onClear: _to != null ? () => setState(() => _to = null) : null,
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Date field ───────────────────────────────────────────
          JourneyDateField(date: _date, onTap: _pickDate),
          const SizedBox(height: AppSpacing.lg),

          // ── Search button ────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: (_from != null && _to != null)
                  ? () => widget.onSearch?.call(_from!, _to!, _date)
                  : null,
              icon: const Icon(Icons.search, size: 20),
              label: const Text('Search buses'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.border,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md + 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
