import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../settings/data/model/settings_model.dart';
part 'session_dto.freezed.dart';
part 'session_dto.g.dart';
@unfreezed
class SessionDTO with _$SessionDTO {
  factory SessionDTO({
    required final SettingsModel settings,        // it's also possible to return a list of settings here
  }) = _SessionDTO;

  factory SessionDTO.fromJson(Map<String, dynamic> json) =>
      _$SessionDTOFromJson(json);
}