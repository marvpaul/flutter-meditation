import '../../../../../extension/Codable.dart';

class UserSettingsDTO implements Codable {
  final MeditationSettingsDTO meditationSettings;
  final MeditationInfoDTO meditationInfo;

  UserSettingsDTO({
    required this.meditationSettings,
    required this.meditationInfo,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "meditationSettings": meditationSettings.toJson(),
      "meditationInfo": meditationInfo.toJson(),
    };
  }

  @override
  factory UserSettingsDTO.fromJson(Map<String, dynamic> json) {
    return UserSettingsDTO(
      meditationSettings: MeditationSettingsDTO.fromJson(json["meditationSettings"]),
      meditationInfo: MeditationInfoDTO.fromJson(json["meditationInfo"]),
    );
  }
}

class MeditationSettingsDTO implements Codable {
  final bool isHapticFeedbackEnabled;

  MeditationSettingsDTO({
    required this.isHapticFeedbackEnabled,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "isHapticFeedbackEnabled": isHapticFeedbackEnabled,
    };
  }

  @override
  factory MeditationSettingsDTO.fromJson(Map<String, dynamic> json) {
    return MeditationSettingsDTO(
      isHapticFeedbackEnabled: json["isHapticFeedbackEnabled"],
    );
  }
}

class MeditationInfoDTO implements Codable {
  final bool shouldShowHeartRate;
  final bool shouldShowTime;

  MeditationInfoDTO({
    required this.shouldShowHeartRate,
    required this.shouldShowTime,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "shouldShowHeartRate": shouldShowHeartRate,
      "shouldShowTime": shouldShowTime,
    };
  }

  @override
  factory MeditationInfoDTO.fromJson(Map<String, dynamic> json) {
    return MeditationInfoDTO(
      shouldShowHeartRate: json["shouldShowHeartRate"],
      shouldShowTime: json["shouldShowTime"],
    );
  }
}