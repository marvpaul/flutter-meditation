abstract class BinauralBeatsRepository {
  Future<bool> playBinauralBeats(double frequencyLeft, double frequencyRight,
      double volumeLeft, double volumeRight, double duration);
  Future<bool> stopBinauralBeats();
}
