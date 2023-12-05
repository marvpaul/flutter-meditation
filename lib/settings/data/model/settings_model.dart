import 'package:freezed_annotation/freezed_annotation.dart';
part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@unfreezed
class SettingsModel with _$SettingsModel {
  factory SettingsModel({
    @Default(false) bool isHapticFeedbackEnabled,
    @Default(false) bool shouldShowHeartRate,
    @Default(false) bool kaleidoscope,
    @Default('Option 1') String sound,
    @Default('4-7-8') String breathingPattern,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}
