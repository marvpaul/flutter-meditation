import 'package:flutter_meditation/session/data/model/session_model.dart';

abstract class SessionRepository {
  static const String sessionKey = "session";

  Future<SessionModel?> getSession();
  void saveSession(SessionModel settings);
  void restoreSession();
}
