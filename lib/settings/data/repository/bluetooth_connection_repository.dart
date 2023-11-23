import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_meditation/settings/data/model/bluetooth_device_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';

abstract class BluetoothConnectionRepository{


  Future<void> init();
  /// Retrieve a list of devices currently connected to the system
  /// - The list includes devices connected to by *any* app
  /// - You must still call device.connect() to connect them to *your app*
  Future<List<BluetoothDeviceModel>> getSystemDevices();

  Future<bool> isBluetoothEnabled();

  Future<bool> isSupportingHeartRateTracking(BluetoothDevice bluetoothDevice);

  Future<void> connectToDevice(BluetoothDeviceModel bluetoothDevice);

  Future<Stream<MiBandConnectionState>?> getConnectionState();

  bool isConfigured();

  BluetoothDeviceModel? getConfiguredDevice();

}

enum MiBandConnectionState {
  disconnected, // connected to meditation app
  connected,  // disconnected from meditation app
  unavailable, // not connected to vendor app
  unconfigured // no device was chosen in meditation app
}