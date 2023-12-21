import 'dart:io';

import 'package:flutter_meditation/session/data/repository/binaural_beats_repository.dart';
import 'package:flutter_meditation/session/data/service/binaural_beats_method_channel_service.dart';
import 'package:injectable/injectable.dart';

import '../../../../di/Setup.dart';

@singleton
class BinauralBeatsRepositoryLocal implements BinauralBeatsRepository {
  BinauralBeatsRepositoryLocal();

  final BinauralBeatsMethodChannelService _binauralBeatsService =
      getIt<BinauralBeatsMethodChannelService>();

  @override
  Future<bool> playBinauralBeats(double frequencyLeft, double frequencyRight,
      double volumeLeft, double volumeRight, double duration) async {
    if (Platform.isAndroid || Platform.isIOS) {
      var isPlaying = await _binauralBeatsService.playBinauralBeat(
          frequencyLeft, frequencyRight, volumeLeft, volumeRight, duration);
      return isPlaying;
    } else {
      return false;
    }
  }
  @override
  Future<bool> stopBinauralBeats() async {
    if (Platform.isAndroid || Platform.isIOS) {
      var isStopped = await _binauralBeatsService.stopBinauralBeats();
      return isStopped;
    } else {
      return false;
    }
  }
}
