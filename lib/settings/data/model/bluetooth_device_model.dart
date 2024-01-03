import 'package:freezed_annotation/freezed_annotation.dart';
part 'bluetooth_device_model.freezed.dart';
part 'bluetooth_device_model.g.dart';

/// An immutable representation of a Bluetooth device / fitness tracker which we use to retreive real-time heart rate data.
@freezed
class BluetoothDeviceModel with _$BluetoothDeviceModel {
  /// Named constructor for creating an instance of BluetoothDeviceModel.
  ///
  /// [macAddress]: The MAC address of the Bluetooth device.
  /// [advName]: The advertising name of the Bluetooth device.
  factory BluetoothDeviceModel({
    required String macAddress,
    required String advName,
  }) = _BluetoothDeviceModel;

  /// Factory constructor for creating an instance from JSON.
  ///
  /// [json]: A JSON map representing the Bluetooth device.
  factory BluetoothDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$BluetoothDeviceModelFromJson(json);
}
