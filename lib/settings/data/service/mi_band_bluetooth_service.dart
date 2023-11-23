import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:injectable/injectable.dart';

import '../../../di/Setup.dart';
import '../model/bluetooth_device_model.dart';
import '../repository/bluetooth_connection_repository.dart';
import '../repository/impl/settings_repository_local.dart';
import '../repository/settings_repository.dart';

@injectable
@singleton
class MiBandBluetoothService implements BluetoothConnectionRepository {
  final Guid heartRateService = Guid("0000180d-0000-1000-8000-00805f9b34fb");
  final Guid heartRateMeasurementCharacteristic =
      Guid("00002a37-0000-1000-8000-00805f9b34fb");
  final Guid heartRateControlCharacteristic =
      Guid("00002a39-0000-1000-8000-00805f9b34fb");
  final List<int> stopManualMeasurementPayload = [0x15, 0x2, 0x0];
  final List<int> stopContinuousMeasurementPayload = [0x15, 0x1, 0x0];
  final List<int> startContinuousMeasurementPayload = [0x15, 0x1, 0x1];
  final List<int> continuousMeasurementPingPayload = [0x16];
  final SettingsRepository _settingsRepository =
  getIt<SettingsRepositoryLocal>();
  BluetoothCharacteristic? _triggerMeasurementCharacteristic;
  BluetoothCharacteristic? _currentHeartRateCharacteristic;
  BluetoothDeviceModel? _bluetoothDevice;

  @override
  Future<void> init() async {
    SettingsModel? settings = await _settingsRepository.getSettings();
    _bluetoothDevice = settings?.pairedDevice;
  }

  @override
  Future<List<BluetoothDeviceModel>> getSystemDevices() async {
    List<BluetoothDeviceModel> systemDevices = [];
    for (BluetoothDevice device in await FlutterBluePlus.systemDevices) {
      systemDevices.add(BluetoothDeviceModel(
          macAddress: device.remoteId.str, advName: device.platformName));
    }
    return systemDevices;
  }

  @override
  Future<bool> isBluetoothEnabled() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  @override
  Future<void> connectToDevice(BluetoothDeviceModel bluetoothDevice) async {
    BluetoothDevice? device = await _getDeviceByMacAddress(bluetoothDevice.macAddress);
    if(device != null){
      return device.connect();
    }
  }

  Future<void> _searchForCharacteristics(
      BluetoothDevice bluetoothDevice) async {
    List<BluetoothService> services = await bluetoothDevice.discoverServices();
    for (BluetoothService service in services) {
      if (service.serviceUuid == heartRateService) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.characteristicUuid ==
              heartRateMeasurementCharacteristic) {
            _currentHeartRateCharacteristic = characteristic;
          } else if (characteristic.characteristicUuid ==
              heartRateControlCharacteristic) {
            _triggerMeasurementCharacteristic = characteristic;
          }
        }
      }
    }
  }

  @override
  Future<bool> isSupportingHeartRateTracking(
      BluetoothDevice bluetoothDevice) async {
    await _searchForCharacteristics(bluetoothDevice);
    return _triggerMeasurementCharacteristic != null &&
        _currentHeartRateCharacteristic != null;
  }

  Future<BluetoothDevice?> _getDeviceByMacAddress(String macAddress) async {
    for (BluetoothDevice device in await FlutterBluePlus.systemDevices) {
      if (device.remoteId.str == macAddress) {
        return device;
      }
    }
    return null;
  }

  @override
  Future<Stream<MiBandConnectionState>> getConnectionState() async {
    if(_bluetoothDevice == null) {
      return Stream<MiBandConnectionState>.fromIterable([MiBandConnectionState.unconfigured]);
    }
    BluetoothDevice? device = await _getDeviceByMacAddress(_bluetoothDevice!.macAddress);
    if(device != null){
      return device.connectionState.map((connectionState) {
        debugPrint(connectionState.name);
        if(connectionState == BluetoothConnectionState.connected){
          return MiBandConnectionState.connected;
        }
        return MiBandConnectionState.disconnected;
      });
    }
    debugPrint("device is null");
    return Stream<MiBandConnectionState>.fromIterable([MiBandConnectionState.unavailable]);
  }

  @override
  bool isConfigured() {
    return _bluetoothDevice != null;
  }

  @override
  BluetoothDeviceModel? getConfiguredDevice() {
    return _bluetoothDevice;
  }
}

