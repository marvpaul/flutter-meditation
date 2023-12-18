import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/bluetooth_connection_repository.dart';
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
  late SettingsModel settingsHapticFeedbackEnabled;

  setUpAll(() async {
    mockSharedPreferences = MockSharedPreferences();
    getIt.registerSingleton<SharedPreferences>(mockSharedPreferences);
    mockSettingsRepository = MockSettingsRepositoryLocal();
    getIt.registerSingleton<SettingsRepositoryLocal>(mockSettingsRepository);
    mockBluetoothService = MockBluetoothService();
    getIt.registerSingleton<MiBandBluetoothService>(mockBluetoothService);

    viewModel = SettingsPageViewModel();
    settingsHapticFeedbackEnabled =
        SettingsModel(isHapticFeedbackEnabled: true);
  });

  group('SettingsPageViewModel', () {
    test('initialize view model', () async {
      expect(viewModel.settings, null);
      when(() => mockSettingsRepository.getSettings())
          .thenAnswer((_) => Future(() => settingsHapticFeedbackEnabled));
      when(() => mockBluetoothService.isConfigured()).thenAnswer((_) => true);
      await viewModel.init();
      expect(viewModel.settings, settingsHapticFeedbackEnabled);
    });
  });
}
