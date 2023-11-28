import 'package:flutter/material.dart';
import '../../../base/base_view.dart';
import '../../view_model/settings_page_view_model.dart';

class SettingsPageView extends BaseView<SettingsPageViewModel> {
  SettingsPageView({super.key});

  @override
  Widget build(
      BuildContext context, SettingsPageViewModel viewModel, Widget? child) {
    if(viewModel.settings == null){
      return const Scaffold();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.headlineLarge,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Settings"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Meditation settings',
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).colorScheme.surfaceTint,
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                enableFeedback: false,
                title: Text(viewModel.hapticFeedbackName),
                trailing: Switch(
                  value: viewModel.settings?.isHapticFeedbackEnabled ?? false,
                  onChanged: (isEnabled) {
                    viewModel.toggleHapticFeedback(isEnabled);
                  },
                ),
              ),
              ListTile(
                enableFeedback: false,
                title: Text(viewModel.soundName),
                trailing: DropdownButton<String>(
                  value: viewModel.settings?.sound ?? "Option 1",
                  onChanged: (String? newValue) {
                    viewModel.changeList(
                        viewModel.soundName, newValue ?? 'Option 1');
                  },
                  items: viewModel.soundOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Meditation info',
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).colorScheme.surfaceTint,
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                enableFeedback: false,
                title: Text(viewModel.heartRateName),
                trailing: Switch(
                  value: viewModel.settings?.shouldShowHeartRate ?? false,
                  onChanged: (isEnabled) {
                    viewModel.toggleShouldShowHeartRate(isEnabled);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
