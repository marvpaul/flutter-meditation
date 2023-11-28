import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/widgets/heart_rate_graph.dart';
import 'package:injectable/injectable.dart';
import '../../di/Setup.dart';
import '../data/repository/impl/session_repository_local.dart';
import '../data/repository/session_repository.dart';
import 'package:flutter_meditation/session/data/repository/impl/binaural_beats_repository_local.dart';
import 'package:flutter_meditation/session/data/repository/binaural_beats_repository.dart';

@injectable
class SessionPageViewModel extends BaseViewModel {
  final SessionRepository _sessionRepository = getIt<SessionRepositoryLocal>();

  final BinauralBeatsRepository _binauralBeatsRepository =
      getIt<BinauralBeatsRepositoryLocal>();

  List<String> breathingTechniques = ["Inhale", "Hold", "Exhale"];
  List<double> breathingDurations = [4, 7, 8];
  int stateCounter = 0;
  bool running = false;
  String state = "Inhale";
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

  SessionPageViewModel() {
    _initSession();
  }

  void startTimer() {
    running = true;
    state = breathingTechniques[stateCounter];
    timeLeft = breathingDurations[stateCounter];
    totalTimePerState = breathingDurations[stateCounter];

    double timeInMinutes = 0.1;
    totalDuration = Duration(seconds: (timeInMinutes * 60).toInt());
    const updateInterval =
        Duration(milliseconds: 33); // Update the progress 30 times per second
    elapsedSeconds = 0;

    timer = Timer.periodic(updateInterval, (timer) {
      progress = elapsedSeconds / totalDuration.inSeconds;
      if (state == "Hold") {
        stateProgress = 1;
      } else if (state == "Exhale") {
        stateProgress = timeLeft / totalTimePerState;
      } else if (state == "Inhale") {
        stateProgress = 1 - (timeLeft / totalTimePerState);
      }

      elapsedSeconds += 33 / 1000;
      timeLeft -= 33 / 1000;
      if (timeLeft < 0 && activeMeditationName != "Meditation timer") {
        nextState();
      }

      if (elapsedSeconds >= totalDuration.inSeconds && running) {
        running = false;
        print("TODO: Save values about meditation");
        print(
            "Elasped time $elapsedSeconds secs, heart rates ${heartRates.toString()}");
        Navigator.pop(context);
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
    startTimer();

    // Start the timer to update the last data point every second
    heartRateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Simulate heart rate values
      heartRate = 60 + DateTime.now().millisecond % 60;
      heartRates.add(heartRate);
      heartRateGraphKey.currentState?.updateLastDataPoint(FlSpot(6, heartRate));
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
    heartRateTimer.cancel();
    timer.cancel();
    super.dispose();
  }
}
