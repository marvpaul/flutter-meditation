import 'dart:convert';

import 'package:flutter_meditation/settings/data/dto/settings_dto.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/settings/data/repository/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SettingsRepositoryLocal', () {
    late MockSharedPreferences mockSharedPreferences;
    late SettingsRepositoryLocal settingsRepository;
    late SettingsModel settingsHapticFeedbackEnabled;
    late String settingsJSONHapticFeedbackEnabled;
    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      settingsRepository = SettingsRepositoryLocal(mockSharedPreferences);
      settingsHapticFeedbackEnabled = SettingsModel(isHapticFeedbackEnabled: true, uuid: '123');
      settingsJSONHapticFeedbackEnabled = JsonEncoder().convert(SettingsDTO(settings: settingsHapticFeedbackEnabled).toJson());
    });

    test('getSettings - should return default settings when no settings are stored', () async {
      // Stub the `getString` and `setString` methods.
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) => Future(() => true));

      final result = await settingsRepository.getSettings();
      expect(result.isHapticFeedbackEnabled, SettingsModel(uuid: '123').isHapticFeedbackEnabled);
      // verify default settings are saved
      verify(() => mockSharedPreferences.setString('settings', any())).called(1);
    });

    test('getSettings - should return saved settings', () async {
      // Stub the `getString` method.
      when(() => mockSharedPreferences.getString('settings')).thenReturn(settingsJSONHapticFeedbackEnabled);

      final result = await settingsRepository.getSettings();
      expect(result.isHapticFeedbackEnabled, settingsHapticFeedbackEnabled.isHapticFeedbackEnabled);
      // saveSettings shouldn't be called, because they are already stored
      verifyNever(() => mockSharedPreferences.setString(any(), any()));
    });

    test('getSettings - should return saved settings', () async {
      // Stub the `getString` method.
      when(() => mockSharedPreferences.getString('settings')).thenReturn(settingsJSONHapticFeedbackEnabled);

      final result = await settingsRepository.getSettings();
      expect(result.isHapticFeedbackEnabled, settingsHapticFeedbackEnabled.isHapticFeedbackEnabled);
      // saveSettings shouldn't be called, because they are already stored
      verifyNever(() => mockSharedPreferences.setString(any(), any()));
    });

    test('restore settings to default', () async {
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) => Future(() => true));
      settingsRepository.restoreSettings();
      verify(() => mockSharedPreferences.setString(SettingsRepository.settingsKey, any())).called(1);
    });

  });
}