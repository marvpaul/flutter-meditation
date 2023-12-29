import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ml_train_model.freezed.dart';

part 'ml_train_model.g.dart';

@freezed
class MLTrainModel with _$MLTrainModel {
  factory MLTrainModel(
      @JsonKey(name: 'training_data')
      List<List> trainingData,
      @JsonKey(name: 'user_id')
      String userId) = _MLTrainModel;

  factory MLTrainModel.fromJson(Map<String, dynamic> json) =>
      _$MLTrainModelFromJson(json);
}
