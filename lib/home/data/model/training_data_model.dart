import 'package:flutter_meditation/session/data/model/prediction_request_model.dart';
import 'package:flutter_meditation/session/data/model/predition_parameter_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'training_data_model.freezed.dart';
part 'training_data_model.g.dart';

@unfreezed
class TrainingDataModel with _$TrainingDataModel {
  factory TrainingDataModel(
      {List<PredictionParametersModel>? data}) = _TrainingDataModel;

  factory TrainingDataModel.fromJson(Map<String, dynamic> json) =>
      _$TrainingDataModelFromJson(json);
}
