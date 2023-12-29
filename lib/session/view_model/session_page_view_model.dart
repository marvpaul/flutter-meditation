import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/session_parameter_model.dart';
import 'package:flutter_meditation/home/data/repository/impl/all_meditations_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/impl/meditation_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/all_meditations_repository.dart';
import 'package:flutter_meditation/home/data/repository/meditation_repository.dart';
import 'package:flutter_meditation/home/view/screens/home_page_view.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:flutter_meditation/session/data/repository/breathing_pattern_repository.dart';
import 'package:flutter_meditation/session/data/repository/impl/breathing_pattern_repository_local.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/widgets/heart_rate_graph.dart';
import 'package:injectable/injectable.dart';
import '../../di/Setup.dart';
import 'package:flutter_meditation/session/data/repository/impl/binaural_beats_repository_local.dart';
import 'package:flutter_meditation/session/data/repository/binaural_beats_repository.dart';

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
  final SettingsRepositoryLocal _settingsRepository =
      getIt<SettingsRepositoryLocal>();
  final BluetoothConnectionRepository _bluetoothRepository =
      getIt<MiBandBluetoothService>();

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
  late Timer timer, heartRateTimer;
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
    final SettingsModel currentSettings = await _settingsRepository.getSettings();
    settingsModel = currentSettings;
    breathingPattern = await _breathingPatternRepository
        .getBreathingPatternByName(settingsModel!.breathingPattern);

    state = breathingPattern!.steps[stateCounter].type;
    timeLeft = breathingPattern!.steps[stateCounter].duration *
        getLatestSessionParamaters().breathingMultiplier;
    totalTimePerState = breathingPattern!.steps[stateCounter].duration *
        getLatestSessionParamaters().breathingMultiplier;
    _initSession(currentSettings);
    running = true;

    totalDuration = Duration(seconds: meditationModel?.duration ?? 0);
    const updateInterval =
        Duration(milliseconds: 33); // Update the progress 30 times per second
    elapsedSeconds = 0;

    timer = Timer.periodic(updateInterval, (timer) {
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
          print("Changing params");
          changeSessionParams();
        }
      }

      if (elapsedSeconds >= totalDuration.inSeconds && running) {
        running = false;
        finished = true;
        if (meditationModel != null) {
          meditationModel!.completedSession = true;
          stopBinauralBeats(); 
          _allMeditationsRepository.addMeditation(meditationModel!);
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

  void cancelSession() {
    if (running) {
      running = false;
      if (meditationModel != null) {
        meditationModel!.duration = elapsedSeconds.toInt(); 
        print(meditationModel);
        stopBinauralBeats(); 
        _allMeditationsRepository.addMeditation(meditationModel!);
      } else {
        print("Warning: meditationModel is null.");
      }
    }
  }

  String getRandomVisualization() {
    Random random = Random();
    int randomIndex =
        random.nextInt(_settingsRepository.kaleidoscopeOptions!= null?_settingsRepository.kaleidoscopeOptions!.length:0);
    return _settingsRepository.kaleidoscopeOptions![randomIndex];
  }

  double getRandomBreathingMultiplier() {
    Random random = Random();
    // Generate a random double between 0.5 and 1.5
    return 0.5 + random.nextDouble();
  }

  int getRandomBinauralBeats() {
    Random random = Random();
    return 300+random.nextInt(200);
  }

  void changeSessionParams() {
    meditationModel!.sessionParameters.add(SessionParameterModel(
        visualization: getRandomVisualization(),
        binauralFrequency: getRandomBinauralBeats(),
        breathingMultiplier: getRandomBreathingMultiplier(),
        breathingPattern: BreathingPatternType.fourSevenEight,
        heartRates: []));
        double freq = (getLatestSessionParamaters().binauralFrequency)!.toDouble(); 
        playBinauralBeats((freq), freq+100); 
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

  void _initSession(SettingsModel settings) {
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

    if (settings.isBinauralBeatEnabled) {
      playBinauralBeats(500, 600);
    }
  }

  Future<bool> playBinauralBeats(
      double frequencyLeft, double frequencyRight) async {
    //TODO give other arguments to service
    return await _binauralBeatsRepository.playBinauralBeats(frequencyLeft, frequencyRight, 90);
  }
  Future<bool> stopBinauralBeats() async {
    //TODO give other arguments to service
    return await _binauralBeatsRepository.stopBinauralBeats();
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
    super.dispose();
  }
}
