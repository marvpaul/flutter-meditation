import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/session/data/dto/session_dto.dart';
import 'package:flutter_meditation/session/data/model/session_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/settings/data/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../session_repository.dart';


@singleton
class SessionRepositoryLocal implements SessionRepository{
  final SharedPreferences prefs;
  SessionRepositoryLocal(this.prefs);
  final SettingsRepository _settingsRepository =
      getIt<SettingsRepositoryLocal>();

  @override
  Future<SessionModel> getSession() async {
    print("TODO: Delete session for testing purposes"); 
    prefs.remove("session"); 
    final String? sessionObj = prefs.getString(SessionRepository.sessionKey);
    if (sessionObj != null) {
      debugPrint(sessionObj);
      return SessionDTO.fromJson(JsonDecoder().convert(sessionObj)).session;
    }
    SessionModel settingsModel = SessionModel();
    SettingsModel? settings = await _settingsRepository.getSettings();
    print(settings); 
    saveSession(settingsModel);
    // return default if no config was found
    return settingsModel;
  }

  @override
  void saveSession(SessionModel session) {
    final String sessionJSON = JsonEncoder().convert(SessionDTO(session: session).toJson());
    prefs.setString(SessionRepository.sessionKey, sessionJSON);
  }

  @override
  void restoreSession() {
    saveSession(SessionModel());
  }

}