import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/session/data/repository/impl/breathing_pattern_repository_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('BreathingPatternRepository', () {
    late MockSharedPreferences mockSharedPreferences;
    late BreathingPatternRepositoryLocal breathingPatternRepositoryLocal;
    setUpAll(() async {
      mockSharedPreferences = MockSharedPreferences();
      getIt.registerSingleton<SharedPreferences>(mockSharedPreferences);
    });
    setUp(() {
      breathingPatternRepositoryLocal =
          BreathingPatternRepositoryLocal(mockSharedPreferences);
    });

    test(
        'getOrCreateBreathingPatterns - should return a list with breathing pattern',
        () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) => Future(() => true));
      final result =
          await breathingPatternRepositoryLocal.getOrCreateBreathingPatterns();
      expect(result.pattern[0].multiplier, 1);
      expect(result.pattern.length, 4);
    });
  });
}
