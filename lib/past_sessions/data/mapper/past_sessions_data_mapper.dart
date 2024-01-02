import '../../../home/data/model/heartrate_measurement_model.dart';
import '../../../home/data/model/meditation_model.dart';
import '../../../home/data/model/session_parameter_model.dart';
import '../../../session/data/model/breathing_pattern_model.dart';
import '../dto/past_sessions_response_dto.dart';

extension PastSessionDTOMeditationModelMapper on PastSessionDTO {
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
      binauralFrequency: beatFrequency.toInt(),
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