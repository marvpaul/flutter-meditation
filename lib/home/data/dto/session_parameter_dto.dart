import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'session_parameter_dto.freezed.dart';
part 'session_parameter_dto.g.dart';
@unfreezed
class SessionParameterDTO with _$SessionParameterDTO {
  factory SessionParameterDTO({
    required final MeditationModel meditation,        // it's also possible to return a list of settings here
  }) = _SessionParameterDTO;

  factory SessionParameterDTO.fromJson(Map<String, dynamic> json) =>
      _$SessionParameterDTOFromJson(json);
}