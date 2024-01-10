/// {@category View}
/// The view for our actual meditation session with a kaleidoscope, heart rate visualization,
/// breathing excerice and a timer for the meditation. 
library session_page_view; 
import 'package:flutter/material.dart';
import 'package:flutter_meditation/widgets/gradient_background.dart';
import 'package:flutter_meditation/widgets/kaleidoscope.dart';
import 'package:flutter_meditation/widgets/session_widget.dart';
import '../../../base/base_view.dart';
import '../../../widgets/breathing_instructions_widget.dart';
import '../../view_model/session_page_view_model.dart';

class SessionPageView extends BaseView<SessionPageViewModel> {
  SessionPageView({super.key});

  @override
  Widget build(
      BuildContext context, SessionPageViewModel viewModel, Widget? child) {
    if (!viewModel.running && !viewModel.finished) {
      viewModel.initWithContext(context);
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          (viewModel.settingsModel?.kaleidoscope ?? false) || viewModel.isAiModeEnabled
            ? Kaleidoscope(viewModel: viewModel)
            : const GradientBackground(),
          SafeArea(
            minimum: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
              child: SessionWidget(viewModel: viewModel)
          ),
          BreathingInstructionsWidget(stateProgress: viewModel.stateProgress, state: viewModel.state, onTap: (){ viewModel.showUI = !viewModel.showUI; },)
      ]),
    );
  }
}
