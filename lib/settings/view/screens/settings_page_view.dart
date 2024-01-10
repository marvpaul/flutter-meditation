/// {@category View}
/// The settings page. Here the user has options to configure the individual meditation 
/// and also see's his UUID. 
library settings_page_view;

import 'package:flutter/material.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import '../../../base/base_view.dart';
import '../../view_model/settings_page_view_model.dart';

class SettingsPageView extends BaseView<SettingsPageViewModel> {

  final EdgeInsets _headlineInsets = const EdgeInsets.only(left: 16.0, top: 10, bottom: 10);

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: _headlineInsets,
              child: Text(
                'Meditation Settings',
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
                  title: const Text('Kaleidoscope'),
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
                  title: const Text('Breathing Pattern'),
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
                  title: const Text('Meditation duration (min)'),
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
                const ListTile(title: Text(
                  "Kaleidoscope and Binaural Beats are automatically enabled in AI mode and cannot be disabled.",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),),
              ],
            ),
            if (viewModel.deviceIsConfigured) ...[
              Padding(
                padding: _headlineInsets,
                child: Text(
                  viewModel.bluetoothSettingsHeading,
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
                      title: Text(viewModel.configuredDevice!.advName),
                      subtitle: Text(viewModel.configuredDevice!.macAddress),
                      trailing: TextButton(
                        onPressed: viewModel.unpairDevice,
                        child: Text(viewModel.unpairText),
                      ),
                    ),]),
            ],
            Padding(
              padding: _headlineInsets,
              child: Text(
                viewModel.userAccountSettingsHeading,
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
                    title: const Text("UUID"),
                    subtitle: Text(
                      viewModel.settings!.uuid,
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),]),
            const SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}
