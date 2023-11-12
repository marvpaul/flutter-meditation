import 'package:flutter/material.dart';
import 'package:flutter_meditation/settings/page/presentation/view/SettingsPageView.dart';
import 'package:provider/provider.dart';

import '../../../../dependency_service.dart';
import '../../../../pastmeditation/presentation/PastMeditationsCardView.dart';
import '../viewmodel/HomePageViewModel.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({ super.key });

  @override
  State<HomePageView> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageView> {
  late HomePageViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = DependencyService.getChangeNotifier(context);
  }

  @override
  Widget build(BuildContext context) {
    HomePageViewModel viewModel = Provider.of<HomePageViewModel>(context);
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
                MaterialPageRoute(builder: (context) => const SettingsPageView()),
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
      floatingActionButton: const PastMeditationsCardView(meditationSessionEntries: 7),
    );
  }
}