import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/model/settings/settings_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../di/Setup.dart';
import '../model/settings/repositories/impl/settings_repository_impl.dart';
import '../model/settings/repositories/settings_repository.dart';

@injectable
class SettingsPageViewModel extends BaseViewModel {
  var settingsSubject = PublishSubject<SettingsModel>();
  // TODO use StreamBuilder to detect whether data were already loaded => add animation while loading to view
  SettingsModel get settings => _settingsModel ?? SettingsModel();
  SettingsModel? _settingsModel;
  final ISettingsRepository _settingsRepository = getIt<SettingsRepositoryImpl>();

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
