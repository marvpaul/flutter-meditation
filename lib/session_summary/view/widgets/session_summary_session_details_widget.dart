import 'package:flutter/material.dart';

import '../screens/session_summary_page_view.dart';
import 'session_summary_info_row.dart';
import 'session_summary_title_and_value_widget.dart';

class SessionSummarySessionDetailsWidget extends StatelessWidget {
  String? mandala;
  double? beatFrequency;
  String breathingPattern;
  String breathingPatternMultiplier;

  SessionSummarySessionDetailsWidget({
    super.key,
    required this.mandala,
    required this.beatFrequency,
    required this.breathingPattern,
    required this.breathingPatternMultiplier,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 6.0, bottom: 16.0),
      child: Column(
        children: [
          SessionSummaryInfoRow(
            leftWidget: SessionSummaryTitleAndValueWidget(
              title: 'Mandala',
              value: mandala ?? 'None',
            ),
            rightWidget: SessionSummaryTitleAndValueWidget(
              title: 'Beat Frequency',
              value: beatFrequency != null ? '${beatFrequency!.toInt()} Hz' : 'None',
            ),
          ),
          DividerExtension.thin(),
          SessionSummaryInfoRow(
            leftWidget: SessionSummaryTitleAndValueWidget(
              title: 'Breathing Pattern',
              value: breathingPattern,
            ),
            rightWidget: SessionSummaryTitleAndValueWidget(
              title: 'Multiplier',
              value: breathingPatternMultiplier,
            ),
          ),
        ],
      ),
    );
  }
}