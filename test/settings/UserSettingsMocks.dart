import 'package:flutter_meditation/settings/page/domain/entity/UserSettings.dart';

extension UserSettingsMock on UserSettings {
  static UserSettings mock({
    MeditationInfo? meditationInfo,
    MeditationSettings? meditationSettings,
  }) {
    return UserSettings(
        meditationInfo: meditationInfo ?? MeditationInfoMock.mock(),
        meditationSettings: meditationSettings ?? MeditationSettingsMock.mock()
    );
  }
}

extension MeditationInfoMock on MeditationInfo {
  static MeditationInfo mock({
    shouldShowHeartRate = false,
    shouldShowTime = false,
  }) {
    return MeditationInfo(
        shouldShowHeartRate: shouldShowHeartRate,
        shouldShowTime: shouldShowTime
    );
  }
}

extension MeditationSettingsMock on MeditationSettings {
  static MeditationSettings mock({
    isHapticFeedbackEnabled = false,
  }) {
    return MeditationSettings(
      isHapticFeedbackEnabled: isHapticFeedbackEnabled,
    );
  }
}