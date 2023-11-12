import '../../domain/entity/UserSettings.dart';
import 'entity/UserSettingsDTO.dart';

extension UserSettingsDataMapper on UserSettings {
  UserSettingsDTO toData() {
    return UserSettingsDTO(
        meditationSettings: meditationSettings.toData(),
        meditationInfo: meditationInfo.toData()
    );
  }
}

extension MeditationSettingsDataMapper on MeditationSettings {
  MeditationSettingsDTO toData() {
    return MeditationSettingsDTO(
      isHapticFeedbackEnabled: isHapticFeedbackEnabled,
    );
  }
}

extension MeditationInfoDataMapper on MeditationInfo {
  MeditationInfoDTO toData() {
    return MeditationInfoDTO(
      shouldShowHeartRate: shouldShowHeartRate,
      shouldShowTime: shouldShowTime,
    );
  }
}

extension UserSettingsDTODataMapper on UserSettingsDTO? {
  UserSettings? toDomain() {
    if (this != null) {
      return UserSettings(
        meditationSettings: this!.meditationSettings.toDomain(),
        meditationInfo: this!.meditationInfo.toDomain(),
      );
    } else {
      return null;
    }
  }
}

extension MeditationSettingsDTODataMapper on MeditationSettingsDTO {
  MeditationSettings toDomain() {
    return MeditationSettings(
      isHapticFeedbackEnabled: isHapticFeedbackEnabled,
    );
  }
}

extension MeditationInfoDTODataMapper on MeditationInfoDTO {
  MeditationInfo toDomain() {
    return MeditationInfo(
      shouldShowHeartRate: shouldShowHeartRate,
      shouldShowTime: shouldShowTime,
    );
  }
}
