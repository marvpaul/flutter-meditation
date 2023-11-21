import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../past_sessions_repository.dart';


@singleton
class PastSessionsRepositoryLocal implements PastSessionsRepository{
  final SharedPreferences prefs;
  PastSessionsRepositoryLocal(this.prefs);

}