import 'package:freezed_annotation/freezed_annotation.dart';

part 'bluetooth_device_model.freezed.dart';

part 'bluetooth_device_model.g.dart';

@unfreezed
class BluetoothDeviceModel with _$BluetoothDeviceModel {
  factory BluetoothDeviceModel(
      {required String macAddress,
      required String advName}) = _BluetoothDeviceModel;

  factory BluetoothDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$BluetoothDeviceModelFromJson(json);

}
