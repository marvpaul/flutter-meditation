import 'package:flutter/material.dart';

import '../screens/session_summary_page_view.dart';
import 'session_summary_info_row.dart';
import 'session_summary_title_and_value_widget.dart';

class MeditationDetailsWidget extends StatelessWidget {
  final String totalDuration;
  final String maxHeartRate;
  final String minHeartRate;
  final String avgHeartRate;
  final bool isHapticFeedbackEnabled;

  const MeditationDetailsWidget({
    super.key,
    required this.totalDuration,
    required this.maxHeartRate,
    required this.minHeartRate,
    required this.avgHeartRate,
    required this.isHapticFeedbackEnabled,
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
              title: 'Total Duration',
              value: totalDuration,
            ),
            rightWidget: SessionSummaryTitleAndValueWidget(
              title: 'Avg Heart Rate',
              value: avgHeartRate,
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
              title: 'Haptic Feedback',
              value: isHapticFeedbackEnabled ? 'YES' : 'NO',
            ),
            rightWidget: Container(),
          ),
        ],
      ),
    );
  }
}