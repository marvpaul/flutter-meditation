import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/session/data/dto/session_dto.dart';
import 'package:flutter_meditation/session/data/dto/sessions_dto.dart';
import 'package:flutter_meditation/session/data/model/session_model.dart';
import 'package:flutter_meditation/session/data/model/sessions_model.dart';
import 'package:flutter_meditation/session/data/repository/sessions_repository.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/settings/data/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../session_repository.dart';


@singleton
class SessionsRepositoryLocal implements SessionsRepository{
  final SharedPreferences prefs;
  SessionsRepositoryLocal(this.prefs);
  /* final SessionsRepository _sessionsRepository =
      getIt<SessionsRepositoryLocal>(); */

  @override
  Future<SessionsModel> getSessions() async {
    print("TODO: Delete session for testing purposes"); 
    prefs.remove("all_sessions"); 
    final String? sessionsObj = prefs.getString(SessionsRepository.sessionsKey);
    if (sessionsObj != null) {
      debugPrint(sessionsObj);
      return SessionsDTO.fromJson(JsonDecoder().convert(sessionsObj)).sessions;
    }
    SessionsModel sessionsModel = SessionsModel();
    saveSessions(sessionsModel);
    // return default if no config was found
    return sessionsModel;
  }

  @override
  void saveSessions(SessionsModel sessions) {
    final String sessionsJSON = JsonEncoder().convert(SessionsDTO(sessions: sessions).toJson());
    prefs.setString(SessionsRepository.sessionsKey, sessionsJSON);
  }

  @override
  void restoreSessions() {
    saveSessions(SessionsModel());
  }

}