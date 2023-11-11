class UserSettings {
  final MeditationSettings meditationSettings;
  final MeditationInfo meditationInfo;

  UserSettings({
    required this.meditationSettings,
    required this.meditationInfo,
  });
}

class MeditationSettings {
  final bool isHapticFeedbackEnabled;

  MeditationSettings({
    required this.isHapticFeedbackEnabled,
  });
}

class MeditationInfo {
  final bool shouldShowHeartRate;
  final bool shouldShowTime;

  MeditationInfo({
    required this.shouldShowHeartRate,
    required this.shouldShowTime,
  });
}

extension UserSettingsCopy on UserSettings {
  UserSettings copyWith({
    MeditationSettings? meditationSettings,
    MeditationInfo? meditationInfo,
  }) {
    return UserSettings(
      meditationSettings: meditationSettings ?? this.meditationSettings,
      meditationInfo: meditationInfo ?? this.meditationInfo,
    );
  }
}

extension MeditationSettingsCopy on MeditationSettings {
  MeditationSettings copyWith({
    bool? isHapticFeedbackEnabled,
  }) {
    return MeditationSettings(
      isHapticFeedbackEnabled: isHapticFeedbackEnabled ?? this.isHapticFeedbackEnabled,
    );
  }
}