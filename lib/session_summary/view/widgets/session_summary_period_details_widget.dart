/// {@category Widget}
library session_summary_period_details_widget;
import 'package:flutter/material.dart';

import '../screens/session_summary_page_view.dart';
import 'session_summary_info_row.dart';
import 'session_summary_title_and_value_widget.dart';

class SessionSummaryPeriodDetailsWidget extends StatelessWidget {
  final String? mandala;
  final double? beatFrequency;
  final String breathingPattern;
  final String breathingPatternMultiplier;
  final String maxHeartRate;
  final String minHeartRate;
  final String avgHeartRate;

  const SessionSummaryPeriodDetailsWidget({
    super.key,
    required this.mandala,
    required this.beatFrequency,
    required this.breathingPattern,
    required this.breathingPatternMultiplier,
    required this.maxHeartRate,
    required this.minHeartRate,
    required this.avgHeartRate,
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
          DividerExtension.thin(),
          SessionSummaryInfoRow(
            leftWidget: SessionSummaryTitleAndValueWidget(
              title: 'Min Heart Rate',
              value: minHeartRate,
            ),
            rightWidget: SessionSummaryTitleAndValueWidget(
              title: 'Max Heart Rate',
              value: maxHeartRate,
            ),
          ),
          DividerExtension.thin(),
          SessionSummaryInfoRow(
            leftWidget: SessionSummaryTitleAndValueWidget(
              title: 'Avg Heart Rate',
              value: avgHeartRate,
            ),
            rightWidget: Container(),
          ),
        ],
      ),
    );
  }
}