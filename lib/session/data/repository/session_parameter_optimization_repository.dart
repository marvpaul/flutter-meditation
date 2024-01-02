abstract class SessionParameterOptimizationRepository {
  // Future<SessionParameterOptimization> getSessionParameterOptimization(
  //     PastSession session
  //     );
  // Future<void> trainSessionParameterOptimization(
  //     PastSession sessionParameterOptimization
  //     );
  Stream<bool> get isAiModeAvailable;
  Stream<bool> get isAiModeEnabled;
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