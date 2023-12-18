import 'package:flutter/material.dart';
import 'package:flutter_meditation/home/view/screens/setup_bluetooth_device_view.dart';
import 'package:flutter_meditation/widgets/circle_widget.dart';
import 'package:flutter_meditation/widgets/gradient_background.dart';
import '../../../base/base_view.dart';
import '../../view_model/home_page_view_model.dart';
import '../widgets/past_meditations_card_view.dart';

class HomePageView extends BaseView<HomePageViewModel> {

  @override
  Widget build(
      BuildContext context, HomePageViewModel viewModel, Widget? child) {
    if (!viewModel.skippedSetup && !viewModel.deviceIsConfigured) {
      return Scaffold(
          body: GradientBackground(
        child: Column(children: [
          AppBar(
            toolbarHeight: 100,
            centerTitle: true,
            titleTextStyle: Theme.of(context).textTheme.headlineLarge,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(viewModel.setupWatchText),
          ),
          SetupBluetoothDeviceView(
              onTap: viewModel.selectBluetoothDevice,
              onSkip: viewModel.skipSetup,
              devices: viewModel.systemDevices),
        ]),
      ));
    }
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
                if (!viewModel.deviceIsConfigured)
                  const Icon(
                    Icons.watch_off,
                    color: Colors.red,
                    size: 30.0,
                  ),
                if (viewModel.deviceIsConfigured)
                  Icon(
                    Icons.watch,
                    color: viewModel.watchIconColor,
                    size: 30.0,
                  ),
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
        meditationSessionEntries: viewModel.meditations?.length??0,
        onPressed: () {
          viewModel.navigateToSessionSummary(context);
        },
      ),
    );
  }
}
