import 'package:flutter_meditation/session/data/model/sessions_model.dart';

abstract class SessionsRepository {
  static const String sessionsKey = "all_sessions";

  Future<SessionsModel?> getSessions();
  void saveSessions(SessionsModel sessions);
  void restoreSessions();
}
