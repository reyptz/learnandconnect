import 'package:flutter/material.dart';

class CustomStepper extends StatelessWidget {
  final List<Step> steps;
  final int currentStep;
  final VoidCallback onStepContinue;
  final VoidCallback onStepCancel;

  const CustomStepper({
    Key? key,
    required this.steps,
    required this.currentStep,
    required this.onStepContinue,
    required this.onStepCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stepper(
      steps: steps,
      currentStep: currentStep,
      onStepContinue: onStepContinue,
      onStepCancel: onStepCancel,
    );
  }
}
