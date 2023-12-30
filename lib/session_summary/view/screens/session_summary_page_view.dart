import 'package:flutter/material.dart';
import 'package:flutter_meditation/common/helpers.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/session_summary/view/widgets/meditation_details_widget.dart';
import '../../../base/base_view.dart';
import '../../view_model/past_sessions_page_view_model.dart';

class SessionSummaryPageView extends BaseView<SessionSummaryPageViewModel> {
  final MeditationModel meditation;

  SessionSummaryPageView({required this.meditation, Key? key})
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
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            MeditationDetailsWidget(
              totalDuration: '${secondsToHRF(meditation.duration.toDouble())} min',
              timeUntilRelaxation: 'nAn min',
              maxHeartRate: '${viewModel.getMaxHeartRate(meditation)} BPM',
              minHeartRate: '${viewModel.getMinHeartRate(meditation)} BPM',
              avgHeartRate: '${viewModel.getAverageHeartRate(meditation)} BPM',
            ),
          ],
        ),
      ),
    );
  }
}

extension DividerExtension on Divider {
  static Widget thin({double indent = 10, double endIndent = 10}) {
    return const Divider(color: Colors.grey, thickness: 0.3, indent: 10, endIndent: 10, height: 0.3);
  }
}
