import 'package:rxdart/rxdart.dart';

import '../../domain/entity/UserSettings.dart';
import '../../domain/repository/UserSettingsRepository.dart';

class LocalStorageUserSettingsRepository implements UserSettingsRepository {

  @override
  Stream<UserSettings> get userSettingsStream => _userSettingsSubject.stream;
  final _userSettingsSubject = BehaviorSubject<UserSettings>();

  LocalStorageUserSettingsRepository() {
    _userSettingsSubject.add(_getUserSettings());
  }

  UserSettings _getUserSettings() {
    return UserSettings(
      meditationSettings: MeditationSettings(
        isHapticFeedbackEnabled: true,
      ),
      meditationInfo: MeditationInfo(
        shouldShowHeartRate: true,
        shouldShowTime: true,
      ),
    );
  }

  @override
  changeHapticFeedbackUserSettings(bool isEnabled) {
    UserSettings currentUserSettings = _userSettingsSubject.value.copyWith(
      meditationSettings: _userSettingsSubject.value.meditationSettings.copyWith(
        isHapticFeedbackEnabled: isEnabled,
      ),);
    _userSettingsSubject.add(currentUserSettings);
  }
}