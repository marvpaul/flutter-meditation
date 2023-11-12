import 'package:flutter/material.dart';
import 'package:flutter_meditation/dependency_service.dart';

import '../viewmodel/SettingsPageViewModel.dart';

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({ super.key });

  @override
  State<SettingsPageView> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPageView> {
  late SettingsPageViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = DependencyService.getChangeNotifier(context);
    viewModel.startObserving();
  }

  @override
  void dispose() {
    viewModel.stopObserving();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.headlineLarge,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Settings"),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return ListTile(
          enableFeedback: false,
          title: const Text("Haptic Feedback"), trailing: Switch(value: viewModel.isHapticFeedbackEnabled, onChanged: (isEnabled) {
            viewModel.toggleHapticFeedback(isEnabled);
        },),
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (context) => SimpleBreathing()),
            // );
          },
        );
      },
        itemCount: 1,
      )
    );
  }
}
