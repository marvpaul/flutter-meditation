import '../model/past_sessions.dart';

abstract class PastSessionsRepository {
  Stream<List<PastSession>> get pastSessionsStream;
  void fetchMeditationSessions();
}
