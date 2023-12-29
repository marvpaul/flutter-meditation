import 'dart:convert';

import 'package:flutter_meditation/common/variables.dart';
import 'package:injectable/injectable.dart';

import '../../model/ml_train_model.dart';
import '../../model/prediction_request_model.dart';
import '../meditation_ai_optimization_repository.dart';
import 'package:http/http.dart' as http;

@singleton
class MeditationAIOptimizationRepositoryRest
    implements MeditationAIOptimizationRepository {
  @override
  Future<http.Response> predict(PredictionRequestModel predictionData) {
    String payload = jsonEncode(predictionData.toJson());
    return http.post(
      Uri.parse('$defaultServerHost$predictUri'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: payload,
    );
  }

  Future<http.Response> trainModel(MLTrainModel trainingData) {
    String payload = jsonEncode(trainingData.toJson());
    return http.post(
      Uri.parse('$defaultServerHost$trainUri'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: payload,
    );
  }
}
