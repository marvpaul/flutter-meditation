import 'package:flutter/material.dart';
import 'package:flutter_meditation/widgets/circle_widget.dart';
import 'package:flutter_meditation/widgets/gradient_background.dart';
import '../../../base/base_view.dart';
import '../../view_model/home_page_view_model.dart';
import '../widgets/past_meditations_card_view.dart';

class HomePageView extends BaseView<HomePageViewModel> {
  @override
  Widget build(
      BuildContext context, HomePageViewModel viewModel, Widget? child) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            AppBar(
              toolbarHeight: 100,
              centerTitle: false,
              titleTextStyle: Theme.of(context).textTheme.headlineLarge,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(viewModel.appbarText),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () {
                    viewModel.navigateToSettings(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleWidget(
                      progress: 1,
                      onTap: () => {viewModel.navigateToSession(context)},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: PastMeditationsCardView(
        meditationSessionEntries: viewModel.meditationDataCount,
        onPressed: () {
          viewModel.navigateToSessionSummary(context);
        },
      ),
    );
  }
}
