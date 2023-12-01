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
        titleTextStyle: Theme.of(context).textTheme.headlineLarge,
        backgroundColor: Colors.black,
        title: Text("Past Sessions"),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Details',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            MeditationDetails(
              totalDuration: secondsToHRF(meditation.duration.toDouble()).toString() + ' min',
              timeUntilRelaxation: 'nAn min',
              maxHeartRate: viewModel.getMaxHeartRate(meditation).toString() + ' BPM',
              minHeartRate: viewModel.getMinHeartRate(meditation).toString() + ' BPM',
              avgHeartRate: viewModel.getAverageHeartRate(meditation).toString() + ' BPM',
            ),
          ],
        ),
      ),
    );
  }
}
