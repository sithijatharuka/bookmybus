import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/booking_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPassengerForm extends StatefulWidget {
  const AddPassengerForm({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  State<AddPassengerForm> createState() => _AddPassengerFormState();
}

class _AddPassengerFormState extends State<AddPassengerForm> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _nicController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _labelController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactController.dispose();
    _nicController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Label ──────────────────────────────────────────────────────────
          const BookingFieldLabel(label: 'Label *'),
          const SizedBox(height: AppSpacing.xs),
          _FormField(
            controller: _labelController,
            hintText: 'e.g. Me, Father – Amal',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Label is required (e.g., Me, Father – Amal).' : null,
          ),
          const SizedBox(height: AppSpacing.md),

          // ── First Name ─────────────────────────────────────────────────────
          const BookingFieldLabel(label: 'First Name *'),
          const SizedBox(height: AppSpacing.xs),
          _FormField(
            controller: _firstNameController,
            hintText: 'First name',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'First name is required.' : null,
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Last Name ──────────────────────────────────────────────────────
          const BookingFieldLabel(label: 'Last Name *'),
          const SizedBox(height: AppSpacing.xs),
          _FormField(
            controller: _lastNameController,
            hintText: 'Last name',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Last name is required.' : null,
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Traveller Contact No ───────────────────────────────────────────
          const BookingFieldLabel(label: 'Traveller Contact No *'),
          const SizedBox(height: AppSpacing.xs),
          _FormField(
            controller: _contactController,
            hintText: '77XXXXXXX',
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Traveller contact number is required.' : null,
          ),
          const SizedBox(height: AppSpacing.md),

          // ── NIC / Passport (optional) ──────────────────────────────────────
          const BookingFieldLabel(label: 'NIC / Passport'),
          const SizedBox(height: AppSpacing.xs),
          _FormField(
            controller: _nicController,
            hintText: 'NIC or passport number (optional)',
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Email (optional) ───────────────────────────────────────────────
          const BookingFieldLabel(label: 'Email'),
          const SizedBox(height: AppSpacing.xs),
          _FormField(
            controller: _emailController,
            hintText: 'Email address (optional)',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Actions ────────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Helper text ────────────────────────────────────────────────────
          RichText(
            text: TextSpan(
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
              children: const [
                TextSpan(
                  text:
                      'Save this passenger to reuse their details quickly for future bookings. If you prefer not to save the passenger, click ',
                ),
                TextSpan(
                  text: 'Cancel',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                TextSpan(
                  text:
                      ' and fill in the details in the main Passenger Details form instead.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private reusable text field ────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: tt.bodyMedium?.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: tt.bodyMedium?.copyWith(color: AppColors.textHint),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.md),
        filled: true,
        fillColor: AppColors.white,
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 11),
      ),
    );
  }
}
