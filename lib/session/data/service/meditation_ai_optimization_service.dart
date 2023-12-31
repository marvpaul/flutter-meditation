import 'dart:convert';

import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/home/data/model/training_data_model.dart';
import 'package:flutter_meditation/home/data/repository/impl/all_meditations_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/impl/training_data_repository_local.dart';
import 'package:flutter_meditation/session/data/model/prediction_request_model.dart';
import 'package:flutter_meditation/session/data/model/prediction_response_model.dart';
import 'package:flutter_meditation/session/data/model/predition_parameter_model.dart';
import 'package:flutter_meditation/session/data/repository/impl/meditation_ai_optimization_repository_rest.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/session_parameter_model.dart';
import 'package:flutter_meditation/session/data/model/ml_train_model.dart';
import 'package:flutter_meditation/settings/data/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../home/data/repository/all_meditations_repository.dart';
import '../../../settings/data/model/settings_model.dart';
import '../../../settings/data/repository/impl/settings_repository_local.dart';
import '../repository/meditation_ai_optimization_repository.dart';

@singleton
@injectable
class MeditationAIOptimizationService {
  final AllMeditationsRepository _meditationsRepository =
      getIt<AllMeditationsRepositoryLocal>();
  final MeditationAIOptimizationRepository _meditationAIOptimizationRepository =
      getIt<MeditationAIOptimizationRepositoryRest>();
  final TrainingDataRepositoryLocal _trainingDataRepositoryLocal =
      getIt<TrainingDataRepositoryLocal>();
  late SettingsModel _settingsModel;
  final SettingsRepository _settingsRepository;

  final int minimumDataPointsPrediction = 15;

  MeditationAIOptimizationService(this._settingsRepository);

  Future<void> _init() async {
    _settingsModel = await _settingsRepository.getSettings();
  }

  bool mlModelIsAvailable() {
    return _settingsModel.trainedDataPoints > 0;
  }

  Future<int> getTotalDataCount() async {
    print("We have " +
        (await _trainingDataRepositoryLocal.getNumberOfDatapoints())
            .toString());
    return _trainingDataRepositoryLocal.getNumberOfDatapoints();
  }

  Future<void> trainModel() async {
    if (await dataForTrainingAvailable()) {
      http.Response response = await _meditationAIOptimizationRepository
          .trainModel(await createTrainingRequestData());
      // TODO verify status code + error handling
      // save number of already trained data points
      print("We trained first time!!");
      _settingsModel.trainedDataPoints += minimumDataPointsPrediction;
      _settingsRepository.saveSettings(_settingsModel);
    }
  }

  Future<PredictionResponseModel?> predict(
      PredictionRequestModel currentParameters) async {
    // check whether ML model already exists
    if (mlModelIsAvailable()) {
      http.Response response =
          await _meditationAIOptimizationRepository.predict(currentParameters);
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return PredictionResponseModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('prediction failed');
      }
    }
    return null;
  }

  Future<bool> dataForTrainingAvailable() async {
    // TODO check whether there a new data for training available (next 600 data points)
    // e.g. when already 600 data points were used for training at least 1200 dp are necessary
    return ((await getTotalDataCount()) - _settingsModel.trainedDataPoints) >=
        minimumDataPointsPrediction;
  }

  final TrainingDataRepositoryLocal trainingDataRepositoryLocal =
      getIt<TrainingDataRepositoryLocal>();

  Future<MLTrainModel> createTrainingRequestData() async {
    // TODO loop through all meditations and generate payload for training request
    // make sure to use last 600 data points
    List<PredictionParametersModel>? trainingsData =
        await trainingDataRepositoryLocal
            .getLatestTrainingData(minimumDataPointsPrediction);
    List<PredictionRequestModel> requestData = [];
    trainingsData!.forEach((element) async {
      requestData.add(PredictionRequestModel(
          element.heartRates,
          element.binauralBeats,
          element.visualizations,
          element.breathingMultipliers,
          (await _settingsRepository.getSettings()).uuid!));
    });
    return MLTrainModel(requestData, _settingsModel.uuid!);
  }

  @factoryMethod
  static Future<MeditationAIOptimizationService> create(
      SettingsRepositoryLocal settings) async {
    MeditationAIOptimizationService meditationAIOptimizationService =
        MeditationAIOptimizationService(settings);
    await meditationAIOptimizationService._init();
    return meditationAIOptimizationService;
  }
}
