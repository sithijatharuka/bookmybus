import 'package:flutter/material.dart';
import 'amenities_selector.dart';
import 'bus_configuration_step.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import 'frequency_card.dart';
import 'guidance_banner.dart';
import 'manual_trip_card.dart';
import 'schedule_time_fields.dart';

enum _Frequency { everyday, everyOtherDay, manual }

class ScheduleInformationStep extends StatefulWidget {
  const ScheduleInformationStep({
    super.key,
    this.fromCity = 'Departure City',
    this.toCity = 'Destination City',
  });

  final String fromCity;
  final String toCity;

  @override
  State<ScheduleInformationStep> createState() =>
      _ScheduleInformationStepState();
}

class _ScheduleInformationStepState extends State<ScheduleInformationStep> {
  _Frequency _frequency = _Frequency.everyday;

  // Everyday / Every Other Day
  final _depTime = TextEditingController();
  final _arrTime = TextEditingController();
  bool _arrivesNextDay = false;

  // Every Other Day – start date
  final _eodStartDate = TextEditingController();

  // Manual – shared
  final _startDate = TextEditingController();

  // Manual – up trip
  final _upDep = TextEditingController();
  final _upArr = TextEditingController();
  bool _upNextDay = false;

  // Manual – down trip
  final _downDep = TextEditingController();
  final _downArr = TextEditingController();
  bool _downNextDay = false;

  @override
  void dispose() {
    _depTime.dispose();
    _arrTime.dispose();
    _eodStartDate.dispose();
    _startDate.dispose();
    _upDep.dispose();
    _upArr.dispose();
    _downDep.dispose();
    _downArr.dispose();
    super.dispose();
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      controller.text = picked.format(context);
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null && mounted) {
      controller.text =
          '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Guidance Banner ───────────────────────────────────────
          const GuidanceBanner(
            message: 'Ensure times are accurate for passengers.',
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Frequency Toggle ──────────────────────────────────────
          _RequiredLabel('Frequency', tt),
          const SizedBox(height: AppSpacing.sm),
          FrequencyCard(
            emoji: '📅',
            title: 'Everyday',
            subtitle:
                'Bus runs every day using the departure & arrival times set above.',
            selected: _frequency == _Frequency.everyday,
            onTap: () => setState(() => _frequency = _Frequency.everyday),
          ),
          const SizedBox(height: AppSpacing.sm),
          FrequencyCard(
            emoji: '📆',
            title: 'Every Other Day',
            subtitle:
                'Bus runs every alternate day using departure & arrival times.',
            selected: _frequency == _Frequency.everyOtherDay,
            onTap: () => setState(() => _frequency = _Frequency.everyOtherDay),
          ),
          const SizedBox(height: AppSpacing.sm),
          FrequencyCard(
            emoji: '✏️',
            title: 'Manual',
            subtitle:
                'Set a start date and exact up/down departure times. The bus will repeat this daily routine from the start date.',
            selected: _frequency == _Frequency.manual,
            onTap: () => setState(() => _frequency = _Frequency.manual),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Dynamic Content ───────────────────────────────────────
          if (_frequency == _Frequency.everyday)
            ScheduleTimeFields(
              departureController: _depTime,
              arrivalController: _arrTime,
              arrivesNextDay: _arrivesNextDay,
              onArrivesNextDayChanged: (v) =>
                  setState(() => _arrivesNextDay = v ?? false),
              onDepartureTap: () => _pickTime(_depTime),
              onArrivalTap: () => _pickTime(_arrTime),
            ),

          if (_frequency == _Frequency.everyOtherDay) ...[
            // Start date section
            Text('Every Other Day — Start Date', style: tt.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'The bus will run on this date and every 2nd day after.',
              style: tt.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            _RequiredLabel('Starting Date', tt),
            const SizedBox(height: AppSpacing.xs),
            _DatePickerField(
              controller: _eodStartDate,
              onTap: () => _pickDate(_eodStartDate),
            ),
            const SizedBox(height: AppSpacing.xl),
            ScheduleTimeFields(
              departureController: _depTime,
              arrivalController: _arrTime,
              arrivesNextDay: _arrivesNextDay,
              onArrivesNextDayChanged: (v) =>
                  setState(() => _arrivesNextDay = v ?? false),
              onDepartureTap: () => _pickTime(_depTime),
              onArrivalTap: () => _pickTime(_arrTime),
            ),
          ],

          if (_frequency == _Frequency.manual) ...[
            Text('Manual Daily Schedule', style: tt.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Set a start date. From that date, the bus runs this same routine every day.',
              style: tt.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Starting Date
            _RequiredLabel('Starting Date', tt),
            const SizedBox(height: AppSpacing.xs),
            _DatePickerField(
              controller: _startDate,
              onTap: () => _pickDate(_startDate),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Up Trip
            ManualTripCard(
              isUpTrip: true,
              title: '${widget.fromCity} → ${widget.toCity}',
              departureController: _upDep,
              arrivalController: _upArr,
              arrivesNextDay: _upNextDay,
              onArrivesNextDayChanged: (v) =>
                  setState(() => _upNextDay = v ?? false),
              onDepartureTap: () => _pickTime(_upDep),
              onArrivalTap: () => _pickTime(_upArr),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Down Trip
            ManualTripCard(
              isUpTrip: false,
              title: '${widget.toCity} → ${widget.fromCity}',
              departureController: _downDep,
              arrivalController: _downArr,
              arrivesNextDay: _downNextDay,
              onArrivesNextDayChanged: (v) =>
                  setState(() => _downNextDay = v ?? false),
              onDepartureTap: () => _pickTime(_downDep),
              onArrivalTap: () => _pickTime(_downArr),
            ),
          ],

          // ── Bus Configuration ─────────────────────────────────────
          const SizedBox(height: AppSpacing.xl),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: AppSpacing.xl),
          const BusConfigurationStep(),
          const SizedBox(height: AppSpacing.xl),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: AppSpacing.xl),
          const AmenitiesSelector(),
        ],
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({required this.controller, required this.onTap});
  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          readOnly: true,
          style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'mm/dd/yyyy',
            hintStyle: tt.bodyMedium?.copyWith(color: AppColors.textHint),
            suffixIcon: const Icon(Icons.calendar_today_outlined,
                size: 18, color: AppColors.textHint),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel(this.text, this.tt);
  final String text;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: tt.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
                color: AppColors.error, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
