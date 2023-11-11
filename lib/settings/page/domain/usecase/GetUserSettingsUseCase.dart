import '../entity/UserSettings.dart';
import '../repository/UserSettingsRepository.dart';

class GetUserSettingsUseCase {
  final UserSettingsRepository _userSettingsRepository;

  GetUserSettingsUseCase(this._userSettingsRepository);

  Stream<UserSettings> execute() {
    return _userSettingsRepository.userSettingsStream;
  }
}