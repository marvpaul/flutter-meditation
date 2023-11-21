import 'package:flutter/material.dart';
import '../../../base/base_view.dart';
import '../../view_model/settings_page_view_model.dart';

class SettingsPageView extends BaseView<SettingsPageViewModel> {
  SettingsPageView({super.key});

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
          final isHapticFeedbackEnabled =
              viewModel.settings?.isHapticFeedbackEnabled ?? false;
          final shouldShowHeartRate =
              viewModel.settings?.shouldShowHeartRate ?? false;
          if (index == 0) {
            return ListTile(
              enableFeedback: isHapticFeedbackEnabled,
              title: const Text("Haptic Feedback"),
              trailing: Switch(
                value: isHapticFeedbackEnabled,
                onChanged: (isEnabled) {
                  viewModel.toggleHapticFeedback(isEnabled);
                },
              ),
            );
          } else {
            return ListTile(
              enableFeedback: isHapticFeedbackEnabled,
              title: const Text("Show Heart Rate"),
              trailing: Switch(
                value: shouldShowHeartRate,
                onChanged: (isEnabled) {
                  viewModel.toggleshouldShowHeartRate(isEnabled);
                },
              ),
            );
          }
        },
        itemCount: 2,
      ),
    );
  }
}
