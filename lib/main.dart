import 'package:flutter/material.dart';
import 'package:flutter_meditation/view/screens/home_page_view.dart';
import 'package:flutter_meditation/view_model/home_page_view_model.dart';
import 'package:flutter_meditation/view_model/settings_page_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';

import 'di/Setup.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection(Environment.prod);
  await getIt.allReady();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: HomePageViewModel()),
        ChangeNotifierProvider.value(value: SettingsPageViewModel()),
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
