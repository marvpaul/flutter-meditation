/// {@category Repository}
library past_sessions_middleware_repository;

import 'dart:async';
import 'dart:convert';

import 'package:flutter_meditation/common/variables.dart';
import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/all_meditations_repository.dart';
import 'package:flutter_meditation/home/data/repository/impl/all_meditations_repository_local.dart';
import 'package:flutter_meditation/session/data/mapper/meditation_session_data_mapper.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/settings/data/repository/settings_repository.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../session/data/dto/meditation_session_middleware_dto.dart';
import '../../dto/past_sessions_response_dto.dart';
import '../past_sessions_repository.dart';

@singleton
@injectable
class PastSessionsMiddlewareRepository implements PastSessionsRepository {

  final SettingsRepository _settingsRepository;
  final AllMeditationsRepository _meditationsRepository = getIt<AllMeditationsRepositoryLocal>();

  PastSessionsMiddlewareRepository(this._settingsRepository) {
    _pastSessionsSubject.add([]);
  }

  @factoryMethod
  static Future<PastSessionsMiddlewareRepository> create(
      SettingsRepositoryLocal settingsRepository
      ) async {
    return PastSessionsMiddlewareRepository(settingsRepository);
  }

  @override
  Stream<List<MeditationModel>> get pastSessionsStream => _pastSessionsSubject.stream;
  final BehaviorSubject<List<MeditationModel>> _pastSessionsSubject = BehaviorSubject<List<MeditationModel>>();

  @override
  void fetchMeditationSessions() async {
    final String deviceId = await getDeviceId();
    final url = Uri.parse('$defaultServerHost$meditationsUri?deviceId=$deviceId');

    try {
      final response = await http.get(url);
      PastSessionsResponseDTO decodedResponse = PastSessionsResponseDTO.fromJson(json.decode(response.body));
      if (response.statusCode == 200 && decodedResponse.meditationSessions != null) {
        List<MeditationModel> mappedResponse = decodedResponse.meditationSessions!.map((e) => e.toDomain()).toList();
        _pastSessionsSubject.add(mappedResponse);
      } else {
        print('Error ${response.statusCode} - ${decodedResponse.message}');
        _pastSessionsSubject.add(await _getLocallyStoredMeditationSessions());
      }
    } catch (e) {
      // Handle any exceptions
      _pastSessionsSubject.add(await _getLocallyStoredMeditationSessions());
      throw Exception('Error fetching meditation sessions: $e');
    }
  }

  Future<List<MeditationModel>> _getLocallyStoredMeditationSessions() async {
    List<MeditationModel>? session = await _meditationsRepository.getAllMeditation();
    if (session != null) {
      return session;
    } else {
      return [];
    }
  }

  @override
  Future<void> storeMeditationSession(MeditationModel session) async {
    final String deviceId = await getDeviceId();
    final url = Uri.parse('$defaultServerHost$meditationsUri');

    _meditationsRepository.addMeditation(session);
    try {
      MeditationSessionMiddlewareDTO body = session.toDTO(deviceId);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(body.toJson()),
      );
      final bool isStatusCodeWithinAcceptanceRange = response.statusCode >= 200 && response.statusCode < 300;
      if (!isStatusCodeWithinAcceptanceRange) {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error storing meditation session: $e');
    }
  }

  Future<String> getDeviceId() async {
    return await _settingsRepository.getDeviceId();
  }

  void dispose() {
    _pastSessionsSubject.close();
  }
}