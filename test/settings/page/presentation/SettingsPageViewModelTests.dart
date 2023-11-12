import 'dart:async';

import 'package:flutter_meditation/settings/page/presentation/viewmodel/SettingsPageViewModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<GetUserSettingsUseCase>()])
import 'package:flutter_meditation/settings/page/domain/usecase/GetUserSettingsUseCase.dart';

@GenerateNiceMocks([MockSpec<ChangeHapticFeedbackUserSettingsUseCase>()])
import 'package:flutter_meditation/settings/page/domain/usecase/ChangeHapticFeedbackUserSettingsUseCase.dart';

import '../../UserSettingsMocks.dart';
import 'SettingsPageViewModelTests.mocks.dart';

// TODO: automate command to generate mocks - command to execute: dart run build_runner build
void main() {
  group("SettingsPageViewModel Tests", () {
    late SettingsPageViewModel sut;
    late MockGetUserSettingsUseCase mockGetUserSettingsUseCase;
    late MockChangeHapticFeedbackUserSettingsUseCase mockChangeHapticFeedbackUserSettingsUseCase;

    setUp(() {
      mockGetUserSettingsUseCase = MockGetUserSettingsUseCase();
      mockChangeHapticFeedbackUserSettingsUseCase = MockChangeHapticFeedbackUserSettingsUseCase();
      sut = SettingsPageViewModel(
          mockGetUserSettingsUseCase,
          mockChangeHapticFeedbackUserSettingsUseCase
      );
    });

    test("givenUserSettings whenStartObserving thenExpectedValues", () async {
      // given
      final userSettings = UserSettingsMock.mock(
          meditationSettings: MeditationSettingsMock.mock(
              isHapticFeedbackEnabled: false
          )
      );
      when(mockGetUserSettingsUseCase.execute()).thenAnswer((_) => Stream.fromIterable([userSettings]));

      // when
      sut.startObserving();

      // then
      await Future.delayed(Duration.zero);
      verify(mockGetUserSettingsUseCase.execute()).called(1);
      expect(sut.isHapticFeedbackEnabled, false);
    });

    test("givenUserSettings whenToggleHapticFeedback thenExpectedValues", () async {
      // given
      final userSettings = UserSettingsMock.mock(
          meditationSettings: MeditationSettingsMock.mock(
              isHapticFeedbackEnabled: true
          )
      );
      when(mockGetUserSettingsUseCase.execute()).thenAnswer((_) => Stream.fromIterable([userSettings]));

      // when
      sut.startObserving();
      sut.toggleHapticFeedback(false);

      // then
      await Future.delayed(Duration.zero);
      verify(mockChangeHapticFeedbackUserSettingsUseCase.execute(false)).called(1);
    });
  });

}
