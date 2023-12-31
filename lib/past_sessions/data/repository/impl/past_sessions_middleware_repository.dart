import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../dto/past_sessions_response_dto.dart';
import '../../model/past_sessions.dart';
import '../../mapper/past_sessions_data_mapper.dart';
import '../past_sessions_repository.dart';

@singleton
class PastSessionsMiddlewareRepository implements PastSessionsRepository {

  final String _baseUrl = 'http://localhost:6000';

  @override
  Future<List<PastSession>> fetchMeditationSessions(String deviceId) async {
    final url = Uri.parse('$_baseUrl/meditations?deviceId=$deviceId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        PastSessionsResponseDTO decodedResponse = PastSessionsResponseDTO.fromJson(json.decode(response.body));
        PastSessions mappedResponse = decodedResponse.toDomain();
        return mappedResponse.meditationSessions;
      } else {
        // Handle the case where the server responds with an error
        throw Exception('Failed to load meditation sessions');
      }
    } catch (e) {
      // Handle any exceptions
      throw Exception('Error fetching meditation sessions: $e');
    }
  }
}