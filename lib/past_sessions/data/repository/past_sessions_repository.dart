import '../model/past_sessions.dart';

abstract class PastSessionsRepository {
  Stream<List<PastSession>> get pastSessionsStream;
  Future<List<PastSession>> fetchMeditationSessions(String deviceId);
}
