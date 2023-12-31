import '../model/past_sessions.dart';

abstract class PastSessionsRepository {
  Future<List<PastSession>> fetchMeditationSessions(String deviceId);
}
