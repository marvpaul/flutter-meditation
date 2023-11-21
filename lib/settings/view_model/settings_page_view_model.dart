import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../di/Setup.dart';
import '../data/repository/impl/settings_repository_local.dart';
import '../data/repository/settings_repository.dart';

@injectable
class SettingsPageViewModel extends BaseViewModel {
  var settingsSubject = PublishSubject<SettingsModel>();
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
  }

  toggleHapticFeedback(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.isHapticFeedbackEnabled = isEnabled;
      notifyListeners();
    }
  }

  toggleshouldShowHeartRate(bool isEnabled) {
    if (_settingsModel != null) {
      _settingsModel!.shouldShowHeartRate = isEnabled;
      notifyListeners();
    }
  }

  changeList(String name, String value) {
    if (_settingsModel != null) {
      if (name == "Sound") {
        _settingsModel!.sound = value;
        notifyListeners();
      }
    }
  }
}
