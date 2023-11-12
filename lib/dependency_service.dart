import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class DependencyService {

  DependencyService._();

  // Get.It - Dependency Injection

  static void registerLazySingleton<T extends Object>(T Function() func) {
    GetIt.I.registerLazySingleton<T>(func);
  }

  static void registerFactory<T extends Object>(T Function() func) {
    GetIt.I.registerFactory<T>(func);
  }

  static T get<T extends Object>() {
    return GetIt.I.get<T>();
  }

  // Provider - State Management

  static T getChangeNotifier<T extends ChangeNotifier>(BuildContext context) {
    return Provider.of<T>(context);
  }
}
