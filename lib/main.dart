import 'package:flutter/material.dart';
import 'package:flutter_meditation/dependency_service.dart';
import 'package:flutter_meditation/home/page/presentation/view/HomePageView.dart';
import 'package:flutter_meditation/settings/page/di/SettingsModule.dart';
import 'package:flutter_meditation/settings/page/presentation/viewmodel/SettingsPageViewModel.dart';
import 'package:provider/provider.dart';

import 'common/localstorage/di/LocalStorageModule.dart';
import 'home/page/di/HomeModule.dart';
import 'home/page/presentation/viewmodel/HomePageViewModel.dart';

void main() {
  _setupDependencies();
  runApp(const MyApp());
}

void _setupDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorageModule();
  HomeModule();
  SettingsModule();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => DependencyService.get<HomePageViewModel>()),
        ChangeNotifierProvider(
            create: (_) => DependencyService.get<SettingsPageViewModel>()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const HomePageView(),
      ),
    );
  }
}
