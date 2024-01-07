/// {@category ViewModel}
/// View model for settings page. If the user changes setting in the view, they'll be changed in the model as well 
/// and finally saved to the local storage / shared preferences. 
library settings_page_view_model;

import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/settings/data/model/bluetooth_device_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/service/mi_band_bluetooth_service.dart';
import 'package:injectable/injectable.dart';
import '../../di/Setup.dart';
import '../data/repository/bluetooth_connection_repository.dart';
import '../data/repository/impl/settings_repository_local.dart';

/// ViewModel class for the Settings page.
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
  final String isBinauralBeatEnabledDisplayText = "Binaural Beats";
  String get kaleidoscopeImageName => _kaleidoscopeImageName;
  final String _kaleidoscopeImageName = "Kaleidoscope image";
  final String bluetoothName = "Bluetooth";
  final String bluetoothSettingsHeading = "Bluetooth Connection";
  final String unpairText = "Unpair";

  final String userAccountSettingsHeading = "Account Info";

  /// Initializes the ViewModel.
  /// We fetch the previously persisted settings and bluetooth configuration to display it in the settings view.
  @override
  Future<void> init() async {
    _settingsModel = await _settingsRepository.getSettings();
    notifyListeners();
    _isConfigured = _bluetoothRepository.isConfigured();
    if (_isConfigured) {
      _configuredDevice = _bluetoothRepository.getConfiguredDevice();
    }
    kaleidoscopeImageOptions = _settingsRepository.kaleidoscopeOptions ?? [];
    meditationDurationOptions =
        _settingsRepository.meditationDurationOptions ?? [];
    notifyListeners();
    print("uuid: ${settings?.uuid!}");
  }

  /// Toggles Haptic Feedback based on the provided value and persist to shared preferences.
  void toggleHapticFeedback(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.isHapticFeedbackEnabled = isEnabled;
      _saveSettingsAndNotify();
    }
  }

  /// Toggles whether Heart Rate should be displayed based on the provided value and persist to shared preferences.
  void toggleShouldShowHeartRate(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.shouldShowHeartRate = isEnabled;
      _saveSettingsAndNotify();
    }
  }

  /// Toggles Kaleidoscope visualization based on the provided value and persist to shared preferences.
  void toggleKaleidoscope(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.kaleidoscope = isEnabled;
      _saveSettingsAndNotify();
    }
  }

  /// Toggles Binaural Beats frequency based on the provided value  and persist to shared preferences.
  void toggleBinauralBeat(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.isBinauralBeatEnabled = isEnabled;
      _saveSettingsAndNotify();
    }
  }

  /// Changes a selected string value which corresponds to a list of possible options to choose from and persist to shared preferences.
  void changeList(String name, dynamic value) {
    if (_settingsModel != null) {
      if (name == 'Breathing pattern') {
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
      } else if (name == _kaleidoscopeImageName) {
        _settingsModel!.kaleidoscopeImage = value;
      } else if (name == 'Meditation duration') {
        _settingsModel!.meditationDuration = value;
      }
      _saveSettingsAndNotify();
    }
  }

  /// Updates the Bluetooth device configuration and select a paired fitness tracker.
  void chooseBluetoothDevice(BluetoothDeviceModel? bluetoothDevice) {
    if (bluetoothDevice != null) {
      _settingsModel?.pairedDevice = bluetoothDevice;
      _settingsRepository.saveSettings(_settingsModel!);
      notifyListeners();
    }
  }

  /// Unpairs the configured Bluetooth device / fitness tracker.
  void unpairDevice() {
    _bluetoothRepository.unpairDevice();
    _isConfigured = false;
    notifyListeners();
  }

  /// Saves the current settings and notifies listeners / update UI
  void _saveSettingsAndNotify() {
    if (_settingsModel != null) {
      _settingsRepository.saveSettings(_settingsModel!);
      notifyListeners();
    }
  }
}
