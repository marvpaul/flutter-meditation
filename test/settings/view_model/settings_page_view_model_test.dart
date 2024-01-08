import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/settings/data/service/mi_band_bluetooth_service.dart';
import 'package:flutter_meditation/settings/view_model/settings_page_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSettingsRepositoryLocal extends Mock
    implements SettingsRepositoryLocal {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockBluetoothService extends Mock implements MiBandBluetoothService {}

void main() async {
  late MockSharedPreferences mockSharedPreferences;
  late MockSettingsRepositoryLocal mockSettingsRepository;
  late MockBluetoothService mockBluetoothService;
  late SettingsPageViewModel viewModel;
  late SettingsModel settings;

  setUpAll(() async {
    mockSharedPreferences = MockSharedPreferences();
    getIt.registerSingleton<SharedPreferences>(mockSharedPreferences);
    mockSettingsRepository = MockSettingsRepositoryLocal();
    getIt.registerSingleton<SettingsRepositoryLocal>(mockSettingsRepository);
    mockBluetoothService = MockBluetoothService();
    getIt.registerSingleton<MiBandBluetoothService>(mockBluetoothService);

    viewModel = SettingsPageViewModel();
    settings =
        SettingsModel(isHapticFeedbackEnabled: true, uuid: '123');
  });

  group('SettingsPageViewModel', () {
    test('initialize view model', () async {
      expect(viewModel.settings, null);
      when(() => mockSettingsRepository.getSettings())
          .thenAnswer((_) => Future(() => settings));
      when(() => mockBluetoothService.isConfigured()).thenAnswer((_) => true);
      await viewModel.init();
      expect(viewModel.settings, settings);
    });
    test('change settings', () async {
      when(() => mockSettingsRepository.getSettings())
          .thenAnswer((_) => Future(() => settings));
      when(() => mockBluetoothService.isConfigured()).thenAnswer((_) => true);
      await viewModel.init();

      viewModel.toggleHapticFeedback(false);
      expect(viewModel.settings!.isHapticFeedbackEnabled, false);
      viewModel.toggleHapticFeedback(true);
      expect(viewModel.settings!.isHapticFeedbackEnabled, true);

      viewModel.toggleKaleidoscope(false);
      expect(viewModel.settings!.kaleidoscope, false);
      viewModel.toggleKaleidoscope(true);
      expect(viewModel.settings!.kaleidoscope, true);
      viewModel.toggleKaleidoscope(false);
      
      viewModel.toggleShouldShowHeartRate(false);
      expect(viewModel.settings!.shouldShowHeartRate, false);
      viewModel.toggleShouldShowHeartRate(true);
      expect(viewModel.settings!.shouldShowHeartRate, true);

      viewModel.toggleBinauralBeat(false);
      expect(viewModel.settings!.isBinauralBeatEnabled, false);
      viewModel.toggleBinauralBeat(true);
      expect(viewModel.settings!.isBinauralBeatEnabled, true);


      viewModel.changeList("Breathing pattern", '4-7-8');
      expect(viewModel.settings!.breathingPattern, BreathingPatternType.fourSevenEight);
      viewModel.changeList("Breathing pattern", '1:2');
      expect(viewModel.settings!.breathingPattern, BreathingPatternType.oneTwo);
      viewModel.changeList("Breathing pattern", 'Box');
      expect(viewModel.settings!.breathingPattern, BreathingPatternType.box);
      viewModel.changeList("Breathing pattern", 'Coherent');
      expect(viewModel.settings!.breathingPattern, BreathingPatternType.coherent);
      viewModel.changeList(viewModel.kaleidoscopeImageName, 'Arctic');
      expect(viewModel.settings!.kaleidoscopeImage, 'Arctic');
      viewModel.changeList('Meditation duration', 10);
      expect(viewModel.settings!.meditationDuration, 10);
    });
  });
}
