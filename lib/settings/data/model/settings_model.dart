import 'package:flutter_meditation/settings/data/model/bluetooth_device_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@unfreezed
class SettingsModel with _$SettingsModel {
  factory SettingsModel({
    @Default(false) bool isHapticFeedbackEnabled,
    @Default(false) bool shouldShowHeartRate,
    @Default(true) bool kaleidoscope,
    @Default("Arctic") String kaleidoscopeImage,
    @Default(30) int binauralBeatFrequency,
    @Default(2) int meditationDuration,
    @Default('Option 1') String sound,
    BluetoothDeviceModel? pairedDevice,
    String? uuid,
    @Default(0) int trainedDataPoints,
    @Default(BreathingPatternType.fourSevenEight) BreathingPatternType breathingPattern,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}
