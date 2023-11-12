import 'package:flutter_meditation/dependency_service.dart';

import '../presentation/viewmodel/HomePageViewModel.dart';

class HomeModule {

  HomeModule() {
    _registerDependencies();
  }

  _registerDependencies() {
    DependencyService.registerFactory(() => HomePageViewModel());
  }
}