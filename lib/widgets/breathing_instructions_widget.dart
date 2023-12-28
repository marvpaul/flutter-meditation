import 'package:flutter/material.dart';

import '../session/data/model/breathing_pattern_model.dart';
import 'breathing_circle_widget.dart';

class BreathingInstructionsWidget extends StatelessWidget {
  final double stateProgress;
  final BreathingStepType state;
  final VoidCallback onTap;

  BreathingInstructionsWidget({
    required this.stateProgress,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: GestureDetector(
        onTap: () => {
          onTap(),
        },
        child: SizedBox(
          width: 150,
          height: 200,
          child: BreathingCircleWidget(
              progress: stateProgress, state: state.value),
        ),
      ),
    );
  }
}