import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/bus_form_fields.dart';

class Step2BasicInfoPage extends StatefulWidget {
  const Step2BasicInfoPage({super.key});

  @override
  State<Step2BasicInfoPage> createState() => _Step2BasicInfoPageState();
}

class _Step2BasicInfoPageState extends State<Step2BasicInfoPage> {
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
          Text('Step 2: Basic Information', style: tt.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text('Provide the essential details for your bus entry.', style: tt.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          const BusFieldLabel('Bus Name'),
          BusFormField(controller: _busName, hint: 'e.g. Southern Express', suffixIcon: Icons.directions_bus_outlined),
          const SizedBox(height: AppSpacing.lg),
          const BusFieldLabel('Registration Number'),
          BusFormField(
            controller: _regNumber,
            hint: 'e.g. NC-1234',
            suffixIcon: Icons.credit_card_outlined,
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: AppSpacing.lg),
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
          const BusFieldLabel('WhatsApp Phone Number'),
          BusPhoneField(controller: _phone),
        ],
      ),
    );
  }
}
