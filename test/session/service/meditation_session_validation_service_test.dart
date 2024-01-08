import 'dart:math';
import 'package:flutter_meditation/home/data/model/heartrate_measurement_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/session_parameter_model.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/session/data/service/meditation_session_validation_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../model/meditation_model_mock.dart';

void main() {
  MeditationSessionValidationService sut() {
    return MeditationSessionValidationService();
  }

  List<HeartrateMeasurementModel> getRealisticHeartRates(DateTime startDate, int length) {
    var random = Random();
    int lastTimestamp = startDate.millisecondsSinceEpoch;
    // generate an array from 0 to 15
    final List<HeartrateMeasurementModel> heartRates = List<int>
        .generate(length, (i) => i)
        .map((e) {
      // Random increment between 2000 (2 seconds) and 3500 (3.5 seconds) milliseconds
      int increment =
          2000 + random.nextInt(1500); // 1500 is the range for 2-3 seconds
      lastTimestamp += increment; // Increment the timestamp by the random value
      return HeartrateMeasurementModelMock.mock(
          timestamp: lastTimestamp,
          heartRate: (95 - e - random.nextInt(20)).toDouble());
    }).toList();
    return heartRates;
  }

  MeditationModel getRealisticSession({int numberOfHeartRateEntries = 15}) {
    final DateTime currentDate = DateTime.now();
    var random = Random();
    // generate an array from 0 to 20
    final List<SessionParameterModel> sessionParameters =
        List<int>.generate(20, (i) => i).map((e) {
      return SessionParameterModelMock.mock(
          binauralFrequency: random.nextInt(600),
          breathingMultiplier: 0.5 + random.nextDouble(),
          breathingPattern: BreathingPatternType.fourSevenEight,
          heartRates: getRealisticHeartRates(currentDate, numberOfHeartRateEntries)
      );
    })
        .toList();
    return MeditationModelMock.mock(
      duration: 600,
      isHapticFeedbackEnabled: true,
      shouldShowHeartRate: true,
      timestamp: currentDate.millisecondsSinceEpoch / 1000.0,
      completedSession: true,
      sessionParameters: sessionParameters,
    );
  }

  group('MeditationSessionValidationServiceTests', () {
    test('givenFifteenHeartRateMeasurements_whenValidateSession_thenSameArrayLength', () {
      // given
      final MeditationModel session = getRealisticSession();

      // when
      final MeditationModel validatedSession =
          sut().validateMeditationSession(session);

      // then
      expect(validatedSession.sessionParameters.length, 20);
      expect(validatedSession.sessionParameters[0].heartRates.length, 15);
    });

    test('givenMoreThanFifteenHeartRateMeasurements_whenValidateSession_thenFifteenMeasurements', () {
      // given
      final MeditationModel session = getRealisticSession(numberOfHeartRateEntries: 21);

      // when
      final MeditationModel validatedSession = sut().validateMeditationSession(session);

      // then
      expect(validatedSession.sessionParameters.length, 20);
      expect(validatedSession.sessionParameters[0].heartRates.length, 15);
    });

    test('givenLessThanFifteenHeartRateMeasurements_whenValidateSession_thenFifteenMeasurements', () {
      // given
      final MeditationModel session = getRealisticSession(numberOfHeartRateEntries: 12);

      // when
      final MeditationModel validatedSession = sut().validateMeditationSession(session);

      // then
      expect(validatedSession.sessionParameters.length, 20);
      expect(validatedSession.sessionParameters[0].heartRates.length, 15);
    });

    test('givenSessionParametersWithEmptyHeartRates_whenValidateSession_thenFilterSessionParameters', () {
      // given
      final MeditationModel session = MeditationModelMock.mock(
          sessionParameters: [
            SessionParameterModelMock.mock(
                heartRates: [
                  HeartrateMeasurementModelMock.mock(),
                  HeartrateMeasurementModelMock.mock(),
                ]
            ),
            SessionParameterModelMock.mock(
                heartRates: []
            ),
          ]
      );

      // when
      final MeditationModel validatedSession = sut().validateMeditationSession(session);

      // then
      expect(validatedSession.sessionParameters.length, 1);

    });
  });

}
