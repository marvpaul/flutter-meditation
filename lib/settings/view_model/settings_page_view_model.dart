import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:injectable/injectable.dart';

import '../../di/Setup.dart';
import '../data/repository/impl/settings_repository_local.dart';
import '../data/repository/settings_repository.dart';

@injectable
class SettingsPageViewModel extends BaseViewModel {
  SettingsModel? get settings => _settingsModel;
  SettingsModel? _settingsModel;
  final SettingsRepository _settingsRepository =
      getIt<SettingsRepositoryLocal>();

  List<String> soundOptions = <String>[
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];
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

  @override
  Future<void> init() async {
    _settingsModel = await _settingsRepository.getSettings();
    notifyListeners();
  }

  toggleHapticFeedback(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.isHapticFeedbackEnabled = isEnabled;
      _saveSettingsAndNotify();
    }
  }

  toggleShouldShowHeartRate(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.shouldShowHeartRate = isEnabled;
      _saveSettingsAndNotify();
    }
  }

  toggleKaleidoscope(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.kaleidoscope = isEnabled;
      _saveSettingsAndNotify();
    }
  }

  changeList(String name, String value) {
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
      }
      _saveSettingsAndNotify();
    }
  }

  void _saveSettingsAndNotify() {
    if (_settingsModel != null) {
      _settingsRepository.saveSettings(_settingsModel!);
      notifyListeners();
    }
  }
}
