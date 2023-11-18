import 'package:flutter/material.dart';
import '../../base/base_view.dart';
import '../../view_model/settings_page_view_model.dart';

class SettingsPageView extends BaseView<SettingsPageViewModel> {
  @override
  Widget build(
      BuildContext context, SettingsPageViewModel viewModel, Widget? child) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleTextStyle: Theme.of(context).textTheme.headlineLarge,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text("Settings"),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              enableFeedback: viewModel.settings.isHapticFeedbackEnabled,
              title: const Text("Haptic Feedback"),
              trailing: Switch(
                value: viewModel.settings.isHapticFeedbackEnabled,
                onChanged: (isEnabled) {
                  viewModel.toggleHapticFeedback(isEnabled);
                },
              ),
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => SimpleBreathing()),
                // );
              },
            );
          },
          itemCount: 1,
        ));
  }
}
