import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

import '../models/add_bus_data.dart';
import '../steps/step1_upload_images/step1_upload_images_page.dart';
import '../steps/step2_basic_info/step2_basic_info_page.dart';
import '../steps/step3_schedule/step3_schedule_page.dart';
import '../steps/step4_review/step4_review_page.dart';
import '../widgets/step_indicator.dart';
import '../widgets/step_nav_bar.dart';

class AddBusPage extends StatefulWidget {
  const AddBusPage({super.key});

  @override
  State<AddBusPage> createState() => _AddBusPageState();
}

class _AddBusPageState extends State<AddBusPage> {
  int _currentStep = 0;
  bool _isSubmitting = false;

  static const _steps = [
    (label: 'Images', icon: Icons.photo_library_outlined),
    (label: 'Details', icon: Icons.directions_bus_outlined),
    (label: 'Schedule', icon: Icons.schedule_outlined),
    (label: 'Review', icon: Icons.check_circle_outline),
  ];

  Widget get _stepView => switch (_currentStep) {
        0 => const Step1UploadImagesPage(),
        1 => const Step2BasicInfoPage(),
        2 => const Step3SchedulePage(),
        3 => const Step4ReviewPage(),
        _ => const SizedBox.shrink(),
      };

  /// Collects all step data into a single [AddBusData] object.
  AddBusData _collectData() {
    // Data is currently held in each step's local state.
    // When steps are refactored to share a controller, populate fields here.
    return AddBusData();
  }

  Future<void> _onSubmit() async {
    setState(() => _isSubmitting = true);

    try {
      final busData = _collectData();

      // TODO: ADD BACKEND CODE HERE
      // Example:
      //   final response = await BusRepository().addBus(busData.toJson());
      //   if (response.success) { ... }

      // Simulate async work
      await Future.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackbar(e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        contentPadding: const EdgeInsets.all(AppSpacing.xxl),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  size: 36, color: AppColors.success),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Bus Added Successfully!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your bus has been submitted and is pending review.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.of(context).pop(); // back to previous screen
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm)),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.white, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Failed to add bus. Please try again.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm)),
        margin: const EdgeInsets.all(AppSpacing.lg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Add Bus'),
      body: Stack(
        children: [
          Column(
            children: [
              StepIndicator(steps: _steps, currentStep: _currentStep),
              Expanded(child: _stepView),
              StepNavBar(
                currentStep: _currentStep,
                totalSteps: _steps.length,
                onBack: () => setState(() => _currentStep--),
                onNext: () => setState(() => _currentStep++),
                onSubmit: _onSubmit,
              ),
            ],
          ),

          // ── Submitting overlay ──────────────────────────────────
          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.white),
              ),
            ),
        ],
      ),
    );
  }
}
