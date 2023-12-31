import 'package:flutter/material.dart';
import 'package:flutter_meditation/common/helpers.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/session_summary/view/widgets/meditation_details_widget.dart';
import '../../../base/base_view.dart';
import '../../../past_sessions/data/model/past_sessions.dart';
import '../../view_model/session_summary_page_view_model.dart';
import '../widgets/session_summary_session_details_widget.dart';

class SessionSummaryPageView extends BaseView<SessionSummaryPageViewModel> {
  final PastSession session;

  SessionSummaryPageView({required this.session, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, SessionSummaryPageViewModel viewModel,
      Widget? child) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: false,
        titleTextStyle: Theme.of(context).textTheme.headlineLarge,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Session Summary"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionHeader("Details"),
              MeditationDetailsWidget(
                totalDuration: '${secondsToHRF(session.duration.toDouble())} min',
                maxHeartRate: '${viewModel.getMaxHeartRate(session)} BPM',
                minHeartRate: '${viewModel.getMinHeartRate(session)} BPM',
                avgHeartRate: '${viewModel.getAverageHeartRate(session)} BPM',
                isHapticFeedbackEnabled: session.sessionPeriods[0].isHapticFeedbackEnabled,
              ),
              spacer(),
              ...List<Widget>.generate(session.sessionPeriods.length, (i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionHeader("Period ${i + 1}"),
                    SessionSummarySessionDetailsWidget(
                      mandala: session.sessionPeriods[i].visualization,
                      beatFrequency: session.sessionPeriods[i].beatFrequency,
                      breathingPattern: session.sessionPeriods[i].breathingPattern.toFormattedString(),
                      breathingPatternMultiplier: session.sessionPeriods[i].breathingPatternMultiplier.toString(),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget spacer() {
    return const SizedBox(height: 20,);
  }

  Widget sectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20.0,
      ),
    );
  }
}

extension DividerExtension on Divider {
  static Widget thin({double indent = 10, double endIndent = 10}) {
    return const Divider(color: Colors.grey, thickness: 0.3, indent: 10, endIndent: 10, height: 0.3);
  }
}
