import 'package:flutter_meditation/session/data/repository/binaural_beats_repository.dart';
import 'package:flutter_meditation/session/data/service/binaural_beats_android_service.dart';
import 'package:injectable/injectable.dart';
import '../../../../di/Setup.dart';
import 'dart:math';

@singleton
class BinauralBeatsRepositoryLocal implements BinauralBeatsRepository {
  BinauralBeatsRepositoryLocal();

  final BinauralBeatsAndroidService _binauralBeatsService =
      getIt<BinauralBeatsAndroidService>();

  // TODO implement iOS version

  @override
  Future<bool> playBinauralBeats() async {
    // TODO we need to specifiy the frequency here
    // we need the logic to vary the frequency based on the different binaural beats
    // but where to put the logic? in a separate layer?

    // For testing generate random frequencies
    var random = Random();
    var frequencyLeft = 200 + random.nextDouble() * 800;
    var frequencyRight = frequencyLeft + 100;

    var isPlaying = await _binauralBeatsService.playBinauralBeatAndroid(
        frequencyLeft, frequencyRight);
    return isPlaying;
  }

  @override
  Future<void> stopBinauralBeats() async {
    await _binauralBeatsService.stopBinauralBeatAndroid();
  }
}
