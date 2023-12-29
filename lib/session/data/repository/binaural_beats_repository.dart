abstract class BinauralBeatsRepository {
  Future<bool> playBinauralBeats(
      double frequencyLeft,
      double frequencyRight,
      double duration
      );
  Future<bool> stopBinauralBeats();
}
