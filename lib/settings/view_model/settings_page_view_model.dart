import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/settings/data/model/bluetooth_device_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/service/mi_band_bluetooth_service.dart';
import 'package:injectable/injectable.dart';

import '../../di/Setup.dart';
import '../data/repository/bluetooth_connection_repository.dart';
import '../data/repository/impl/settings_repository_local.dart';
import '../data/repository/settings_repository.dart';

@injectable
class SettingsPageViewModel extends BaseViewModel {
  final SettingsRepositoryLocal _settingsRepository =
      getIt<SettingsRepositoryLocal>();
  final BluetoothConnectionRepository _bluetoothRepository =
      getIt<MiBandBluetoothService>();

  SettingsModel? get settings => _settingsModel;

  bool get deviceIsConfigured => _isConfigured;
  late bool _isConfigured;
  BluetoothDeviceModel? _configuredDevice;

  BluetoothDeviceModel? get configuredDevice => _configuredDevice;

  MiBandConnectionState get connectionState =>
      _connectionState ?? MiBandConnectionState.unavailable;
  MiBandConnectionState? _connectionState;

  SettingsModel? _settingsModel;
  List<String> soundOptions = <String>[
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];
  List<String> kaleidoscopeImageOptions = []; 
  List<int> meditationDurationOptions = [];
  List<String> breathingPatternOptions = <String>[
    BreathingPatternType.fourSevenEight.value,
    BreathingPatternType.box.value,
    BreathingPatternType.coherent.value,
    BreathingPatternType.oneTwo.value,
  ];

  String get hapticFeedbackName => _hapticFeedbackName;
  final String _hapticFeedbackName = "Haptic Feedback";
  String get heartRateName => _heartRateName;
  final String _heartRateName = "Heart Rate";
  String get soundName => _soundName;
  final String _soundName = "Sound";
  String get kaleidoscopeImageName => _kaleidoscopeImageName;
  final String _kaleidoscopeImageName = "Kaleidoscope image";
  final String bluetoothName = "Bluetooth";
  final String bluetoothSettingsHeading = "Bluetooth connection";
  final String unpairText = "Unpair";

  final String aiOptimizationHeading = "AI Info";

  @override
  Future<void> init() async {
    _settingsModel = await _settingsRepository.getSettings();
    notifyListeners();
    _isConfigured = _bluetoothRepository.isConfigured();
    if (_isConfigured) {
      _configuredDevice = _bluetoothRepository.getConfiguredDevice();
    }
    kaleidoscopeImageOptions = _settingsRepository.kaleidoscopeOptions??[];
    meditationDurationOptions = _settingsRepository.meditationDurationOptions??[];
    notifyListeners();
    print("uuid: ${settings?.uuid!}");
  }

  void toggleHapticFeedback(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.isHapticFeedbackEnabled = isEnabled;
      _saveSettingsAndNotify();
    }
  }

  void toggleShouldShowHeartRate(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.shouldShowHeartRate = isEnabled;
      _saveSettingsAndNotify();
    }
  }

  void toggleKaleidoscope(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.kaleidoscope = isEnabled;
      _saveSettingsAndNotify();
    }
  }

  void changeList(String name, dynamic value) {
    if (_settingsModel != null) {
      if (name == _soundName) {
        _settingsModel!.sound = value;
      } else if (name == 'Breathing pattern') {
        if (value == '4-7-8') {
          _settingsModel!.breathingPattern =
              BreathingPatternType.fourSevenEight;
        } else if (value == '1:2') {
          _settingsModel!.breathingPattern = BreathingPatternType.oneTwo;
        } else if (value == 'Coherent') {
          _settingsModel!.breathingPattern = BreathingPatternType.coherent;
        } else if (value == 'Box') {
          _settingsModel!.breathingPattern = BreathingPatternType.box;
        }
      } else if (name == kaleidoscopeImageName) {
        _settingsModel!.kaleidoscopeImage = value;
        print("Set image to" + name);
      } else if (name == 'Meditation duration') {
        _settingsModel!.meditationDuration = value;
      }
      _saveSettingsAndNotify();
    }
  }

  void chooseBluetoothDevice(BluetoothDeviceModel? bluetoothDevice) {
    if (bluetoothDevice != null) {
      _settingsModel?.pairedDevice = bluetoothDevice;
      _settingsRepository.saveSettings(_settingsModel!);
      notifyListeners();
    }
  }

  void unpairDevice() {
    _bluetoothRepository.unpairDevice();
    _isConfigured = false;
    notifyListeners();
  }

  void _saveSettingsAndNotify() {
    if (_settingsModel != null) {
      _settingsRepository.saveSettings(_settingsModel!);
      notifyListeners();
    }
  }
}
