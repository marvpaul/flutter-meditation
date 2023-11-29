import 'package:flutter/material.dart';
import 'package:flutter_meditation/common/helpers.dart';
import 'package:flutter_meditation/widgets/breathing_circle_widget.dart';
import 'package:flutter_meditation/widgets/gradient_background.dart';
import 'package:flutter_meditation/widgets/heart_rate_graph.dart';
import 'package:flutter_meditation/widgets/information_box.dart';
import 'package:flutter_meditation/widgets/kaleidoscope.dart';
import '../../../base/base_view.dart';
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
      body: GradientBackground(
        child: Column(
          children: [
            AppBar(
              centerTitle: false,
              titleTextStyle: Theme.of(context).textTheme.headlineLarge,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InformationBox(
                          kind: "HEART RATE",
                          value: viewModel.heartRate.toString(),
                          unit: "BPM"),
                    ),
                    SizedBox(width: 16), // Adjust the width as needed
                    Expanded(
                      child: InformationBox(
                          kind: "ELAPSED TIME",
                          value:
                              secondsToHRF(viewModel.elapsedSeconds).toString(),
                          unit: "MIN"),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: GestureDetector(
                    child: Container(
                      width: 150,
                      height: 200,
                      child: BreathingCircleWidget(
                          progress: viewModel.stateProgress,
                          state: viewModel.state),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: const Kaleidoscope(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.8, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                  child: HeartRateGraph(
                    key: viewModel.heartRateGraphKey,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.tertiary,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.close,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Add some spacing between buttons
                    Expanded(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.primary,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              Text(
                                'Finish',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
