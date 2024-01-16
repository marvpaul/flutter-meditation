/// {@category ViewModel}
library session_page_view_model;

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
import 'package:flutter_meditation/session/data/model/session_parameter_optimization.dart';
import 'package:flutter_meditation/session/data/repository/breathing_pattern_repository.dart';
import 'package:flutter_meditation/session/data/repository/impl/breathing_pattern_repository_local.dart';
import 'package:flutter_meditation/session/data/repository/session_parameter_optimization_repository.dart';
import 'package:flutter_meditation/session/data/service/meditation_session_validation_service.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/widgets/heart_rate_graph.dart';
import 'package:injectable/injectable.dart';
import 'package:vibration/vibration.dart';
import '../../di/Setup.dart';
import 'package:flutter_meditation/session/data/repository/impl/binaural_beats_repository_local.dart';
import 'package:flutter_meditation/session/data/repository/binaural_beats_repository.dart';
import '../../settings/data/repository/bluetooth_connection_repository.dart';
import '../../settings/data/service/mi_band_bluetooth_service.dart';
import '../data/repository/impl/session_parameter_optimization_middleware_repository.dart';

@injectable
class SessionPageViewModel extends BaseViewModel {
  /// The current instance of the [MeditationModel] for the session.
  /// This stores a list of [SessionParameterModel] and settings like the duration of the current session.
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
  final SessionParameterOptimizationRepository
      _sessionParameterOptimizationRepository =
      getIt<SessionParameterOptimizationMiddlewareRepository>();
  final MeditationSessionValidationService _meditationSessionValidationService =
      getIt<MeditationSessionValidationService>();
  final BinauralBeatsRepository _binauralBeatsRepository =
      getIt<BinauralBeatsRepositoryLocal>();

  /// Flag indicating whether to show the UI.
  bool showUI = true;

  /// Multiplier for the kaleidoscope effect.
  double kaleidoscopeMultiplier = 0;

  /// Counter for the current state of the breathing pattern.
  int stateCounter = 0;

  /// Flag indicating whether the session is running.
  bool running = false;

  /// Flag indicating whether the session has finished.
  bool finished = false;

  /// Current state of the breathing pattern.
  BreathingStepType state = BreathingStepType.INHALE;

  /// Time left for the current state in the breathing pattern.
  double timeLeft = 0;

  /// Total time for the current state in the breathing pattern.
  double totalTimePerState = 0;
  double progress = 0.0;

  /// Progress within the current state of the breathing pattern.
  double stateProgress = 0.0;

  /// Timer for updating the session progress.
  late Timer timer;
  Timer? heartRateTimer;

  /// Total duration of the meditation session.
  Duration totalDuration = const Duration();

  /// Elapsed seconds during the start of our meditation session.
  double elapsedSeconds = 0;
  final GlobalKey<HeartRateGraphState> heartRateGraphKey =
      GlobalKey<HeartRateGraphState>();

  var context;

  /// Current heart rate during the meditation session.
  double heartRate = 0;

  /// List of heart rates recorded during the session.
  List<double> heartRates = <double>[];

  /// Number of data points we want to display concurrently in our heart rate visualization graph.
  int nrDatapoints = 6;

  /// List of data points for heart rate visualization.
  List<FlSpot> dataPoints = [];

  bool get deviceIsConnected => _isConnected;

  /// Internal flag indicating whether the fitness tracker / bluetooth device is connected.
  late bool _isConnected;

  /// Indicates whether the ViewModel has been disposed.
  /// This is used to prevent errors when the ViewModel is disposed and the UI is updated.
  bool _isDisposed = false;

  /// Indicates whether AI with parameter optimization and training is enabled.
  bool get isAiModeEnabled => _isAiModeEnabled;
  bool _isAiModeEnabled = false;

  /// Retrieves the latest session parameters.
  /// Get them from the corresponding repository or generate a new SessionParameterModel object with default parameters.
  SessionParameterModel getLatestSessionParameters() {
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

  /// Updates the heart rate visualization data points.
  /// We use the heart rates saved in our [SessionParameterModel]
  /// and add them to [dataPoints] which we use for drawing a chart visualizing the heart rate in real-time.
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

  /// Initializes the meditation session with the provided [context].
  ///
  /// We use the [context] to navigate back after our meditation sessions ended (time elasped).
  /// Here we create an update loop / timer which will update our UI with 30 FPS
  Future<void> initWithContext(BuildContext context) async {
    _isConnected = _bluetoothRepository.isAvailableAndConnected();
    if (_isConnected) {
      getHeartRateData();
    }

    _isAiModeEnabled =
        await _sessionParameterOptimizationRepository.isAiModeEnabled.first;

    meditationModel = await _meditationRepository.createNewMeditation(
        showKaleidoscope: _isAiModeEnabled);
    final SettingsModel currentSettings =
        await _settingsRepository.getSettings();
    settingsModel = currentSettings;
    breathingPattern = await _breathingPatternRepository
        .getBreathingPatternByName(settingsModel!.breathingPattern);

    state = breathingPattern!.steps[stateCounter].type;
    timeLeft = breathingPattern!.steps[stateCounter].duration *
        getLatestSessionParameters().breathingMultiplier;
    totalTimePerState = breathingPattern!.steps[stateCounter].duration *
        getLatestSessionParameters().breathingMultiplier;
    _initSession(currentSettings);
    running = true;

    totalDuration = Duration(seconds: meditationModel?.duration ?? 0);
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
        // change session parameters every 2 breathing cycles
        // - changed to 1 for demo purposes as requests take too long
        if (numberOfStateChanges >= 3 && running) {
          numberOfStateChanges = 0;
          final MeditationModel validatedMeditationSession =
              _meditationSessionValidationService
                  .validateMeditationSession(meditationModel!);
          if (_isAiModeEnabled) {
            try {
              final SessionParameterOptimization? sessionParameterOptimization =
                  await _sessionParameterOptimizationRepository
                      .getSessionParameterOptimization(
                          validatedMeditationSession);
              changeSessionParams(sessionParameterOptimization);
            } catch (e) {
              changeSessionParams(null);
              print(e);
            }
          }
        }
      }

      if (elapsedSeconds >= totalDuration.inSeconds && running) {
        running = false;
        finished = true;
        if (meditationModel != null) {
          meditationModel!.completedSession = true;
          stopBinauralBeats();
          final MeditationModel validatedMeditationSession =
              _meditationSessionValidationService
                  .validateMeditationSession(meditationModel!);
          try {
            _sessionParameterOptimizationRepository
                .trainSessionParameterOptimization(validatedMeditationSession);
            // make sure data was written to db. This should be changed when
            // logic is split to two endpoints
            await Future.delayed(const Duration(milliseconds: 250));
          } catch (e) {
            print(e);
          }
          _allMeditationsRepository.addMeditation(validatedMeditationSession);
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
      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  /// Cancels the current meditation session.
  /// We want to stop binaural beats and save the meditation session.
  void cancelSession() {
    if (running) {
      running = false;
      if (meditationModel != null) {
        meditationModel!.duration = elapsedSeconds.toInt();
        stopBinauralBeats();
        _allMeditationsRepository.addMeditation(meditationModel!);
      } else {
        print("Warning: meditationModel is null.");
      }
    }
    if (heartRateTimer != null && heartRateTimer!.isActive) {
      heartRateTimer!.cancel();
    }
    if (timer.isActive) {
      timer.cancel();
    }
  }

  /// Generates a random visualization for the session.
  /// We use one option from kaleidoscopeOptions.
  /// Each visualization has a corresponding image which is saved in the asset folder and loaded into
  /// a fragment shader to create a mandala effect.
  String getRandomVisualization() {
    Random random = Random();
    int randomIndex = random.nextInt(
        _settingsRepository.kaleidoscopeOptions != null
            ? _settingsRepository.kaleidoscopeOptions!.length
            : 0);
    return _settingsRepository.kaleidoscopeOptions![randomIndex];
  }

  /// Generates a random breathing multiplier for the session.
  double getRandomBreathingMultiplier() {
    Random random = Random();
    // Generate a random double between 0.5 and 1.5
    return 0.5 + random.nextDouble();
  }

  /// Generates a random binaural beats frequency for the session. We want to have them between 300 and 500 Hz
  int getRandomBinauralBeats() {
    Random random = Random();
    return 2 + random.nextInt(29);
  }

  /// Changes the session parameters based on optimization or randomization.
  /// We first start to generate random parameters every 2 breathing cycles and collect data from the user.
  /// After the user meditated 20 minutes, we can train a data prediction model.
  /// After initial we'll use parameters suggested by the model.
  void changeSessionParams(
      SessionParameterOptimization? sessionParameterOptimization) async {
    if (_isDisposed) return;
    bool needsToBeRandomized = sessionParameterOptimization == null;
    meditationModel!.sessionParameters.add(SessionParameterModel(
        visualization: needsToBeRandomized
            ? getRandomVisualization()
            : sessionParameterOptimization.visualization,
        binauralFrequency: needsToBeRandomized
            ? getRandomBinauralBeats()
            : sessionParameterOptimization.beatFrequency,
        breathingMultiplier: needsToBeRandomized
            ? getRandomBreathingMultiplier()
            : sessionParameterOptimization.breathingPatternMultiplier,
        breathingPattern: BreathingPatternType.fourSevenEight,
        heartRates: []));
    double freq = (getLatestSessionParameters().binauralFrequency)!.toDouble();
    if (settingsModel!.isBinauralBeatEnabled || _isAiModeEnabled) {
      playBinauralBeats(100, 100 + freq);
    }
  }

  /// Moves to the next state in the breathing pattern.
  /// If we iterated over every state in our [breathingPattern], we just start from the beginning again.
  void nextState() async {
    stateCounter++;
    if (breathingPattern!.steps.length <= stateCounter) {
      stateCounter = 0;
    }

    state = breathingPattern!.steps[stateCounter].type;
    timeLeft = breathingPattern!.steps[stateCounter].duration *
        getLatestSessionParameters().breathingMultiplier;
    totalTimePerState = breathingPattern!.steps[stateCounter].duration *
        getLatestSessionParameters().breathingMultiplier;

    bool hasVibrator = await Vibration.hasVibrator() ?? false;
    if (settingsModel!.isHapticFeedbackEnabled && hasVibrator) {
      // vibrate shortly to indicate a change in the breathing pattern
      Vibration.vibrate(duration: 30, intensities: [64]);
    }
  }

  /// Initializes the session with the provided [settings].
  /// If we have no bluetooth connection established we use dummy data for our heart rate which will be generated every second.
  void _initSession(SettingsModel settings) {
    if (!_bluetoothRepository.isAvailableAndConnected()) {
      // Start the timer to update the last data point every second
      heartRateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        // Simulate heart rate values
        heartRate = 60 + DateTime.now().microsecondsSinceEpoch % 60;
        _meditationRepository.addHeartRate(
            meditationModel!,
            meditationModel!.timestamp.toInt() + elapsedSeconds.toInt(),
            heartRate);
        heartRateGraphKey.currentState?.refreshHeartRate();
      });
    }

    if (settings.isBinauralBeatEnabled || _isAiModeEnabled) {
      playBinauralBeats(100, 102);
    }
  }

  /// Plays binaural beats with the specified left and right frequencies.
  Future<bool> playBinauralBeats(
      double frequencyLeft, double frequencyRight) async {
    // avoid calculation of duration and pass any number higher than the period
    return await _binauralBeatsRepository.playBinauralBeats(
        frequencyLeft, frequencyRight, 90);
  }

  /// Stops the currently playing binaural beats. We need to call this when the session ends to prevent the user from hearing the binaural beats in the main menu.
  Future<bool> stopBinauralBeats() async {
    return await _binauralBeatsRepository.stopBinauralBeats();
  }

  /// Retrieves heart rate data from the fitness tracker, e.g. MiBand via Bluetooth .
  void getHeartRateData() async {
    Stream<int> heartRateStream = await _bluetoothRepository.getHeartRate();
    heartRateStream.listen((measurement) {
      if (measurement > 0) {
        heartRate = measurement + .0;
        _meditationRepository.addHeartRate(
            meditationModel!,
            meditationModel!.timestamp.toInt() + elapsedSeconds.toInt(),
            heartRate);
        heartRateGraphKey.currentState?.refreshHeartRate();
      }
    });
  }

  /// Disposes of timers when the view model is no longer active.
  @override
  void dispose() {
    cancelSession();

    _bluetoothRepository.stopHeartRateMeasurement();
    _isDisposed = true;
    super.dispose();
  }
}
