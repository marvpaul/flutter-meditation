import 'dart:async';
import 'dart:convert';

import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/settings/data/repository/settings_repository.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../dto/past_sessions_response_dto.dart';
import '../../model/past_sessions.dart';
import '../../mapper/past_sessions_data_mapper.dart';
import '../past_sessions_repository.dart';

@singleton
@injectable
class PastSessionsMiddlewareRepository implements PastSessionsRepository {

  final String _baseUrl = 'http://localhost:6000';

  final SettingsRepository _settingsRepository;

  PastSessionsMiddlewareRepository(this._settingsRepository);

  @factoryMethod
  static Future<PastSessionsMiddlewareRepository> create(
      SettingsRepositoryLocal settingsRepository
      ) async {
    return PastSessionsMiddlewareRepository(settingsRepository);
  }

  @override
  Stream<List<PastSession>> get pastSessionsStream => _pastSessionsSubject.stream;
  final BehaviorSubject<List<PastSession>> _pastSessionsSubject = BehaviorSubject<List<PastSession>>();

  @override
  void fetchMeditationSessions() async {
    final String deviceId = await getDeviceId();
    final url = Uri.parse('$_baseUrl/meditations?deviceId=$deviceId');

    try {
      final response = await http.get(url);
      PastSessionsResponseDTO decodedResponse = PastSessionsResponseDTO.fromJson(json.decode(response.body));
      PastSessions? mappedResponse = decodedResponse.toDomain();
      if (response.statusCode == 200 && decodedResponse.meditationSessions != null) {
        _pastSessionsSubject.add(mappedResponse!.meditationSessions);
      } else {
        print('Error ${response.statusCode} - ${decodedResponse.message}');
        // Handle the case where the server responds with an error
      }
    } catch (e) {
      // Handle any exceptions
      throw Exception('Error fetching meditation sessions: $e');
    }
  }

  Future<String> getDeviceId() async {
    SettingsModel settings = await _settingsRepository.getSettings();
    return settings.uuid;
  }

  void dispose() {
    _pastSessionsSubject.close();
  }
}