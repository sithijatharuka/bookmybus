import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/home/models/bus_route_model.dart';
import 'package:bookmybus/features/Passenger/journey/data/dummy_journey_bus_data.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:bookmybus/features/Passenger/journey/widgets/journey_bus_card.dart';
import 'package:bookmybus/features/Passenger/journey/widgets/journey_search_fields.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class JourneyPage extends StatefulWidget {
  const JourneyPage({super.key, this.route, DateTime? date})
      : _date = date;

  final BusRouteModel? route;
  final DateTime? _date;

  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  late String? _from;
  late String? _to;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _from = widget.route?.from;
    _to = widget.route?.to;
    _date = widget._date ?? DateTime.now();
  }

  @override
  void didUpdateWidget(JourneyPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.route != oldWidget.route && widget.route != null) {
      setState(() {
        _from = widget.route!.from;
        _to = widget.route!.to;
        _date = widget._date ?? DateTime.now();
      });
    }
  }

  void _clearSearch() => setState(() {
        _from = null;
        _to = null;
        _date = DateTime.now();
      });

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  List<JourneyBusModel> get _results {
    if (_from == null && _to == null) return DummyJourneyBusData.buses;
    if (_from == null || _to == null) return [];
    return DummyJourneyBusData.search(_from!, _to!);
  }


  static const List<String> _cities = [
    'Colombo', 'Kandy', 'Jaffna', 'Mannar',
    'Galle', 'Trincomalee', 'Anuradhapura',
  ];

  Future<void> _pickCity({required bool isFrom}) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
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

  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isFiltered = _from != null && _to != null;
    final isCleared = _from == null && _to == null;
    final results = _results;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Journey'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Page header ──────────────────────────────────────────────────
            Text('Find Your Perfect Journey',
                style: tt.titleLarge?.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Search and book bus tickets across thousands of routes',
              style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Search card ──────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  JourneySearchField(
                    label: 'From',
                    value: _from,
                    icon: Icons.trip_origin,
                    iconColor: AppColors.primary,
                    onTap: () => _pickCity(isFrom: true),
                    onClear: _from != null
                        ? () => setState(() => _from = null)
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  JourneySearchField(
                    label: 'To',
                    value: _to,
                    icon: Icons.location_on,
                    iconColor: AppColors.error,
                    onTap: () => _pickCity(isFrom: false),
                    onClear:
                        _to != null ? () => setState(() => _to = null) : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  JourneyDateField(date: _date, onTap: _pickDate),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _clearSearch,
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Clear Search'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Results ──────────────────────────────────────────────────────
            if (isFiltered || isCleared) ...[
              const SizedBox(height: AppSpacing.xl),

              // Summary header
              Text('Buses',
                  style: tt.titleMedium
                      ?.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isCleared
                    ? 'Showing all available buses'
                    : 'Showing results for your selected route and date',
                style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                results.isEmpty
                    ? 'No buses found for this route'
                    : 'Found ${results.length} ${results.length == 1 ? 'bus' : 'buses'} matching your search',
                style: tt.bodySmall?.copyWith(
                  color: results.isEmpty
                      ? AppColors.error
                      : AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              if (results.isEmpty)
                _EmptyResults(from: _from!, to: _to!)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  itemBuilder: (_, i) =>
                      JourneyBusCard(bus: results[i], date: _date),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Empty Results ──────────────────────────────────────────────────────────────

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.from, required this.to});
  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 48, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.md),
          Text('No buses available',
              style: tt.titleSmall
                  ?.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.xs),
          Text('No buses found from $from to $to.\nTry a different route or date.',
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
