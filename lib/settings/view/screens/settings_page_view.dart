import 'package:flutter/material.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
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
    debugPrint("current state: ${viewModel.connectionState.name}");
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
                title: Text('Kaleidoscope'),
                trailing: Switch(
                  value: viewModel.settings?.kaleidoscope ?? false,
                  onChanged: (isEnabled) {
                    viewModel.toggleKaleidoscope(isEnabled);
                  },
                ),
              ),
              ListTile(
                enableFeedback: false,
                title: Text(viewModel.kaleidoscopeImageName),
                trailing: DropdownButton<String>(
                  value: viewModel.settings?.kaleidoscopeImage ?? "Arctic",
                  onChanged: (String? newValue) {
                    viewModel.changeList(
                        viewModel.kaleidoscopeImageName, newValue ?? 'Arctic');
                  },
                  items: viewModel.kaleidoscopeImageOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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

              ListTile(
                enableFeedback: false,
                title: const Text('Breathing pattern'),
                trailing: DropdownButton<String>(
                  value: viewModel.settings?.breathingPattern.value ?? BreathingPatternType.fourSevenEight.value,
                  onChanged: (String? newValue) {
                    viewModel.changeList(
                        'Breathing pattern', newValue ?? '4-7-8');
                  },
                  items: viewModel.breathingPatternOptions
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
          if(viewModel.deviceIsConfigured) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(viewModel.bluetoothSettingsHeading,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Theme.of(context).colorScheme.surfaceTint,
                ),
              ),
            ),
            ListTile(
              enableFeedback: false,
              title: Text(viewModel.configuredDevice!.advName),
              subtitle: Text(viewModel.configuredDevice!.macAddress),
              trailing: TextButton(onPressed: viewModel.unpairDevice,
                child: Text(viewModel.unpairText),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
