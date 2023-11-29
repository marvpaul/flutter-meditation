import 'package:flutter/material.dart';
import 'package:flutter_meditation/common/BreathingState.dart';
import 'package:flutter_meditation/common/helpers.dart';
import 'package:flutter_meditation/session/view_model/session_page_view_model.dart';
import 'package:flutter_meditation/widgets/breathing_circle_widget.dart';
import 'package:flutter_meditation/widgets/information_box.dart';
import 'package:flutter_meditation/widgets/information_box_heartrate.dart';

class SessionWidget extends StatelessWidget {
  final SessionPageViewModel viewModel;

  SessionWidget({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: viewModel.showUI,
          child: Row(
            children: [
              Expanded(
                child: InformationBoxHeartRate(
                  kind: "HEART RATE",
                  value: viewModel.heartRate.toString(),
                  unit: "BPM",
                  viewModel: viewModel,
                ),
              ),
              const SizedBox(width: 16), // Adjust the width as needed
              Expanded(
                child: InformationBox(
                  kind: "ELAPSED TIME",
                  value: secondsToHRF(viewModel.elapsedSeconds).toString(),
                  unit: "MIN",
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: GestureDetector(
            onTap: () => {
              viewModel.showUI = !viewModel.showUI,
            },
            child: SizedBox(
              width: 150,
              height: 200,
              child: BreathingCircleWidget(
                  progress: viewModel.stateProgress, state: viewModel.state.value),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.tertiary,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            const SizedBox(width: 8), 
            Expanded(
              child: Container(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
    );
  }
}
