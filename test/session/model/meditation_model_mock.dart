import 'dart:math';

import 'package:flutter_meditation/home/data/model/heartrate_measurement_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/session_parameter_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';

extension MeditationModelMock on MeditationModel {
  static MeditationModel mock({
    int duration = 0,
    bool isHapticFeedbackEnabled = false,
    bool shouldShowHeartRate = false,
    double timestamp = 0,
    List<SessionParameterModel> sessionParameters = const [],
    bool completedSession = false,
  }) {
    return MeditationModel(
        duration: duration,
        isHapticFeedbackEnabled: isHapticFeedbackEnabled,
        shouldShowHeartRate: shouldShowHeartRate,
        timestamp: timestamp,
        sessionParameters: sessionParameters,
        completedSession: completedSession
    );
  }
}

extension SessionParameterModelMock on SessionParameterModel {
  static SessionParameterModel mock({
    String? visualization,
    int binauralFrequency = 0,
    double breathingMultiplier = 0,
    BreathingPatternType breathingPattern = BreathingPatternType.fourSevenEight,
    List<HeartrateMeasurementModel> heartRates = const [],
  }) {
    var random = Random();
    visualization ??= kaleidoscopeOptions![random.nextInt(kaleidoscopeOptions!.length)];
    return SessionParameterModel(
        visualization: visualization,
        binauralFrequency: binauralFrequency,
        breathingMultiplier: breathingMultiplier,
        breathingPattern: breathingPattern,
        heartRates: heartRates
    );
  }
}

extension HeartrateMeasurementModelMock on HeartrateMeasurementModel {
  static HeartrateMeasurementModel mock({
    int timestamp = 0,
    double heartRate = 0,
  }) {
    return HeartrateMeasurementModel(
        timestamp: timestamp,
        heartRate: heartRate
    );
  }
}

List<String>? kaleidoscopeOptions = [
  'Arctic',
  'Aurora',
  'Circle',
  'City',
  'Golden',
  'Japan',
  'Metropolis',
  'Nature',
  'Plants',
  'Skyline'
];