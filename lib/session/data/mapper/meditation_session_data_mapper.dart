import '../../../home/data/model/heartrate_measurement_model.dart';
import '../../../home/data/model/meditation_model.dart';
import '../../../home/data/model/session_parameter_model.dart';
import '../../../session/data/model/breathing_pattern_model.dart';
import '../dto/meditation_session_middleware_dto.dart';

// DTO to Domain

extension MeditationSessionMiddlewareDTOMeditationModelMapper on MeditationSessionMiddlewareDTO {
  MeditationModel toDomain() {
    return MeditationModel(
      duration: duration,
      isHapticFeedbackEnabled: sessionPeriods.first.isHapticFeedbackEnabled,
      shouldShowHeartRate: true,
      timestamp: DateTime.parse(date).millisecondsSinceEpoch / 1000.0,
      sessionParameters: sessionPeriods.map((e) => e.toDomain()).toList(),
      completedSession: isCompleted,
    );
  }
}

extension SessionPeriodDTOSessionParameterModelMapper on SessionPeriodDTO {
  SessionParameterModel toDomain() {
    return SessionParameterModel(
      visualization: visualization,
      binauralFrequency: beatFrequency?.toInt(),
      breathingMultiplier: breathingPatternMultiplier,
      breathingPattern: breathingPattern.toDomain(),
      heartRates: heartRateMeasurements.map((e) => e.toDomain()).toList(),
    );
  }
}

extension BreathingPatternDTOBreathingPatternTypeMapper on List<BreathingPatternDTO> {
  BreathingPatternType toDomain() { // TODO: implement the other cases
    if (this[0].inhale == 4 && this[1].hold == 7 && this[2].inhale == 8 && this[3].hold == null) {
      return BreathingPatternType.fourSevenEight;
    }
    return BreathingPatternType.fourSevenEight;
  }
}

extension HeartRateMeasurementDTOHeartRateMeasurementModelMapper on HeartRateMeasurementDTO {
  HeartrateMeasurementModel toDomain() {
    return HeartrateMeasurementModel(
      heartRate: heartRate,
      timestamp: DateTime.parse(date).millisecondsSinceEpoch,
    );
  }
}

// Domain to DTO

extension MeditationModelMeditationSessionMiddlewareDTOMapper on MeditationModel {
  MeditationSessionMiddlewareDTO toDTO(String deviceId) {
    return MeditationSessionMiddlewareDTO(
      date: "${DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000).toIso8601String()}Z",
      deviceId: deviceId,
      duration: duration,
      isCanceled: false,
      isCompleted: completedSession,
      sessionPeriods: sessionParameters.map((e) => e.toDTO(isHapticFeedbackEnabled)).toList(),
    );
  }
}

extension SessionParameterModelSessionPeriodDTOMapper on SessionParameterModel {
  SessionPeriodDTO toDTO(bool isHapticFeedbackEnabled) {
    return SessionPeriodDTO(
      beatFrequency: binauralFrequency?.toDouble(),
      breathingPattern: breathingPattern.toDTO(),
      breathingPatternMultiplier: breathingMultiplier,
      heartRateMeasurements: heartRates.map((e) => e.toDTO()).toList(),
      isHapticFeedbackEnabled: isHapticFeedbackEnabled,
      visualization: visualization,
    );
  }
}

extension BreathinPatternTypeDTOMapper on BreathingPatternType {
  List<BreathingPatternDTO> toDTO() {
    switch (this) {
      case BreathingPatternType.fourSevenEight:
        return [
          BreathingPatternDTO(inhale: 4),
          BreathingPatternDTO(hold: 7),
          BreathingPatternDTO(exhale: 8),
          BreathingPatternDTO(hold: null),
        ];
      default:
        return [
        ];
    }
  }
}

extension HeartrateMeasurementModelHeartRateMeasurementDTOMapper on HeartrateMeasurementModel {
  HeartRateMeasurementDTO toDTO() {
    return HeartRateMeasurementDTO(
      date: "${DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000).toIso8601String()}Z",
      heartRate: heartRate,
    );
  }
}