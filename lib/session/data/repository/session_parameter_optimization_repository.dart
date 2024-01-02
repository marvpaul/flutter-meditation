import 'package:flutter_meditation/home/data/model/meditation_model.dart';

abstract class SessionParameterOptimizationRepository {
  // Future<SessionParameterOptimization> getSessionParameterOptimization(
  //     PastSession session
  //     );
  Future<void> trainSessionParameterOptimization(
      MeditationModel sessionParameterOptimization
      );
  Stream<bool> get isAiModeAvailable;
  Stream<bool> get isAiModeEnabled;
  void changeAiMode(bool isEnabled);
}

class SessionParameterOptimization {
  final double beatFrequency;
  final String visualization;
  final double breathingPatternMultiplier;

  SessionParameterOptimization({
    required this.beatFrequency,
    required this.visualization,
    required this.breathingPatternMultiplier
  });
}