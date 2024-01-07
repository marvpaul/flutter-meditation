/// {@category Model}
/// An immutable representation of user settings for the meditation app.
library settings_model;
import 'package:flutter_meditation/settings/data/model/bluetooth_device_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

/// An mutable representation of user settings for the meditation app.
@unfreezed
class SettingsModel with _$SettingsModel {
  /// Named constructor for creating an instance of SettingsModel.
  ///
  /// [isHapticFeedbackEnabled]: Flag indicating whether haptic feedback is enabled. Default is `false`.
  /// [shouldShowHeartRate]: Flag indicating whether to display heart rate during meditation. Default is `false`.
  /// [kaleidoscope]: Flag indicating whether the kaleidoscope visualization is enabled. Default is `true`.
  /// [kaleidoscopeImage]: The image used for the kaleidoscope visualization. Default is `"Arctic"` which corrensponds to an image in the asset folder. 
  /// [isBinauralBeatEnabled]: Flag indicating whether binaural beats are enabled. Default is `true`.
  /// [binauralBeatFrequency]: The frequency of binaural beats. Default is `30`.
  /// [meditationDuration]: The default duration for meditation sessions. Default is `2` minutes.
  /// [pairedDevice]: The paired Bluetooth device / fitness tracker. Default is `null`.
  /// [uuid]: The UUID associated with the user for restore meditation data on another device.
  /// [breathingPattern]: The default breathing pattern. Default is `4-7-8`.
  factory SettingsModel({
    @Default(false) bool isHapticFeedbackEnabled,
    @Default(false) bool shouldShowHeartRate,
    @Default(true) bool kaleidoscope,
    @Default("Arctic") String kaleidoscopeImage,
    @Default(true) bool isBinauralBeatEnabled,
    @Default(30) int binauralBeatFrequency,
    @Default(2) int meditationDuration,
    BluetoothDeviceModel? pairedDevice,
    required String uuid,
    @Default(BreathingPatternType.fourSevenEight) BreathingPatternType breathingPattern,
  }) = _SettingsModel;

  /// Factory constructor for creating an instance from JSON.
  ///
  /// [json]: A JSON map representing the user settings.
  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}
