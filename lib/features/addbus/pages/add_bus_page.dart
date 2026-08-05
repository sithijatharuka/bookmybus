import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/common_app_bar.dart';
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
