import '../data/repository/LocalStorageUserSettingsRepository.dart';
import '../domain/repository/UserSettingsRepository.dart';
import '../domain/usecase/ChangeHapticFeedbackUserSettingsUseCase.dart';
import '../domain/usecase/GetUserSettingsUseCase.dart';
import '../presentation/viewmodel/SettingsPageViewModel.dart';

// TODO: hopefully just temporary - ideally use di library get_it to replace this
abstract class SettingsModuleType {
  SettingsPageViewModel provide();
}

class SettingsModule implements SettingsModuleType {

  final UserSettingsRepository _userSettingsRepository = LocalStorageUserSettingsRepository();

  UserSettingsRepository _componentUserSettingsRepository() {
    return _userSettingsRepository;
  }

  GetUserSettingsUseCase _componentGetUserSettingsUseCase() {
    return GetUserSettingsUseCase(_componentUserSettingsRepository());
  }

  ChangeHapticFeedbackUserSettingsUseCase _componentChangeHapticFeedbackUserSettingsUseCase() {
    return ChangeHapticFeedbackUserSettingsUseCase(_componentUserSettingsRepository());
  }

  @override
  SettingsPageViewModel provide() {
    return SettingsPageViewModel(_componentGetUserSettingsUseCase(), _componentChangeHapticFeedbackUserSettingsUseCase());
  }
}