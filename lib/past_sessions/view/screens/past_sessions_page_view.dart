/// {@category View}
/// A view where the user see's a list of every past meditation. It's possible to click on a certain one 
/// to get even more details about the session. 
library past_sessions_page_view; 

import 'package:flutter/material.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import '../../../base/base_view.dart';
import '../../../common/helpers.dart';
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
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(viewModel.pageTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.meditations?.length ?? 0,
              itemBuilder: (context, index) {
                MeditationModel meditation = viewModel.meditations![index];
                return ListTile(
                  title: Text('${secondsToHRF(meditation.duration.toDouble())} min'),
                  titleTextStyle: TextStyle(
                    fontSize: 17.0,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  subtitle: Text(timestampToHRF(meditation.timestamp)),
                  subtitleTextStyle: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${viewModel.getAverageHeartRateForSession(meditation).toInt()} BPM'),
                          const Icon(Icons.chevron_right)
                        ]),),
                  onTap: () => viewModel.navigateToSummary(context, meditation),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
