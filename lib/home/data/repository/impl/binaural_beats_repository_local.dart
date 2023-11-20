import 'package:flutter_meditation/home/data/repository/binaural_beats_repository.dart';
import 'package:flutter_meditation/home/data/service/binaural_beats_android_service.dart';
import 'package:injectable/injectable.dart';
import '../../../../di/Setup.dart';

@singleton
class BinauralBeatsRepositoryLocal implements BinauralBeatsRepository {
  BinauralBeatsRepositoryLocal();

  final BinauralBeatsAndroidService _binauralBeatsService =
      getIt<BinauralBeatsAndroidService>();

  @override
  Future<bool> playBinauralBeats(double frequencyLeft, double frequencyRight,
      double volumeLeft, double volumeRight, double duration) async {
    var isPlaying = await _binauralBeatsService.playBinauralBeatAndroid(
        frequencyLeft, frequencyRight, volumeLeft, volumeRight, duration);
    return isPlaying;
  }
}