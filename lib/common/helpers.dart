String secondsToHRF(double totalSeconds) {
    int minutes = (totalSeconds / 60).floor();
    int seconds = (totalSeconds % 60).round();

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }