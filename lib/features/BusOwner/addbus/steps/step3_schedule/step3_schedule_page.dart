import 'package:flutter/material.dart';
import 'widgets/schedule_information_step.dart';

class Step3SchedulePage extends StatelessWidget {
  const Step3SchedulePage({super.key, this.standalone = true});

  final bool standalone;

  @override
  Widget build(BuildContext context) {
    return ScheduleInformationStep(standalone: standalone);
  }
}
