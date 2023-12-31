import 'dart:convert';
import 'package:flutter_meditation/home/data/dto/training_data_dto.dart';
import 'package:flutter_meditation/home/data/model/heartrate_measurement_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/session_parameter_model.dart';
import 'package:flutter_meditation/home/data/model/training_data_model.dart';
import 'package:flutter_meditation/home/data/repository/training_data_repository.dart';
import 'package:flutter_meditation/session/data/model/predition_parameter_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class TrainingDataRepositoryLocal implements TrainingDataRepository {
  final SharedPreferences prefs;
  TrainingDataRepositoryLocal(this.prefs);

  @override
  Future<TrainingDataModel> getTrainingsData() async {
    final String? trainingDataString =
        prefs.getString(TrainingDataRepository.trainingDataKey);
    if (trainingDataString != null) {
      return TrainingDataDTO.fromJson(JsonDecoder().convert(trainingDataString))
          .model;
    }
    TrainingDataModel trainingDataModel = TrainingDataModel();
    trainingDataModel.data ??= [
      PredictionParametersModel(
          heartRates: [],
          binauralBeats: [],
          visualizations: [],
          breathingMultipliers: [])
    ];
    return trainingDataModel;
  }

  Future<List<PredictionParametersModel>?> getLatestTrainingData(
      int number) async {
    final String? trainingDataString =
        prefs.getString(TrainingDataRepository.trainingDataKey);
    if (trainingDataString != null) {
      List<PredictionParametersModel> trainingData = [];
      TrainingDataModel model =
          TrainingDataDTO.fromJson(JsonDecoder().convert(trainingDataString))
              .model;

      bool lastDatasetFull =
          model.data![model.data!.length - 1].heartRates.length == 15;
      for (int i =
              model.data!.length - (number ~/ 15) - (!lastDatasetFull ? 1 : 0);
          i < model.data!.length - (!lastDatasetFull ? 1 : 0);
          i++) {
        trainingData.add(model.data![i]);
      }
      print("Get latest training data, we expect exactly " +
          number.toString() +
          "entries ");
      print(trainingData.toString());
      return trainingData;
    }
    return null;
  }

  Future<int> getNumberOfDatapoints() async {
    TrainingDataModel data = await getTrainingsData();
    int points = 0;
    data.data?.forEach((elem) => points += elem.heartRates.length);
    return points;
  }

  List<List<dynamic>> transformHeartRates(
      List<List<dynamic>> measurements, int nrOfNewDatapoints) {
    List<List<dynamic>> interpolatedData = [];

    if (measurements.isEmpty) {
      return interpolatedData;
    }

    // Extract HeartrateMeasurementModel and sort by timestamp
    List<HeartrateMeasurementModel> heartRateModels = measurements
        .map(
          (data) => HeartrateMeasurementModel(
              timestamp: data[0].timestamp, heartRate: data[0].heartRate),
        )
        .toList();

    heartRateModels.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Calculate time interval between measurements
    int timeInterval =
        (heartRateModels.last.timestamp - heartRateModels.first.timestamp) ~/
            (nrOfNewDatapoints - 1);

    // Interpolate data for each new timestamp
    for (int i = 0; i < nrOfNewDatapoints; i++) {
      int targetTimestamp = heartRateModels.first.timestamp + i * timeInterval;
      List<dynamic> interpolatedDatum =
          interpolateData(measurements, targetTimestamp);
      interpolatedData.add(interpolatedDatum);
    }

    return interpolatedData;
  }

  List<dynamic> interpolateData(
      List<List<dynamic>> measurements, int targetTimestamp) {
    List<dynamic> interpolatedDatum = [];

    for (int i = 0; i < measurements.length; i++) {
      HeartrateMeasurementModel heartRateModel = measurements[i][0];
      int currentTimestamp = heartRateModel.timestamp;

      if (currentTimestamp == targetTimestamp) {
        // If the target timestamp matches an existing measurement, use its data
        interpolatedDatum.add(heartRateModel.heartRate);
        interpolatedDatum.addAll(measurements[i].sublist(1));
        return interpolatedDatum;
      } else if (currentTimestamp > targetTimestamp) {
        // Linear interpolation for other data types
        HeartrateMeasurementModel before = measurements[i - 1][0];
        HeartrateMeasurementModel after = heartRateModel;

        double timeDiff =
            after.timestamp.toDouble() - before.timestamp.toDouble();
        double weightBefore = (after.timestamp - targetTimestamp) / timeDiff;
        double weightAfter = 1.0 - weightBefore;

        // Interpolate heart rate
        double interpolatedHeartRate =
            weightBefore * before.heartRate + weightAfter * after.heartRate;
        interpolatedDatum.add(interpolatedHeartRate);

        // Copy other data types
        interpolatedDatum.addAll(measurements[i].sublist(1));

        return interpolatedDatum;
      }
    }

    // If the target timestamp is beyond the last measurement, use the data of the last measurement
    interpolatedDatum.add(measurements.last[0].heartRate);
    interpolatedDatum.addAll(measurements.last.sublist(1));

    return interpolatedDatum;
  }

  // Given a MeditationModel with a list of SessionParameter. Each SessionParameter contains {heartRates:[100, 200 ...], breathingMultiplier: 10, visualization: 1, binauralFreq: 60}.
  // This method transform data into a format where every heart rate is mapped to a set of parameters, e.g. [[100, 200,...], [10, 10, ...], [1, 1, ....], [60, 60, ...]]
  // Also we interpolate heart rates here because we want to have one heart rate every two seconds.
  PredictionParametersModel transformSessionData(
      MeditationModel model, int duration, List<String> kaleidoscopeOptions) {
    List<List<dynamic>> allSessionData = [];
    for (int i = 0; i < model.sessionParameters.length; i++) {
      SessionParameterModel sessionParameter = model.sessionParameters[i];
      sessionParameter.heartRates.forEach((element) {
        allSessionData.add([
          element,
          sessionParameter.binauralFrequency!,
          kaleidoscopeOptions.indexOf(sessionParameter.visualization!),
          sessionParameter.breathingMultiplier
        ]);
      });
    }
    allSessionData = transformHeartRates(allSessionData, duration ~/ 2);
    PredictionParametersModel predictionRequestModel =
        PredictionParametersModel(
            heartRates: [],
            binauralBeats: [],
            visualizations: [],
            breathingMultipliers: []);
    for (int i = 0; i < allSessionData.length; i++) {
      predictionRequestModel.heartRates.add(allSessionData[i][0].toInt());
      predictionRequestModel.binauralBeats.add(allSessionData[i][1]);
      predictionRequestModel.visualizations.add(allSessionData[i][2]);
      predictionRequestModel.breathingMultipliers.add(allSessionData[i][3]);
    }
    return predictionRequestModel;
  }

  PredictionParametersModel getPredictionData(MeditationModel model,
      int duration, List<String> kaleidoscopeOptions, int numberOfDatapoints) {
    PredictionParametersModel data =
        transformSessionData(model, duration, kaleidoscopeOptions);
    print("we have" + data.heartRates.length.toString());
    print("number of datapoints" + numberOfDatapoints.toString());

    data.heartRates = data.heartRates
        .getRange(data.heartRates.length - numberOfDatapoints,
            data.heartRates.length - 1)
        .toList();
    data.binauralBeats = (data.binauralBeats
        .getRange(data.binauralBeats.length - numberOfDatapoints,
            data.binauralBeats.length - 1)
        .toList());
    data.breathingMultipliers = (data.breathingMultipliers
        .getRange(data.breathingMultipliers.length - numberOfDatapoints,
            data.breathingMultipliers.length - 1)
        .toList());
    data.visualizations = (data.visualizations
        .getRange(data.visualizations.length - numberOfDatapoints,
            data.visualizations.length - 1)
        .toList());

    return data;
  }

  @override
  Future<void> addTrainingsData(MeditationModel model, int duration,
      List<String> kaleidoscopeOptions) async {
    TrainingDataModel trainingDataModel = await getTrainingsData();
    PredictionParametersModel allSessionData =
        transformSessionData(model, duration, kaleidoscopeOptions!);
    for (int i = 0; i < allSessionData.heartRates.length; i++) {
      // We want to divide into chunks of 15 datapoints each. If one list has reached the limit of 15, add a new list
      if (trainingDataModel
              .data![trainingDataModel.data!.length - 1].heartRates.length ==
          15) {
        trainingDataModel.data!.add(PredictionParametersModel(
            heartRates: [],
            binauralBeats: [],
            visualizations: [],
            breathingMultipliers: []));
      }
      trainingDataModel.data![trainingDataModel.data!.length - 1].heartRates
          .add(allSessionData.heartRates[i]);
      trainingDataModel.data![trainingDataModel.data!.length - 1].binauralBeats
          .add(allSessionData.binauralBeats[i]);
      trainingDataModel.data![trainingDataModel.data!.length - 1].visualizations
          .add(allSessionData.visualizations[i]);
      trainingDataModel
          .data![trainingDataModel.data!.length - 1].breathingMultipliers
          .add(allSessionData.breathingMultipliers[i]);
    }

    saveData(trainingDataModel);
  }

  @override
  void saveData(TrainingDataModel model) {
    print("Training data: " + model.data!.toString());
    final String settingsJson =
        JsonEncoder().convert(TrainingDataDTO(model: model).toJson());
    prefs.setString(TrainingDataRepository.trainingDataKey, settingsJson);
  }
}
