import 'package:flutter/material.dart';

import '../../../base/base_view.dart';
import '../../../settings/view/screens/settings_page_view.dart';
import '../../view_model/home_page_view_model.dart';
import '../widgets/past_meditations_card_view.dart';


class HomePageView extends BaseView<HomePageViewModel> {

  @override
  Widget build(
      BuildContext context, HomePageViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.headlineLarge,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(viewModel.appbarText),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsPageView()),
              );
            },
          ),],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => SimpleBreathing()),
                // );
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: PastMeditationsCardView(meditationSessionEntries: viewModel.meditationDataCount),
    );
  }
}