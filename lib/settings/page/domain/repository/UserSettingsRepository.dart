import '../entity/UserSettings.dart';

abstract class UserSettingsRepository {
  Stream<UserSettings> get userSettingsStream;
  changeHapticFeedbackUserSettings(bool isEnabled);
}