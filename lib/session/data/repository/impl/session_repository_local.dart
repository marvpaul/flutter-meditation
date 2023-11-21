import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../session_repository.dart';


@singleton
class SessionRepositoryLocal implements SessionRepository{
  final SharedPreferences prefs;
  SessionRepositoryLocal(this.prefs);

}