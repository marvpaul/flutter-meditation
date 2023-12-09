import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
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
import 'package:flutter_meditation/settings/data/repository/settings_repository.dart';
import 'package:flutter_meditation/widgets/heart_rate_graph.dart';
import 'package:injectable/injectable.dart';
import '../../di/Setup.dart';
import 'package:flutter_meditation/session/data/repository/impl/binaural_beats_repository_local.dart';
import 'package:flutter_meditation/session/data/repository/binaural_beats_repository.dart';
import '../../settings/data/repository/bluetooth_connection_repository.dart';
import '../../settings/data/service/mi_band_bluetooth_service.dart';
import '../data/repository/impl/session_repository_local.dart';
import '../data/repository/session_repository.dart';

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
  final SettingsRepository _settingsRepository =
      getIt<SettingsRepositoryLocal>();

  bool showUI = true;
  double kaleidoscopeMultiplier = 0;

  final BinauralBeatsRepository _binauralBeatsRepository =
      getIt<BinauralBeatsRepositoryLocal>();

  final SessionRepository _sessionRepository = getIt<SessionRepositoryLocal>();
  final BluetoothConnectionRepository _bluetoothRepository =
  getIt<MiBandBluetoothService>();
  List<String> breathingTechniques = ["Inhale", "Hold", "Exhale"];
  List<double> breathingDurations = [4, 7, 8];
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

  bool get deviceIsConnected => _isConnected;
  late bool _isConnected;

  SessionPageViewModel() {
  int nrDatapoints = 6;
  List<FlSpot> dataPoints = [];

  void updateHeartRate() {
    List<double> lastHeartRates =
        meditationModel!.heartRates.values.toList(growable: false);
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
    meditationModel = await _meditationRepository.createNewMeditation();
    settingsModel = await _settingsRepository.getSettings();
    breathingPattern = await _breathingPatternRepository
        .getBreathingPatternByName(settingsModel!.breathingPattern);

    state = breathingPattern!.steps[stateCounter].type;
    timeLeft = breathingPattern!.steps[stateCounter].duration;
    totalTimePerState = breathingPattern!.steps[stateCounter].duration;
    _initSession();
  }

  @override
  Future<void> init() async {
    _isConnected = _bluetoothRepository.isAvailableAndConnected();
    if(_isConnected){
      getHeartRateData();
    }
    notifyListeners();
  }

  void startTimer() {
    running = true; 
    state = breathingTechniques[stateCounter];
    timeLeft = breathingDurations[stateCounter];
    totalTimePerState = breathingDurations[stateCounter];
    running = true;

    double timeInMinutes = 0.1;
    totalDuration = Duration(seconds: (timeInMinutes * 1200).toInt());
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
      }

      if (elapsedSeconds >= totalDuration.inSeconds && running) {
        running = false;
        finished = true;
        if (meditationModel != null) {
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

  void nextState() {
    stateCounter++;
    if (breathingPattern!.steps.length <= stateCounter) {
      stateCounter = 0;
    }

    state = breathingPattern!.steps[stateCounter].type;
    timeLeft = breathingPattern!.steps[stateCounter].duration;
    totalTimePerState = breathingPattern!.steps[stateCounter].duration;
  }

  void _initSession() {
    // Start the timer to update the last data point every second
    heartRateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Simulate heart rate values
      heartRate = 60 + DateTime.now().microsecondsSinceEpoch % 60;
      meditationModel?.heartRates[(elapsedSeconds * 1000).toInt()] = heartRate;
      heartRateGraphKey.currentState?.refreshHeartRate();
    });

    // start playing binaural beats
    playBinauralBeats(600, 200);
  }

  Future<bool> playBinauralBeats(
      double frequencyLeft, double frequencyRight) async {
    //TODO give other arguments to service
    return await _binauralBeatsRepository.playBinauralBeats(500, 600, 0, 0, 10);
  }

  @override
  void dispose() {
    _bluetoothRepository.stopHeartRateMeasurement();
    heartRateTimer.cancel();
    timer.cancel();
    if (heartRateTimer.isActive) {
      heartRateTimer.cancel();
    }
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  void getHeartRateData() async{
    Stream<int> heartRateStream = await _bluetoothRepository.getHeartRate();
    heartRateStream.listen((measurement) {
      heartRate = measurement +.0;
      heartRates.add(heartRate);
      heartRateGraphKey.currentState?.updateLastDataPoint(FlSpot(6, heartRate));
    });
  }
}
