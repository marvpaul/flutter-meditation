import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../settings/data/model/settings_model.dart';
part 'settings_dto.freezed.dart';
part 'settings_dto.g.dart';
@unfreezed
class SettingsDTO with _$SettingsDTO {
  factory SettingsDTO({
    required final SettingsModel settings,        // it's also possible to return a list of settings here
  }) = _SettingsDTO;

  factory SettingsDTO.fromJson(Map<String, dynamic> json) =>
      _$SettingsDTOFromJson(json);
}