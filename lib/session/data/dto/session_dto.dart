import 'package:flutter_meditation/session/data/model/session_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../settings/data/model/settings_model.dart';
part 'session_dto.freezed.dart';
part 'session_dto.g.dart';
@unfreezed
class SessionDTO with _$SessionDTO {
  factory SessionDTO({
    required final SessionModel session,        // it's also possible to return a list of settings here
  }) = _SessionDTO;

  factory SessionDTO.fromJson(Map<String, dynamic> json) =>
      _$SessionDTOFromJson(json);
}