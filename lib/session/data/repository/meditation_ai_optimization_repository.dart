import 'package:flutter_meditation/session/data/model/prediction_request_model.dart';
import 'package:http/http.dart' as http;

import '../model/ml_train_model.dart';

abstract class MeditationAIOptimizationRepository {
  Future<http.Response> predict(PredictionRequestModel predictionData);
  Future<http.Response> trainModel(MLTrainModel trainingData);
}
