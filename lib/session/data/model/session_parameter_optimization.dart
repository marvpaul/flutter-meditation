/// Class representing optimized session parameters for a meditation session.
///
/// We get this as a response from the backend / our machine learning model.
/// including beat frequency, visualization, and breathing pattern multiplier.
class SessionParameterOptimization {
  /// The beat frequency for the meditation session.
  final int beatFrequency;

  /// The visualization / kaleidoscope
  final String visualization;

  /// The multiplier applied to the breathing pattern's duration.
  final double breathingPatternMultiplier;

  /// Constructor for creating a [SessionParameterOptimization] instance.
  ///
  /// Requires [beatFrequency], [visualization], and [breathingPatternMultiplier]
  /// to be provided.
  SessionParameterOptimization({
    required this.beatFrequency,
    required this.visualization,
    required this.breathingPatternMultiplier,
  });
}
