import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entity/UserSettings.dart';
import '../../domain/usecase/ChangeHapticFeedbackUserSettingsUseCase.dart';
import '../../domain/usecase/GetUserSettingsUseCase.dart';

class SettingsPageViewModel extends ChangeNotifier {

  bool isHapticFeedbackEnabled = true;

  late StreamSubscription<UserSettings> _subscription;

  final GetUserSettingsUseCase _getUserSettingsUseCase;
  final ChangeHapticFeedbackUserSettingsUseCase _changeHapticFeedbackUserSettingsUseCase;

  SettingsPageViewModel(this._getUserSettingsUseCase, this._changeHapticFeedbackUserSettingsUseCase);

  startObserving() {
    _subscription = _getUserSettingsUseCase.execute().listen((userSettings) {
      isHapticFeedbackEnabled = userSettings.meditationSettings.isHapticFeedbackEnabled;
      notifyListeners();
    });
  }

  stopObserving() {
    _subscription.cancel();
  }

  toggleHapticFeedback(bool isEnabled) {
    _changeHapticFeedbackUserSettingsUseCase.execute(isEnabled);
  }
}
