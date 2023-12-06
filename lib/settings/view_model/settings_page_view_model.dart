import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/settings/data/model/bluetooth_device_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/service/mi_band_bluetooth_service.dart';
import 'package:injectable/injectable.dart';

import '../../di/Setup.dart';
import '../data/repository/bluetooth_connection_repository.dart';
import '../data/repository/impl/settings_repository_local.dart';
import '../data/repository/settings_repository.dart';

@injectable
class SettingsPageViewModel extends BaseViewModel {
  final SettingsRepository _settingsRepository =
      getIt<SettingsRepositoryLocal>();
  final BluetoothConnectionRepository _bluetoothRepository =
      getIt<MiBandBluetoothService>();

  SettingsModel? get settings => _settingsModel;

  bool get deviceIsConfigured => _isConfigured ;
  late bool _isConfigured;
  BluetoothDeviceModel? _configuredDevice;

  BluetoothDeviceModel? get configuredDevice => _configuredDevice;

  MiBandConnectionState get connectionState => _connectionState ?? MiBandConnectionState.unavailable;
  MiBandConnectionState? _connectionState;

  SettingsModel? _settingsModel;
  List<String> soundOptions = <String>[
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];

  String get hapticFeedbackName => _hapticFeedbackName;
  final String _hapticFeedbackName = "Haptic Feedback";

  String get heartRateName => _heartRateName;
  final String _heartRateName = "Heart Rate";

  String get soundName => _soundName;
  final String _soundName = "Sound";
  final String bluetoothName = "Bluetooth";
  final String bluetoothSettingsHeading = "Bluetooth connection";
  final String unpairText = "Unpair";

  @override
  Future<void> init() async {
    _settingsModel = await _settingsRepository.getSettings();
    _isConfigured = _bluetoothRepository.isConfigured();
    if(_isConfigured){
      _configuredDevice = _bluetoothRepository.getConfiguredDevice();
    }
    notifyListeners();
  }

  void toggleHapticFeedback(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.isHapticFeedbackEnabled = isEnabled;
      _settingsRepository.saveSettings(_settingsModel!);
      notifyListeners();
    }
  }

  void toggleShouldShowHeartRate(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.shouldShowHeartRate = isEnabled;
      notifyListeners();
      _settingsRepository.saveSettings(_settingsModel!);
    }
  }

  void changeList(String name, String value) {
    if (_settingsModel != null) {
      if (name == soundName) {
        _settingsModel!.sound = value;
        notifyListeners();
        _settingsRepository.saveSettings(_settingsModel!);
      }
    }
  }

  void chooseBluetoothDevice(BluetoothDeviceModel? bluetoothDevice) {
    if (bluetoothDevice != null) {
      _settingsModel?.pairedDevice = bluetoothDevice;
      _settingsRepository.saveSettings(_settingsModel!);
      notifyListeners();
    }
  }

  void unpairDevice(){
    _bluetoothRepository.unpairDevice();
    _isConfigured = false;
    notifyListeners();
  }
}
