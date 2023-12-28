import 'package:flutter/material.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import '../../../base/base_view.dart';
import '../../view_model/settings_page_view_model.dart';

class SettingsPageView extends BaseView<SettingsPageViewModel> {
  SettingsPageView({super.key});

  @override
  Widget build(
      BuildContext context, SettingsPageViewModel viewModel, Widget? child) {
    if (viewModel.settings == null) {
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
            physics: const NeverScrollableScrollPhysics(),
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
                title: Text(viewModel.isBinauralBeatEnabledDisplayText),
                trailing: Switch(
                  value: viewModel.settings?.isBinauralBeatEnabled ?? false,
                  onChanged: (isEnabled) {
                    viewModel.toggleBinauralBeat(isEnabled);
                  },
                ),
              ),
              ListTile(
                enableFeedback: false,
                title: const Text('Breathing pattern'),
                trailing: DropdownButton<String>(
                  value: viewModel.settings?.breathingPattern.value ??
                      BreathingPatternType.fourSevenEight.value,
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
              ListTile(
                enableFeedback: false,
                title: const Text('Meditation duration'),
                trailing: DropdownButton<int>(
                  value: viewModel.settings?.meditationDuration,
                  onChanged: (int? newValue) {
                    viewModel.changeList('Meditation duration', newValue);
                  },
                  items: viewModel.meditationDurationOptions
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
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
          if (viewModel.deviceIsConfigured) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                viewModel.bluetoothSettingsHeading,
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
              trailing: TextButton(
                onPressed: viewModel.unpairDevice,
                child: Text(viewModel.unpairText),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              viewModel.userAccountSettingsHeading,
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).colorScheme.surfaceTint,
              ),
            ),
          ),
          ListTile(
            enableFeedback: false,
            title: Text("UUID"),
            trailing: Text(
              viewModel.settings!.uuid!,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
