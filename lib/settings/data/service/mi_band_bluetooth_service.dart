/// {@category Service}
/// Service to connect to a MiBand 3 / 4 using a bluetooth connection to retrieve real-time heart rate data.
/// Note: You need to first add the MiBand using a separeted app called "Zapp"
library mi_band_bluetooth_service;
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_meditation/common/exception/bluetooth_device_not_configured_exception.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:injectable/injectable.dart';
import '../model/bluetooth_device_model.dart';
import '../repository/bluetooth_connection_repository.dart';
import '../repository/impl/settings_repository_local.dart';
import '../repository/settings_repository.dart';

/// Service to connect to a MiBand 3 / 4 using a bluetooth connection to retrieve real-time heart rate data.
/// Note: You need to first add the MiBand using a separeted app called "Zapp"
@singleton
@injectable
class MiBandBluetoothService implements BluetoothConnectionRepository {
  final Guid heartRateService = Guid("0000180d-0000-1000-8000-00805f9b34fb");
  final Guid heartRateMeasurementCharacteristic =
      Guid("00002a37-0000-1000-8000-00805f9b34fb");
  final Guid heartRateControlCharacteristic =
      Guid("00002a39-0000-1000-8000-00805f9b34fb");

  // Hex values which stand for specific commands / actions.
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

  // Initializes the service. Fetching the users setting and get if he selected a device to connect to.
  Future<void> _init() async {
    _settingsModel = await _settingsRepository.getSettings();
    if (_settingsModel.pairedDevice != null) {
      _bluetoothDevice =
          await _getDeviceByMacAddress(_settingsModel.pairedDevice!.macAddress);
    }
  }

  /// Gets a list of Bluetooth devices available in the system.
  /// For every device we'll detect, we create a new [BluetoothDeviceModel].
  @override
  Future<List<BluetoothDeviceModel>> getSystemDevices() async {
    List<BluetoothDeviceModel> systemDevices = [];
    for (BluetoothDevice device in await FlutterBluePlus.systemDevices) {
      systemDevices.add(BluetoothDeviceModel(
          macAddress: device.remoteId.str, advName: device.platformName));
    }
    return systemDevices;
  }

  /// Return true if bluetooth is enabled on the actual device.
  /// Note: The user may also need to give permission in order to use bluetooth within our app.
  @override
  Future<bool> isBluetoothEnabled() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  /// Connects to the configured Bluetooth device.
  @override
  Future<void> connectToDevice() async {
    _checkDeviceIsConfigured();
    return _bluetoothDevice!.connect();
  }

  /// Disconnects from the configured Bluetooth device.
  Future<void> _disconnectFromDevice() async {
    _checkDeviceIsConfigured();
    return _bluetoothDevice!.disconnect();
  }

  /// Searches for Bluetooth characteristics related to heart rate tracking.
  /// We need to first filter from a list of running services to find our [heartRateService].
  /// If we found the service, we check for our previously defined [service.characteristics]
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

  /// Checks if the configured Bluetooth device supports heart rate tracking.
  /// Note: We tested on MiBand 3 and 4 which both support this feature.
  @override
  Future<bool> isSupportingHeartRateTracking(
      BluetoothDevice bluetoothDevice) async {
    await _searchForCharacteristics();
    return _triggerMeasurementCharacteristic != null &&
        _currentHeartRateCharacteristic != null;
  }

  /// Gets a Bluetooth device using its MAC address.
  Future<BluetoothDevice?> _getDeviceByMacAddress(String macAddress) async {
    for (BluetoothDevice device in await FlutterBluePlus.systemDevices) {
      if (device.remoteId.str == macAddress) {
        return device;
      }
    }
    return null;
  }

  /// Gets the connection state as a stream of [MiBandConnectionState].
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

  /// Gets the current connection status.
  Future<MiBandConnectionState> getStatus() async {
    Stream<MiBandConnectionState> connectionStateStream =
        await getConnectionState();
    return connectionStateStream.first;
  }

  /// Checks if the configured device is available and connected.
  void _checkDeviceIsConfigured() {
    if (_settingsModel.pairedDevice == null) {
      throw BluetoothDeviceNotConfiguredException();
    }
  }

  /// Checks if the device is configured.
  @override
  BluetoothDeviceModel? getConfiguredDevice() {
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

  /// Gets the heart rate as a stream of integers.
  /// Note: we usually receive a measurement every 3 seconds but this time may vary.
  /// Also it happens a lot that it takes some extra seconds to receive the first data point when we just start our measurement.
  @override
  Future<Stream<int>> getHeartRate() async {
    await _searchForCharacteristics();
    await _triggerHeartRateMeasurement();
    await _currentHeartRateCharacteristic?.setNotifyValue(true);
    return _currentHeartRateCharacteristic!.onValueReceived
        .map((measurement) => getHR(measurement));
  }

  /// Stops continuous heart rate measurement.
  @override
  Future<void> stopHeartRateMeasurement() async {
    heartRatePingTimer?.cancel();
    await _triggerMeasurementCharacteristic
        ?.write(stopContinuousMeasurementPayload);
  }

  /// Triggers heart rate measurement.
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

  /// Unpairs the configured Bluetooth device.
  /// The user can do this in the app settings.
  @override
  Future<void> unpairDevice() async {
    _checkDeviceIsConfigured();
    await _disconnectFromDevice();
    _settingsModel.pairedDevice = null;
    _settingsRepository.saveSettings(_settingsModel);
  }

  /// Sets the configured Bluetooth device.
  /// The user selects this when the app is started the first time.
  @override
  Future<void> setDevice(BluetoothDeviceModel bluetoothDevice) async {
    _settingsModel.pairedDevice = bluetoothDevice;
    _bluetoothDevice =
        await _getDeviceByMacAddress(_settingsModel.pairedDevice!.macAddress);
    _settingsRepository.saveSettings(_settingsModel);
  }

  /// Converts the received characteristics values to actual heart rate.
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
    if (isConfigured() && _bluetoothDevice != null) {
      return _bluetoothDevice!.isConnected;
    }
    return false;
  }
}
