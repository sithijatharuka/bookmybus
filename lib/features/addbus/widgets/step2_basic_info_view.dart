import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme/app_spacing.dart';
import 'bus_form_fields.dart';

class Step2BasicInfoView extends StatefulWidget {
  const Step2BasicInfoView({super.key});

  @override
  State<Step2BasicInfoView> createState() => _Step2BasicInfoViewState();
}

class _Step2BasicInfoViewState extends State<Step2BasicInfoView> {
  final _busName = TextEditingController();
  final _regNumber = TextEditingController();
  final _totalSeats = TextEditingController();
  final _pricePerSeat = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _busName.dispose();
    _regNumber.dispose();
    _totalSeats.dispose();
    _pricePerSeat.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          Text('Step 2: Basic Information', style: tt.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Provide the essential details for your bus entry.',
            style: tt.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Bus Name ─────────────────────────────────────────
          const BusFieldLabel('Bus Name'),
          BusFormField(
            controller: _busName,
            hint: 'e.g. Southern Express',
            suffixIcon: Icons.directions_bus_outlined,
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Registration Number ──────────────────────────────
          const BusFieldLabel('Registration Number'),
          BusFormField(
            controller: _regNumber,
            hint: 'e.g. NC-1234',
            suffixIcon: Icons.credit_card_outlined,
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Seats + Price row ────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BusFieldLabel('Total Seats'),
                    BusFormField(
                      controller: _totalSeats,
                      hint: 'e.g. 45',
                      suffixIcon: Icons.event_seat_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BusFieldLabel('Price per Seat (LKR)'),
                    BusFormField(
                      controller: _pricePerSeat,
                      hint: 'e.g. 2500',
                      suffixIcon: Icons.payments_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── WhatsApp Phone ───────────────────────────────────
          const BusFieldLabel('WhatsApp Phone Number'),
          BusPhoneField(controller: _phone),
        ],
      ),
    );
  }
}
