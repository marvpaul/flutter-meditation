import 'package:flutter_meditation/dependency_service.dart';

import '../data/repository/LocalStorageUserSettingsRepository.dart';
import '../domain/repository/UserSettingsRepository.dart';
import '../domain/usecase/ChangeHapticFeedbackUserSettingsUseCase.dart';
import '../domain/usecase/GetUserSettingsUseCase.dart';
import '../presentation/viewmodel/SettingsPageViewModel.dart';

class SettingsModule {

  SettingsModule() {
    _registerDependencies();
  }

  _registerDependencies() {
    DependencyService.registerLazySingleton<UserSettingsRepository>(() => LocalStorageUserSettingsRepository());
    DependencyService.registerFactory<GetUserSettingsUseCase>(() => GetUserSettingsUseCase(DependencyService.get<UserSettingsRepository>()));
    DependencyService.registerFactory<ChangeHapticFeedbackUserSettingsUseCase>(() => ChangeHapticFeedbackUserSettingsUseCase(DependencyService.get<UserSettingsRepository>()));
    DependencyService.registerFactory<SettingsPageViewModel>(() {
      return SettingsPageViewModel(
          DependencyService.get<GetUserSettingsUseCase>(),
          DependencyService.get<ChangeHapticFeedbackUserSettingsUseCase>()
      );
    });
  }
}