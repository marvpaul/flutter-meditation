import '../repository/UserSettingsRepository.dart';

class ChangeHapticFeedbackUserSettingsUseCase {
  final UserSettingsRepository _userSettingsRepository;

  ChangeHapticFeedbackUserSettingsUseCase(this._userSettingsRepository);

  execute(bool isEnabled) {
    return _userSettingsRepository.changeHapticFeedbackUserSettings(isEnabled);
  }
}
