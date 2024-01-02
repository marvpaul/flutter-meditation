import 'dart:convert';

import 'package:flutter_meditation/common/variables.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/session/data/dto/meditation_session_middleware_dto.dart';
import 'package:flutter_meditation/session/data/mapper/meditation_session_data_mapper.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../past_sessions/data/repository/impl/past_sessions_middleware_repository.dart';
import '../../../../past_sessions/data/repository/past_sessions_repository.dart';
import '../../../../settings/data/model/settings_model.dart';
import '../../../../settings/data/repository/impl/settings_repository_local.dart';
import '../../../../settings/data/repository/settings_repository.dart';
import '../../dto/train_session_parameter_optimization_response_dto.dart';
import '../session_parameter_optimization_repository.dart';

@singleton
@injectable
class SessionParameterOptimizationMiddlewareRepository implements SessionParameterOptimizationRepository {

  final String _preferenceKey = 'isAiModeEnabled';
  final bool _defaultValueForAiMode = true;

  final PastSessionsRepository _pastSessionsRepository;
  final SharedPreferences _sharedPreferences;
  final SettingsRepository _settingsRepository;

  SessionParameterOptimizationMiddlewareRepository(this._pastSessionsRepository, this._sharedPreferences, this._settingsRepository) {
    bool? isAiModeEnabled = _sharedPreferences.getBool(_preferenceKey);
    if (isAiModeEnabled != null) {
      _isAiModeEnabledSubject.add(isAiModeEnabled);
    } else {
      _sharedPreferences.setBool(_preferenceKey, _defaultValueForAiMode);
      _isAiModeEnabledSubject.add(_defaultValueForAiMode);
    }
  }

  @factoryMethod
  static Future<SessionParameterOptimizationMiddlewareRepository> create(
      PastSessionsMiddlewareRepository pastSessionsRepository,
      SharedPreferences sharedPreferences,
      SettingsRepositoryLocal settingsRepository
      ) async {
    return SessionParameterOptimizationMiddlewareRepository(pastSessionsRepository, sharedPreferences, settingsRepository);
  }

  @override
  Stream<bool> get isAiModeAvailable => _pastSessionsRepository.pastSessionsStream.map((e) => e.length > 2);

  final BehaviorSubject<bool> _isAiModeEnabledSubject = BehaviorSubject<bool>();
  @override
  Stream<bool> get isAiModeEnabled {
    return CombineLatestStream.combine2(
      _pastSessionsRepository.pastSessionsStream,
      _isAiModeEnabledSubject,
          (List<dynamic> sessions, bool isAiModeEnabled) {
        final bool isAiModeAvailable = sessions.length > 2;
        return isAiModeAvailable && isAiModeEnabled;
      },
    ).asBroadcastStream(); // To allow multiple listeners
  }

  @override
  void changeAiMode(bool isEnabled) async {
    await _sharedPreferences.setBool(_preferenceKey, isEnabled);
    _isAiModeEnabledSubject.add(isEnabled);
  }

  @override
  // Future<dynamic> getSessionParameterOptimization(MeditationModel session) async {
  //   // TODO: implement getSessionParameterOptimization
  //   throw UnimplementedError();
  // }
//
  @override
  Future<void> trainSessionParameterOptimization(MeditationModel session) async {
    final String deviceId = await getDeviceId();
    final url = Uri.parse('$defaultServerHost$trainUri');

    try {
      MeditationSessionMiddlewareDTO body = session.toDTO(deviceId);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body.toJson(),
      );
      TrainSessionParameterOptimizationResponseDTO decodedResponse = TrainSessionParameterOptimizationResponseDTO.fromJson(json.decode(response.body));
      if (response.statusCode == 200 && decodedResponse.message != null) {
        print('Message: ${decodedResponse.message}');
      }
    } catch (e) {
      // Handle any exceptions
      throw Exception('Error fetching meditation sessions: $e');
    }
  }

  Future<String> getDeviceId() async {
    return await _settingsRepository.getDeviceId();
  }

}