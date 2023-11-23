import 'package:flutter_meditation/settings/data/model/bluetooth_device_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@unfreezed
class SettingsModel with _$SettingsModel {
  factory SettingsModel({
    @Default(false) bool isHapticFeedbackEnabled,
    @Default(false) bool shouldShowHeartRate,
    @Default('Option 1') String sound,
    BluetoothDeviceModel? pairedDevice,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}
