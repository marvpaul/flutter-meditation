import 'package:flutter/material.dart';
import 'package:flutter_meditation/common/helpers.dart';
import 'package:flutter_meditation/session/view_model/session_page_view_model.dart';
import 'package:flutter_meditation/widgets/information_box.dart';

import 'heart_rate_graph.dart';

class SessionWidget extends StatelessWidget {
  final double padding = 15.0;
  final double interItemSpacing = 15.0;

  final SessionPageViewModel viewModel;

  SessionWidget({required this.viewModel});

  double heightForBox(double width) {
    return (width - padding * 2 - interItemSpacing) / 2 * 0.6;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          Visibility(
            visible: viewModel.showUI,
            child: Row(
              children: [
                Expanded(
                  child: InformationBox(
                    kind: "HEART RATE",
                    value: viewModel.heartRate.toString(),
                    unit: "BPM",
                    background: HeartRateGraph(
                      viewModel: viewModel,
                      key: viewModel.heartRateGraphKey,
                    ),
                    boxHeight: heightForBox(width),
                  ),
                ),
                SizedBox(width: interItemSpacing),
                Expanded(
                  child: InformationBox(
                    kind: "ELAPSED TIME",
                    value: secondsToHRF(viewModel.elapsedSeconds).toString(),
                    unit: "MIN",
                    boxHeight: heightForBox(width),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          _ActionButtons(),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
      ],);
  }
}