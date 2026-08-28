import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import '../data/dummy_manage_bus_data.dart';
import '../widgets/bus_fleet_card.dart';

class ManageBusPage extends StatefulWidget {
  const ManageBusPage({super.key});

  @override
  State<ManageBusPage> createState() => _ManageBusPageState();
}

class _ManageBusPageState extends State<ManageBusPage> {

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final buses = DummyManageBusData.buses;

    return Scaffold(
    appBar: const CommonAppBar(title: 'Manage Bus'),
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xxl + AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Company Details Card ──────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.section,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.business_outlined,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Company Details',
                          style: tt.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        _ReadOnlyField(label: 'Company', value: 'bus1'),
                        const SizedBox(height: AppSpacing.md),
                        _ReadOnlyField(
                          label: 'Company Email',
                          value: 'karank001@gmail.com',
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Contact support to update account details for security purposes.',
                          style: tt.bodySmall?.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Fleet Section Header ──────────────────────────────────
            Row(
              children: [
                Text(
                  'Your Buses',
                  style: tt.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                  child: Text(
                    'Total Buses: ${buses.length}',
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Bus Fleet ListView ────────────────────────────────────
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buses.length,
              itemBuilder: (_, i) => BusFleetCard(bus: buses[i]),
            ),
            const SizedBox(height: AppSpacing.md),
            
          ],
        ),
      ),
    
    );
  }
}

// ── Read-only field ───────────────────────────────────────────────────────────

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        labelStyle: const TextStyle(color: AppColors.textHint),
      ),
      style: const TextStyle(color: AppColors.textSecondary),
    );
  }
}
