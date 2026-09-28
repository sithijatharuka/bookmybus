import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/home/models/bus_route_model.dart';
import 'package:bookmybus/features/Passenger/journey/data/dummy_journey_bus_data.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:bookmybus/features/Passenger/journey/widgets/journey_page_header.dart';
import 'package:bookmybus/features/Passenger/journey/widgets/journey_results_section.dart';
import 'package:bookmybus/features/Passenger/journey/widgets/journey_search_card.dart';
import 'package:bookmybus/features/Passenger/journey/widgets/journey_search_fields.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class JourneyPage extends StatefulWidget {
  const JourneyPage({super.key, this.route, DateTime? date}) : _date = date;

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

  @override
  Widget build(BuildContext context) {
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
            const JourneyPageHeader(),
            const SizedBox(height: AppSpacing.xl),
            JourneySearchCard(
              from: _from,
              to: _to,
              date: _date,
              onFromTap: () => _pickCity(isFrom: true),
              onToTap: () => _pickCity(isFrom: false),
              onDateTap: _pickDate,
              onClearFrom: _from != null ? () => setState(() => _from = null) : null,
              onClearTo: _to != null ? () => setState(() => _to = null) : null,
              onClearSearch: _clearSearch,
            ),
            if (isFiltered || isCleared) ...[
              const SizedBox(height: AppSpacing.xl),
              JourneyResultsSection(
                results: results,
                isCleared: isCleared,
                from: _from,
                to: _to,
                date: _date,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
