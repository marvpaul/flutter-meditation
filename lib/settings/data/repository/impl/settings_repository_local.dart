/// {@category Repository}
/// A local implementation of the [SettingsRepository] using shared preferences to help storing and loading user settings.
library settings_repository_local;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../dto/settings_dto.dart';
import '../settings_repository.dart';

/// A local implementation of the [SettingsRepository] using shared preferences to help storing and loading user settings.
@singleton
class SettingsRepositoryLocal implements SettingsRepository {
  /// Instance of SharedPreferences to manage local storage.
  final SharedPreferences prefs;

  /// List of kaleidoscope visualization options. These options correspond to images in the asset folder
  /// which will be loaded and processed at runtime using a fragment shader.
  @override
  List<String>? kaleidoscopeOptions = [
    'Arctic',
    'Aurora',
    'Circle',
    'City',
    'Golden',
    'Japan',
    'Metropolis',
    'Nature',
    'Plants',
    'Skyline'
  ];

  /// List of meditation duration options in minutes.
  @override
  List<int>? meditationDurationOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  SettingsRepositoryLocal(this.prefs);

  /// Retrieves the user settings from local storage.
  ///
  /// Returns a [SettingsModel] instance representing the user's settings.
  @override
  Future<SettingsModel> getSettings() async {
    final String? settingsJson =
        prefs.getString(SettingsRepository.settingsKey);
    if (settingsJson != null) {
      debugPrint(settingsJson);
      return SettingsDTO.fromJson(JsonDecoder().convert(settingsJson)).settings;
    }
    SettingsModel settingsModel = SettingsModel(uuid: _generateUUID());
    saveSettings(settingsModel);
    // Return default if no configuration was found.
    return settingsModel;
  }

  /// Saves the user settings to local storage.
  ///
  /// [settings]: The [SettingsModel] instance to be saved.
  @override
  void saveSettings(SettingsModel settings) {
    final String settingsJson =
        JsonEncoder().convert(SettingsDTO(settings: settings).toJson());
    prefs.setString(SettingsRepository.settingsKey, settingsJson);
  }

  /// Restores default settings and save to local storage.
  ///
  /// This method saves a new [SettingsModel] instance with a generated UUID as the default settings.
  @override
  void restoreSettings() {
    saveSettings(SettingsModel(uuid: _generateUUID()));
  }

  /// Generates a UUID (Universally Unique Identifier).
  ///
  /// Returns a String representation of the generated UUID.
  String _generateUUID() {
    Uuid uuid = Uuid();
    return uuid.v4();
  }

  /// Retrieves the device ID / UUID associated with the user settings.
  ///
  /// Returns a [Future] containing the device ID as a String.
  @override
  Future<String> getDeviceId() async {
    SettingsModel settings = await getSettings();
    return settings.uuid;
  }
}
