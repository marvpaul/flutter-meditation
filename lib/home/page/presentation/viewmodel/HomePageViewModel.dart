import 'package:flutter/foundation.dart';

class HomePageViewModel extends ChangeNotifier {
  String _appbarText = "";
  String get appbarText => _appbarText;

  HomePageViewModel() {
    _appbarText = _getGreetingForCurrentTime();
  }

  String _getGreetingForCurrentTime() {
    final hour = DateTime.now().hour;
    if (hour > 6 && hour < 12) {
      return "Good Morning";
    } else if (hour < 18) {
      return "Good Afternoon";
    } else if (hour < 22) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }
}