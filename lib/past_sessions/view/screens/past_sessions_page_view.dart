import 'package:flutter/material.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/past_sessions/view/widgets/past_sessions_list_entry_widget.dart';
import '../../../base/base_view.dart';
import '../../view_model/past_sessions_page_view_model.dart';

class PastSessionsPageView extends BaseView<PastSessionsPageViewModel> {
  PastSessionsPageView({super.key});

  @override
  Widget build(BuildContext context, PastSessionsPageViewModel viewModel,
      Widget? child) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.headlineLarge,
        backgroundColor: Colors.black,
        title: Text("Session summary"),
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
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.meditations?.length,
                itemBuilder: (context, index) {
                  MeditationModel? meditation = viewModel.meditations?[index];
                  return PastSessionsListEntry(
                    meditation: meditation!,
                    onPlayPressed: () {
                      viewModel.navigateToSummary(context, meditation); 
                    },
                    averageBPM: viewModel.getAverageHeartRate(meditation),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
