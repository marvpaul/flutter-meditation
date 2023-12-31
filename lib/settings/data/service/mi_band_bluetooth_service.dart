import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_meditation/common/exception/bluetooth_device_not_configured_exception.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:injectable/injectable.dart';

import '../model/bluetooth_device_model.dart';
import '../repository/bluetooth_connection_repository.dart';
import '../repository/impl/settings_repository_local.dart';
import '../repository/settings_repository.dart';

@singleton
@injectable
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
  final SettingsRepository _settingsRepository;
  BluetoothCharacteristic? _triggerMeasurementCharacteristic;
  BluetoothCharacteristic? _currentHeartRateCharacteristic;
  BluetoothDevice? _bluetoothDevice;
  Timer? heartRatePingTimer;
  late SettingsModel _settingsModel;

  MiBandBluetoothService(this._settingsRepository);

  Future<void> _init() async {
    _settingsModel = await _settingsRepository.getSettings();
    if (_settingsModel.pairedDevice != null) {
      _bluetoothDevice =
          await _getDeviceByMacAddress(_settingsModel.pairedDevice!.macAddress);
    }
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
  Future<void> connectToDevice() async {
    _checkDeviceIsConfigured();
    return _bluetoothDevice!.connect();
  }

  Future<void> _disconnectFromDevice() async {
    _checkDeviceIsConfigured();
    return _bluetoothDevice!.disconnect();
  }

  Future<void> _searchForCharacteristics() async {
    _checkDeviceIsConfigured();
    List<BluetoothService> services =
        await _bluetoothDevice!.discoverServices();
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
    await _searchForCharacteristics();
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
    _checkDeviceIsConfigured();
    if (_bluetoothDevice != null) {
      return _bluetoothDevice!.connectionState.map((connectionState) {
        if (connectionState == BluetoothConnectionState.connected) {
          return MiBandConnectionState.connected;
        }
        return MiBandConnectionState.disconnected;
      });
    }
    return Stream<MiBandConnectionState>.fromIterable(
        [MiBandConnectionState.unavailable]);
  }

  Future<MiBandConnectionState> getStatus() async {
    Stream<MiBandConnectionState> connectionStateStream =
        await getConnectionState();
    return connectionStateStream.first;
  }

  void _checkDeviceIsConfigured() {
    if (_settingsModel.pairedDevice == null) {
      throw BluetoothDeviceNotConfiguredException();
    }
  }

  @override
  BluetoothDeviceModel? getConfiguredDevice(){
    return _settingsModel.pairedDevice;
  }

  @override
  bool isConfigured() {
    try {
      _checkDeviceIsConfigured();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Stream<int>> getHeartRate() async {
    await _searchForCharacteristics();
    await _triggerHeartRateMeasurement();
    await _currentHeartRateCharacteristic?.setNotifyValue(true);
    return _currentHeartRateCharacteristic!.onValueReceived
        .map((measurement) => getHR(measurement));
  }

  @override
  Future<void> stopHeartRateMeasurement() async {
    heartRatePingTimer?.cancel();
    await _triggerMeasurementCharacteristic
        ?.write(stopContinuousMeasurementPayload);
  }

  Future<void> _triggerHeartRateMeasurement() async {
    // stop heart monitor continuous & manual
    await _triggerMeasurementCharacteristic
        ?.write(stopContinuousMeasurementPayload);
    await _triggerMeasurementCharacteristic
        ?.write(stopManualMeasurementPayload);
    // start continuous tracking
    await _triggerMeasurementCharacteristic
        ?.write(startContinuousMeasurementPayload);

    heartRatePingTimer = Timer.periodic(const Duration(seconds: 12), (timer) {
      _triggerMeasurementCharacteristic
          ?.write(continuousMeasurementPingPayload);
    });
  }

  @override
  Future<void> unpairDevice() async {
    _checkDeviceIsConfigured();
    await _disconnectFromDevice();
    _settingsModel.pairedDevice = null;
    _settingsRepository.saveSettings(_settingsModel);
  }

  @override
  Future<void> setDevice(BluetoothDeviceModel bluetoothDevice) async {
    _settingsModel.pairedDevice = bluetoothDevice;
    _bluetoothDevice =
        await _getDeviceByMacAddress(_settingsModel.pairedDevice!.macAddress);
    _settingsRepository.saveSettings(_settingsModel);
  }

  static int getHR(List<int> values) {
    if (values.length > 1) {
      var binaryFlags = values[0].toRadixString(2);
      var flagUINT = binaryFlags[binaryFlags.length - 1];
      if (flagUINT == '0') {
        // UINT8 bpm
        return values[1];
      } else if (flagUINT == '1') {
        // UINT16 bpm
        var hr = values[1] + (values[2] << 8);
        return hr;
      } else {
        return -1;
      }
    } else {
      return -1;
    }
  }

  @factoryMethod
  static Future<MiBandBluetoothService> create(
      SettingsRepositoryLocal settings) async {
    MiBandBluetoothService bluetoothService = MiBandBluetoothService(settings);
    await bluetoothService._init();
    return bluetoothService;
  }

  @override
  bool isAvailableAndConnected() {
    if(isConfigured() && _bluetoothDevice != null){
      return _bluetoothDevice!.isConnected;
    }
    return false;
  }
}
