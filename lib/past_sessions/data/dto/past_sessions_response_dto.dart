import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../session/data/dto/meditation_session_middleware_dto.dart';

part 'past_sessions_response_dto.freezed.dart';
part 'past_sessions_response_dto.g.dart';

@freezed
class PastSessionsResponseDTO with _$PastSessionsResponseDTO {
  factory PastSessionsResponseDTO({
    List<MeditationSessionMiddlewareDTO>? meditationSessions,
    String? message,
  }) = _PastSessionsResponseDTO;

  factory PastSessionsResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$PastSessionsResponseDTOFromJson(json);
}
