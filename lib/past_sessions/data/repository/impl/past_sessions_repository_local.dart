import 'package:flutter_meditation/past_sessions/data/model/past_sessions.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../past_sessions_repository.dart';


@singleton
class PastSessionsRepositoryLocal implements PastSessionsRepository{
  final SharedPreferences prefs;
  PastSessionsRepositoryLocal(this.prefs);

  @override
  Future<List<PastSession>> fetchMeditationSessions(String deviceId) {
    // TODO: implement fetchMeditationSessions
    throw UnimplementedError();
  }

}