import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../settings/data/model/settings_model.dart';
part 'past_sessions_dto.freezed.dart';
part 'past_sessions_dto.g.dart';
@unfreezed
class PastSessionsDTO with _$PastSessionsDTO {
  factory PastSessionsDTO({
    required final SettingsModel settings,        // it's also possible to return a list of settings here
  }) = _PastSessionsDTO;

  factory PastSessionsDTO.fromJson(Map<String, dynamic> json) =>
      _$PastSessionsDTOFromJson(json);
}