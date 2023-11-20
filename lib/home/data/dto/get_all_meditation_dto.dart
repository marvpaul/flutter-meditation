import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_all_meditation_dto.freezed.dart';
part 'get_all_meditation_dto.g.dart';
@unfreezed
class GetMeditationDTO with _$GetMeditationDTO {
  factory GetMeditationDTO({
    required final List<MeditationModel> meditations,
  }) = _GetMeditationDTO;

  factory GetMeditationDTO.fromJson(Map<String, dynamic> json) =>
      _$GetMeditationDTOFromJson(json);
}