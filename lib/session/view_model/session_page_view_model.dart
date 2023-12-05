import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/common/BreathingState.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/impl/all_meditations_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/impl/meditation_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/all_meditations_repository.dart';
import 'package:flutter_meditation/home/data/repository/meditation_repository.dart';
import 'package:flutter_meditation/home/view/screens/home_page_view.dart';
import 'package:flutter_meditation/session/data/model/all_breathing_patterns_model.dart';
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

@injectable
class SessionPageViewModel extends BaseViewModel {
  MeditationModel? meditationModel;
  AllBreathingPatterns? allBreathingPatterns;
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

  List<BreathingState> breathingTechniques = [BreathingState.INHALE, BreathingState.HOLD, BreathingState.EXHALE];
  List<double> breathingDurations = [4, 7, 8];
  int stateCounter = 0;
  bool running = false;
  bool finished = false;
  BreathingState state = BreathingState.INHALE;
  double timeLeft = 0;
  double totalTimePerState = 0;
  String activeMeditationName = "4-7-8";
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
    allBreathingPatterns = await _breathingPatternRepository.getOrCreateBreathingPatterns();
    meditationModel = await _meditationRepository.createNewMeditation();
    settingsModel = await _settingsRepository.getSettings();
    _initSession();
    running = true;
    state = breathingTechniques[stateCounter];
    timeLeft = breathingDurations[stateCounter];
    totalTimePerState = breathingDurations[stateCounter];

    totalDuration = Duration(seconds: meditationModel?.duration ?? 0);
    const updateInterval =
        Duration(milliseconds: 33); // Update the progress 30 times per second
    elapsedSeconds = 0;

    timer = Timer.periodic(updateInterval, (timer) {
      progress = elapsedSeconds / totalDuration.inSeconds;
      if (state == BreathingState.HOLD) {
        stateProgress = 1;
        kaleidoscopeMultiplier = 0;
      } else if (state == BreathingState.EXHALE) {
        stateProgress = timeLeft / totalTimePerState;
        kaleidoscopeMultiplier = -1;
      } else if (state == BreathingState.INHALE) {
        stateProgress = 1 - (timeLeft / totalTimePerState);
        kaleidoscopeMultiplier = 1;
      }

      elapsedSeconds += 33 / 1000;
      timeLeft -= 33 / 1000;
      if (timeLeft < 0 && activeMeditationName != "Meditation timer") {
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
    if (breathingTechniques.length <= stateCounter) {
      stateCounter = 0;
    }
    state = breathingTechniques[stateCounter];
    timeLeft = breathingDurations[stateCounter];
    totalTimePerState = breathingDurations[stateCounter];
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

  void _nextState() {
    stateCounter++;
    if (breathingTechniques.length <= stateCounter) {
      stateCounter = 0;
    }
    state = breathingTechniques[stateCounter];
    timeLeft = breathingDurations[stateCounter];
    totalTimePerState = breathingDurations[stateCounter];
  }

  Future<bool> playBinauralBeats(
      double frequencyLeft, double frequencyRight) async {
    //TODO give other arguments to service
    return await _binauralBeatsRepository.playBinauralBeats(500, 600, 0, 0, 10);
  }

  @override
  void dispose() {
    if (heartRateTimer.isActive) {
      heartRateTimer.cancel();
    }
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }
}
