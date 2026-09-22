import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/bus_booking/widgets/booking_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Sample pickup/drop point options – replace with real data source as needed.
const _kPickupPoints = ['Colombo', 'Kandy', 'Galle', 'Jaffna', 'Trincomalee'];
const _kDropPoints = ['Colombo', 'Kandy', 'Galle', 'Matara', 'Trincomalee'];

class PassengerFormSection extends StatefulWidget {
  const PassengerFormSection({super.key});

  @override
  State<PassengerFormSection> createState() => _PassengerFormSectionState();
}

class _PassengerFormSectionState extends State<PassengerFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  String? _pickupPoint;
  String? _dropPoint;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: BookingSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BookingCardHeader(
              icon: Icons.person_outline,
              title: 'Passenger Details',
            ),
            const SizedBox(height: AppSpacing.lg),

            // First Name *
            const _FieldLabel(label: 'First Name', required: true),
            const SizedBox(height: AppSpacing.xs),
            _BookingFormField(
              controller: _firstNameController,
              hintText: 'First name',
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'First name is required.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // Last Name *
            const _FieldLabel(label: 'Last Name', required: true),
            const SizedBox(height: AppSpacing.xs),
            _BookingFormField(
              controller: _lastNameController,
              hintText: 'Last name',
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Last name is required.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // NIC / Passport (optional)
            const _FieldLabel(label: 'NIC / Passport', required: false),
            const SizedBox(height: AppSpacing.xs),
            _BookingFormField(
              controller: _nicController,
              hintText: 'NIC or passport number (optional)',
            ),
            const SizedBox(height: AppSpacing.md),

            // Email (optional)
            const _FieldLabel(label: 'Email', required: false),
            const SizedBox(height: AppSpacing.xs),
            _BookingFormField(
              controller: _emailController,
              hintText: 'Email address (optional)',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.md),

            // Traveller Contact No *
            const _FieldLabel(label: 'Traveller Contact No', required: true),
            const SizedBox(height: AppSpacing.xs),
            _BookingFormField(
              controller: _contactController,
              hintText: '77XXXXXXX',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Traveller contact number is required.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // Pickup Point *
            const _FieldLabel(label: 'Pickup Point', required: true),
            const SizedBox(height: AppSpacing.xs),
            _DropdownField(
              value: _pickupPoint,
              items: _kPickupPoints,
              hintText: 'Select pickup point',
              onChanged: (v) => setState(() => _pickupPoint = v),
              validator: (v) =>
                  v == null ? 'Please select a pickup point.' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // Drop Point *
            const _FieldLabel(label: 'Drop Point', required: true),
            const SizedBox(height: AppSpacing.xs),
            _DropdownField(
              value: _dropPoint,
              items: _kDropPoints,
              hintText: 'Select drop point',
              onChanged: (v) => setState(() => _dropPoint = v),
              validator: (v) =>
                  v == null ? 'Please select a drop point.' : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Field label with optional/required indicator ──────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.required});
  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          label,
          style: tt.bodySmall?.copyWith(
              color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
        if (required) ...[
          const SizedBox(width: 3),
          const Text('*',
              style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ] else ...[
          const SizedBox(width: 4),
          Text(
            '(optional)',
            style: tt.bodySmall?.copyWith(
                color: AppColors.textHint, fontWeight: FontWeight.w400),
          ),
        ],
      ],
    );
  }
}

// ── Reusable text form field ───────────────────────────────────────────────────

class _BookingFormField extends StatelessWidget {
  const _BookingFormField({
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

// ── Reusable dropdown form field ───────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
    required this.validator,
  });

  final String? value;
  final List<String> items;
  final String hintText;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      onChanged: onChanged,
      style: tt.bodyMedium?.copyWith(color: AppColors.textPrimary),
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.textSecondary),
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
      items: items
          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
          .toList(),
    );
  }
}
