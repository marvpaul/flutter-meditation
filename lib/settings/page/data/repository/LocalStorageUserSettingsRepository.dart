import 'package:flutter_meditation/settings/page/data/localstorage/UserSettingsDataMapper.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/localstorage/domain/manager/LocalStorageManger.dart';
import '../../domain/entity/UserSettings.dart';
import '../../domain/repository/UserSettingsRepository.dart';
import '../localstorage/entity/UserSettingsDTO.dart';

class LocalStorageUserSettingsRepository implements UserSettingsRepository {

  @override
  Stream<UserSettings> get userSettingsStream => _userSettingsSubject.stream;
  final _userSettingsSubject = BehaviorSubject<UserSettings>();
  final LocalStorageManger localStorageManger;

  final String userSettingsKey = "userSettings";

  LocalStorageUserSettingsRepository(this.localStorageManger) {
    // localStorageManger.remove(userSettingsKey);
    _getUserSettings();
  }

  UserSettings _generateUserSettings() {
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

  _getUserSettings() async {
    final UserSettingsDTO? userSettingsDTO = await localStorageManger.retrieve<UserSettingsDTO>(userSettingsKey, (json) {
      return UserSettingsDTO.fromJson(json);
    });
    final UserSettings? userSettings = userSettingsDTO.toDomain();
    if (userSettings != null) {
      _userSettingsSubject.add(userSettings);
    } else {
      final UserSettings userSettings = _generateUserSettings();
      _updateUserSettings(userSettings);
    }
  }

  @override
  changeHapticFeedbackUserSettings(bool isEnabled) {
    UserSettings currentUserSettings = _userSettingsSubject.value.copyWith(
      meditationSettings: _userSettingsSubject.value.meditationSettings.copyWith(
        isHapticFeedbackEnabled: isEnabled,
      ),);
    _updateUserSettings(currentUserSettings);
  }

  _updateUserSettings(UserSettings userSettings) {
    final userSettingsDTO = userSettings.toData();
    localStorageManger.store<UserSettingsDTO>(userSettingsKey, userSettingsDTO);
    _userSettingsSubject.add(userSettings);
  }
}