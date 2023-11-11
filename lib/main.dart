import 'package:flutter/material.dart';
import 'package:flutter_meditation/home/page/presentation/view/HomePageView.dart';
import 'package:flutter_meditation/settings/page/di/SettingsModule.dart';
import 'package:flutter_meditation/settings/page/presentation/viewmodel/SettingsPageViewModel.dart';
import 'package:provider/provider.dart';

import 'home/page/presentation/viewmodel/HomePageViewModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomePageViewModel()),
          ChangeNotifierProvider(create: (_) => SettingsModule().provide()), // TODO: use di library get_it
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
