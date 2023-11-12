import 'package:flutter_meditation/dependency_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/manager/SharedPreferencesLocalStorageManger.dart';
import '../domain/manager/LocalStorageManger.dart';

class LocalStorageModule {

  LocalStorageModule() {
    _registerDependencies();
  }

  _registerDependencies() {
    Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();
    DependencyService.registerLazySingleton<LocalStorageManger>(() => SharedPreferencesLocalStorageManger(sharedPreferences));
  }
}