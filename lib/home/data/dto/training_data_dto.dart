import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/training_data_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'training_data_dto.freezed.dart';
part 'training_data_dto.g.dart';
@unfreezed
class TrainingDataDTO with _$TrainingDataDTO {
  factory TrainingDataDTO({
    required final TrainingDataModel model,        // it's also possible to return a list of settings here
  }) = _TrainingDataDTO;

  factory TrainingDataDTO.fromJson(Map<String, dynamic> json) =>
      _$TrainingDataDTOFromJson(json);
}