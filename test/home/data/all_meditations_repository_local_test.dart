import 'dart:convert';

import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/home/data/dto/get_all_meditation_dto.dart';
import 'package:flutter_meditation/home/data/dto/meditation_dto.dart';
import 'package:flutter_meditation/home/data/model/heartrate_measurement_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/session_parameter_model.dart';
import 'package:flutter_meditation/home/data/repository/impl/all_meditations_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/impl/meditation_repository_local.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/session/data/repository/impl/breathing_pattern_repository_local.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockSettingsRepositoryLocal extends Mock
    implements SettingsRepositoryLocal {}

class MockBreathingPatternRepositoryLocal extends Mock
    implements BreathingPatternRepositoryLocal {}

void main() {
  group('AllMeditationsRepositoryLocal', () {
    late MockSharedPreferences mockSharedPreferences;
    late AllMeditationsRepositoryLocal allMeditationsRepositoryLocal;
    late MeditationRepositoryLocal meditationsRepositoryLocal;
    late MockSettingsRepositoryLocal mockSettingsRepository;
    late MockBreathingPatternRepositoryLocal
        mockBreathingPatternRepositoryLocal;
    late MeditationModel meditationModel;
    late String allMeditationsString, meditationString;
    
    setUpAll(() async {
      mockSharedPreferences = MockSharedPreferences();
      getIt.registerSingleton<SharedPreferences>(mockSharedPreferences);
      mockSettingsRepository = MockSettingsRepositoryLocal();
      getIt.registerSingleton<SettingsRepositoryLocal>(mockSettingsRepository);
      mockBreathingPatternRepositoryLocal =
          MockBreathingPatternRepositoryLocal();
      getIt.registerSingleton<BreathingPatternRepositoryLocal>(
          mockBreathingPatternRepositoryLocal);
    });
    setUp(() {
      allMeditationsRepositoryLocal =
          AllMeditationsRepositoryLocal(mockSharedPreferences);
      meditationsRepositoryLocal =
          MeditationRepositoryLocal(mockSharedPreferences);
      meditationModel = MeditationModel(
          duration: 600,
          isHapticFeedbackEnabled: false,
          shouldShowHeartRate: false,
          timestamp: DateTime.now().millisecondsSinceEpoch / 1000.0,
          sessionParameters: [
            SessionParameterModel(
                visualization: 'Arctic',
                binauralFrequency: 30,
                breathingMultiplier: 1.2,
                breathingPattern: BreathingPatternType.fourSevenEight,
                heartRates: [
                  HeartrateMeasurementModel(timestamp: 0, heartRate: 100),
                  HeartrateMeasurementModel(timestamp: 0, heartRate: 80)
                ]),
            SessionParameterModel(
                visualization: 'Polar',
                binauralFrequency: 30,
                breathingMultiplier: 1.2,
                breathingPattern: BreathingPatternType.fourSevenEight,
                heartRates: [
                  HeartrateMeasurementModel(timestamp: 0, heartRate: 100),
                  HeartrateMeasurementModel(timestamp: 0, heartRate: 80)
                ])
          ],
          completedSession: false);
      allMeditationsString = JsonEncoder()
          .convert(GetMeditationDTO(meditations: [meditationModel]).toJson());
      meditationString = JsonEncoder()
          .convert(MeditationDTO(meditation: meditationModel).toJson());
    });

    test('getMeditations - should return our configured meditation', () async {
      // Stub the `getString` and `setString` methods.
      when(() => mockSharedPreferences.getString('all_meditations'))
          .thenReturn(allMeditationsString);

      final result = await allMeditationsRepositoryLocal.getAllMeditation();
      expect(result![0].duration, 600);
    });
    test(
        'get average / min / max heart rate - should return proper heart rates for our meditation',
        () async {
      // Stub the `getString` and `setString` methods.
      when(() => mockSharedPreferences.getString('meditation'))
          .thenReturn(meditationString);

      final resultMeditation =
          await meditationsRepositoryLocal.getAverageHeartRate(meditationModel);
      expect(resultMeditation, 90);
      final minRate =
          await meditationsRepositoryLocal.getMinHeartRate(meditationModel);
      expect(minRate, 80);
      final maxRate =
          await meditationsRepositoryLocal.getMaxHeartRate(meditationModel);
      expect(maxRate, 100);
      meditationsRepositoryLocal.addHeartRate(meditationModel, 0, 0);
      expect(meditationsRepositoryLocal.getMinHeartRate(meditationModel), 0);
    });
    test(
        'get latest sessions parameters - should return the latest session parameters for our meditation',
        () async {
      // Stub the `getString` and `setString` methods.
      when(() => mockSharedPreferences.getString('meditation'))
          .thenReturn(meditationString);

      final resultMeditation = await meditationsRepositoryLocal
          .getLatestSessionParamaters(meditationModel);
      expect(resultMeditation.visualization, 'Polar');
    });
    test(
        'create new meditation - should propagate data like breathing multiplier correctly',
        () async {
      SettingsModel settings =
          SettingsModel(isHapticFeedbackEnabled: true, uuid: '123');
      when(() => mockSettingsRepository.getSettings())
          .thenAnswer((_) => Future(() => settings));
      BreathingPatternType type = BreathingPatternType.fourSevenEight;
      when(() =>
          mockBreathingPatternRepositoryLocal.getBreathingPatternByName(
              type)).thenAnswer((_) => Future(() => BreathingPatternModel(
          type: BreathingPatternType.fourSevenEight,
          steps: [
            BreathingPatternStep(type: BreathingStepType.INHALE, duration: 4),
            BreathingPatternStep(type: BreathingStepType.HOLD, duration: 7),
            BreathingPatternStep(type: BreathingStepType.EXHALE, duration: 8),
          ],
          multiplier: 1.2)));
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) => Future(() => true));

      final resultMeditation =
          await meditationsRepositoryLocal.createNewMeditation();
      expect(resultMeditation.completedSession, false);
      expect(resultMeditation.sessionParameters[0].breathingMultiplier, 1.2);
    });
  });
}
