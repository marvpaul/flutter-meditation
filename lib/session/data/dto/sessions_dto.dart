import 'package:flutter_meditation/session/data/model/session_model.dart';
import 'package:flutter_meditation/session/data/model/sessions_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../settings/data/model/settings_model.dart';
part 'sessions_dto.freezed.dart';
part 'sessions_dto.g.dart';
@unfreezed
class SessionsDTO with _$SessionsDTO {
  factory SessionsDTO({
    required final SessionsModel sessions     // it's also possible to return a list of settings here
  }) = _SessionsDTO;

  factory SessionsDTO.fromJson(Map<String, dynamic> json) =>
      _$SessionsDTOFromJson(json);
}