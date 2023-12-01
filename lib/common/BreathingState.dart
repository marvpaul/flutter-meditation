enum BreathingState {
  HOLD,
  INHALE,
  EXHALE,
}

extension BreathingStateExtension on BreathingState {
  String get value {
    switch (this) {
      case BreathingState.HOLD:
        return 'Hold';
      case BreathingState.INHALE:
        return 'Inhale';
      case BreathingState.EXHALE:
        return 'Exhale';
    }
  }
}