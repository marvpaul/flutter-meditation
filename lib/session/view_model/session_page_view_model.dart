import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/session_parameter_model.dart';
import 'package:flutter_meditation/home/data/model/training_data_model.dart';
import 'package:flutter_meditation/home/data/repository/impl/all_meditations_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/impl/meditation_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/all_meditations_repository.dart';
import 'package:flutter_meditation/home/data/repository/impl/training_data_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/meditation_repository.dart';
import 'package:flutter_meditation/home/view/screens/home_page_view.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/session/data/model/prediction_request_model.dart';
import 'package:flutter_meditation/session/data/model/prediction_response_model.dart';
import 'package:flutter_meditation/session/data/model/predition_parameter_model.dart';
import 'package:flutter_meditation/session/data/repository/breathing_pattern_repository.dart';
import 'package:flutter_meditation/session/data/repository/impl/breathing_pattern_repository_local.dart';
import 'package:flutter_meditation/session/data/service/meditation_ai_optimization_service.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/widgets/heart_rate_graph.dart';
import 'package:injectable/injectable.dart';
import '../../di/Setup.dart';
import 'package:flutter_meditation/session/data/repository/impl/binaural_beats_repository_local.dart';
import 'package:flutter_meditation/session/data/repository/binaural_beats_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../settings/data/repository/bluetooth_connection_repository.dart';
import '../../settings/data/service/mi_band_bluetooth_service.dart';

@injectable
class SessionPageViewModel extends BaseViewModel {
  MeditationModel? meditationModel;
  BreathingPatternModel? breathingPattern;
  SettingsModel? settingsModel;
  final MeditationRepository _meditationRepository =
      getIt<MeditationRepositoryLocal>();
  final BreathingPatternRepository _breathingPatternRepository =
      getIt<BreathingPatternRepositoryLocal>();
  final AllMeditationsRepository _allMeditationsRepository =
      getIt<AllMeditationsRepositoryLocal>();
  final TrainingDataRepositoryLocal _trainingDataRepository =
      getIt<TrainingDataRepositoryLocal>();
  final SettingsRepositoryLocal _settingsRepository =
      getIt<SettingsRepositoryLocal>();
  final BluetoothConnectionRepository _bluetoothRepository =
      getIt<MiBandBluetoothService>();

  final MeditationAIOptimizationService _meditationAIOptimizationService =
      getIt<MeditationAIOptimizationService>();

  bool showUI = true;
  double kaleidoscopeMultiplier = 0;

  final BinauralBeatsRepository _binauralBeatsRepository =
      getIt<BinauralBeatsRepositoryLocal>();

  int stateCounter = 0;
  bool running = false;
  bool finished = false;
  BreathingStepType state = BreathingStepType.INHALE;
  double timeLeft = 0;
  double totalTimePerState = 0;
  double progress = 0.0;
  double stateProgress = 0.0;
  late Timer timer, heartRateTimer, timerPredict;
  Duration totalDuration = const Duration();
  double elapsedSeconds = 0;
  final GlobalKey<HeartRateGraphState> heartRateGraphKey =
      GlobalKey<HeartRateGraphState>();

  var context;
  double heartRate = 0;
  List<double> heartRates = <double>[];

  int nrDatapoints = 6;
  List<FlSpot> dataPoints = [];

  bool get deviceIsConnected => _isConnected;
  late bool _isConnected;

  SessionParameterModel getLatestSessionParamaters() {
    if (meditationModel != null) {
      return _meditationRepository.getLatestSessionParamaters(meditationModel!);
    } else {
      return SessionParameterModel(
          visualization: 'Arctic',
          binauralFrequency: 30,
          breathingMultiplier: 1.0,
          breathingPattern: BreathingPatternType.fourSevenEight,
          heartRates: []);
    }
  }

  int numberOfStateChanges = 0;

  void updateHeartRate() {
    List<double> lastHeartRates = [];
    for (int i = 0; i < meditationModel!.sessionParameters.length; i++) {
      meditationModel!.sessionParameters[i].heartRates.forEach((element) {
        lastHeartRates.add(element.heartRate);
      });
    }

    int startIndex = (lastHeartRates.length - 1 - nrDatapoints) > 0
        ? (lastHeartRates.length - 1 - nrDatapoints)
        : 0;
    lastHeartRates = lastHeartRates
        .getRange(startIndex, lastHeartRates.length)
        .toList(growable: false);
    dataPoints.removeRange(0, dataPoints.length);
    for (int i = 0; i < lastHeartRates.length; i++) {
      dataPoints.add(FlSpot(i.toDouble(), lastHeartRates[i]));
    }
  }

  void initWithContext(BuildContext context) async {
    _isConnected = _bluetoothRepository.isAvailableAndConnected();
    if (_isConnected) {
      getHeartRateData();
    }

    meditationModel = await _meditationRepository.createNewMeditation();
    settingsModel = await _settingsRepository.getSettings();
    breathingPattern = await _breathingPatternRepository
        .getBreathingPatternByName(settingsModel!.breathingPattern);

    state = breathingPattern!.steps[stateCounter].type;
    timeLeft = breathingPattern!.steps[stateCounter].duration *
        getLatestSessionParamaters().breathingMultiplier;
    totalTimePerState = breathingPattern!.steps[stateCounter].duration *
        getLatestSessionParamaters().breathingMultiplier;
    _initSession();
    running = true;
    if (!_meditationAIOptimizationService.mlModelIsAvailable()) {
      totalDuration = const Duration(seconds: 10);
      Fluttertoast.showToast(
          msg:
              "Model in training. Please meditate 2x10 minutes. We already have" +
                  (await (_trainingDataRepository.getNumberOfDatapoints()))
                      .toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
          timerPredict = Timer(Duration(seconds: 0), () {});
    } else {
      totalDuration = Duration(seconds: meditationModel?.duration ?? 0);
      optimizeMeditation();
    }

    const updateInterval =
        Duration(milliseconds: 33); // Update the progress 30 times per second
    elapsedSeconds = 0;

    timer = Timer.periodic(updateInterval, (timer) async {
      progress = elapsedSeconds / totalDuration.inSeconds;
      if (state == BreathingStepType.HOLD) {
        if (stateCounter == 1) {
          // Hold after Inhale
          stateProgress = 1;
        } else {
          // Hold after exhale
          stateProgress = 0;
        }
        kaleidoscopeMultiplier = 0;
      } else if (state == BreathingStepType.EXHALE) {
        stateProgress = timeLeft / totalTimePerState;
        kaleidoscopeMultiplier = -1;
      } else if (state == BreathingStepType.INHALE) {
        stateProgress = 1 - (timeLeft / totalTimePerState);
        kaleidoscopeMultiplier = 1;
      }

      elapsedSeconds += 33 / 1000;
      timeLeft -= 33 / 1000;
      if (timeLeft < 0) {
        nextState();
        numberOfStateChanges++;
        if (numberOfStateChanges >= 6) {
          numberOfStateChanges = 0;
          if (!_meditationAIOptimizationService.mlModelIsAvailable()) {
            print("Changing params");
            changeSessionParams();
          }
        }
      }

      if (elapsedSeconds >= totalDuration.inSeconds && running) {
        running = false;
        finished = true;
        if (meditationModel != null) {
          meditationModel!.completedSession = true;
          _allMeditationsRepository.addMeditation(meditationModel!);

          await _trainingDataRepository.addTrainingsData(
              meditationModel!,
              totalDuration.inSeconds,
              _settingsRepository.kaleidoscopeOptions!);
          await _meditationAIOptimizationService.trainModel();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageView(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          print("Warning: meditationModel is null.");
        }
      }
      notifyListeners();
    });
  }

  // We want to wait the first 30 seconds and creating the first predict request after one minute
  bool waitedFirst30Seconds = false;

  // TODO call in init
  void optimizeMeditation() {
    if (_meditationAIOptimizationService.mlModelIsAvailable()) {
      timerPredict =
          Timer.periodic(const Duration(seconds: 30), (Timer timer) async {
        waitedFirst30Seconds = true;
        if (waitedFirst30Seconds) {
          // try to retrain model
          await _meditationAIOptimizationService.trainModel();

          // TODO after enough data in current session were collected create PredictionRequestModel like below

          PredictionParametersModel currentParameters =
              _trainingDataRepository.getPredictionData(
                  meditationModel!,
                  elapsedSeconds.toInt() + 1,
                  _settingsRepository.kaleidoscopeOptions!,
                  15);

          PredictionRequestModel model = PredictionRequestModel(
              currentParameters.heartRates,
              currentParameters.binauralBeats,
              currentParameters.visualizations,
              currentParameters.breathingMultipliers,
              settingsModel!.uuid!);

          PredictionResponseModel? recommendedParameters =
              await _meditationAIOptimizationService.predict(model);
          if (recommendedParameters != null) {
            print("Update meditation parameters" +
                recommendedParameters.toString());

            String newVisualization = _settingsRepository
                .kaleidoscopeOptions![recommendedParameters.visualization];
            meditationModel!.sessionParameters.add(SessionParameterModel(
                visualization: newVisualization,
                binauralFrequency:
                    recommendedParameters.binauralBeatsInHz.toInt(),
                breathingMultiplier: recommendedParameters.breathFrequency,
                breathingPattern: BreathingPatternType.fourSevenEight,
                heartRates: []));
          }
        }
        waitedFirst30Seconds = true;
      });
    }
  }

  Future<void> cancelSession() async {
    if (running) {
      running = false;
      if (meditationModel != null) {
        meditationModel!.duration = elapsedSeconds.toInt();
        _allMeditationsRepository.addMeditation(meditationModel!);

        await _trainingDataRepository.addTrainingsData(meditationModel!,
            totalDuration.inSeconds, _settingsRepository.kaleidoscopeOptions!);
      } else {
        print("Warning: meditationModel is null.");
      }
    }
  }

  String getRandomVisualization() {
    Random random = Random();
    int randomIndex = random.nextInt(
        _settingsRepository.kaleidoscopeOptions != null
            ? _settingsRepository.kaleidoscopeOptions!.length
            : 0);
    return _settingsRepository.kaleidoscopeOptions![randomIndex];
  }

  double getRandomBreathingMultiplier() {
    Random random = Random();
    // Generate a random double between 0.5 and 1.5
    return 0.5 + random.nextDouble();
  }

  int getRandomBinauralBeats() {
    Random random = Random();
    return random.nextInt(31);
  }

  void changeSessionParams() {
    meditationModel!.sessionParameters.add(SessionParameterModel(
        visualization: getRandomVisualization(),
        binauralFrequency: getRandomBinauralBeats(),
        breathingMultiplier: getRandomBreathingMultiplier(),
        breathingPattern: BreathingPatternType.fourSevenEight,
        heartRates: []));
  }

  void nextState() {
    stateCounter++;
    if (breathingPattern!.steps.length <= stateCounter) {
      stateCounter = 0;
    }

    state = breathingPattern!.steps[stateCounter].type;
    timeLeft = breathingPattern!.steps[stateCounter].duration *
        getLatestSessionParamaters().breathingMultiplier;
    totalTimePerState = breathingPattern!.steps[stateCounter].duration *
        getLatestSessionParamaters().breathingMultiplier;
  }

  void _initSession() {
    if (!_bluetoothRepository.isAvailableAndConnected()) {
      // Start the timer to update the last data point every second
      heartRateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        // Simulate heart rate values
        heartRate = 60 + DateTime.now().microsecondsSinceEpoch % 60;
        _meditationRepository.addHeartRate(
            meditationModel!, (elapsedSeconds * 1000).toInt(), heartRate);
        heartRateGraphKey.currentState?.refreshHeartRate();
      });
    }

    // start playing binaural beats
    playBinauralBeats(600, 200);
  }

  Future<bool> playBinauralBeats(
      double frequencyLeft, double frequencyRight) async {
    //TODO give other arguments to service
    return await _binauralBeatsRepository.playBinauralBeats(500, 600, 0, 0, 10);
  }

  void getHeartRateData() async {
    Stream<int> heartRateStream = await _bluetoothRepository.getHeartRate();
    heartRateStream.listen((measurement) {
      heartRate = measurement + .0;
      _meditationRepository.addHeartRate(
          meditationModel!, (elapsedSeconds * 1000).toInt(), heartRate);
      heartRateGraphKey.currentState?.refreshHeartRate();
    });
  }

  @override
  void dispose() {
    cancelSession();

    _bluetoothRepository.stopHeartRateMeasurement();
    if (heartRateTimer.isActive) {
      heartRateTimer.cancel();
    }
    if (timer.isActive) {
      timer.cancel();
    }
    if (_meditationAIOptimizationService.mlModelIsAvailable() &&  timerPredict.isActive) {
      timerPredict.cancel();
    }
    super.dispose();
  }
}
