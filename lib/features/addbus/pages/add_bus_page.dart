import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/common_app_bar.dart';
import '../widgets/step1_upload_images_view.dart';
import '../widgets/step2_basic_info_view.dart';
import '../widgets/step_indicator.dart';
import '../widgets/step_nav_bar.dart';

class AddBusPage extends StatefulWidget {
  const AddBusPage({super.key});

  @override
  State<AddBusPage> createState() => _AddBusPageState();
}

class _AddBusPageState extends State<AddBusPage> {
  int _currentStep = 0;

  static const _steps = [
    (label: 'Images', icon: Icons.photo_library_outlined),
    (label: 'Details', icon: Icons.directions_bus_outlined),
    (label: 'Schedule', icon: Icons.schedule_outlined),
    (label: 'Review', icon: Icons.check_circle_outline),
  ];

  Widget get _stepView => switch (_currentStep) {
        0 => const Step1UploadImagesView(),
        1 => const Step2BasicInfoView(),
        _ => _ComingSoon(label: _steps[_currentStep].label),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Add Bus'),
      body: Column(
        children: [
          StepIndicator(steps: _steps, currentStep: _currentStep),
          Expanded(child: _stepView),
          StepNavBar(
            currentStep: _currentStep,
            totalSteps: _steps.length,
            onBack: () => setState(() => _currentStep--),
            onNext: () => setState(() => _currentStep++),
          ),
        ],
      ),
    );
  }
}

// ── Coming Soon placeholder ───────────────────────────────────────────────────

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.construction_outlined, size: 48, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(
            '$label — coming soon',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
