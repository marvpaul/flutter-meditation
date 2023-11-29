import 'package:flutter_meditation/base/base_view_model.dart';
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
        _saveSettingsAndNotify();
      }
    }
  }
  
  void _saveSettingsAndNotify(){
    if (_settingsModel != null) {
        _settingsRepository.saveSettings(_settingsModel!);
        notifyListeners();
    }
  }
}
