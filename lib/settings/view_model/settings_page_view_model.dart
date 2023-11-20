import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../di/Setup.dart';
import '../data/repository/impl/settings_repository_local.dart';
import '../data/repository/settings_repository.dart';

@injectable
class SettingsPageViewModel extends BaseViewModel {
  var settingsSubject = PublishSubject<SettingsModel>();
  SettingsModel? get settings => _settingsModel;
  SettingsModel? _settingsModel;
  final SettingsRepository _settingsRepository = getIt<SettingsRepositoryLocal>();

  @override
  void init() async {
    _settingsModel = await _settingsRepository.getSettings();
  }

  toggleHapticFeedback(bool isEnabled) {
    if(_settingsModel != null){
      _settingsModel!.isHapticFeedbackEnabled = isEnabled;
      notifyListeners();
    }

  }
}
