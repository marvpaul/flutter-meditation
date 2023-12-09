import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'meditation_dto.freezed.dart';
part 'meditation_dto.g.dart';
@unfreezed
class MeditationDTO with _$MeditationDTO {
  factory MeditationDTO({
    required final MeditationModel meditation,        // it's also possible to return a list of settings here
  }) = _MeditationDTO;

  factory MeditationDTO.fromJson(Map<String, dynamic> json) =>
      _$MeditationDTOFromJson(json);
}