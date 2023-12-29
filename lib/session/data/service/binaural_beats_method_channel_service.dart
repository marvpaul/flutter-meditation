import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:developer';

import 'package:injectable/injectable.dart';

@singleton
class BinauralBeatsMethodChannelService {
  static const platform =
      MethodChannel('htw.berlin.de/public_health/binaural_beats');

  Future<bool> playBinauralBeat(
      double frequencyLeft,
      double frequencyRight,
      double duration
      ) async {
    log("playBinauralBeatAndroid called with frequencyLeft: $frequencyLeft, frequencyRight: $frequencyRight, duration: $duration");

    try {
      bool? isPlaying = await platform.invokeMethod<bool>('playBinauralBeat', {
        'frequencyLeft': frequencyLeft,
        'frequencyRight': frequencyRight,
        'duration': duration,
      });
      bool actualIsPlaying = isPlaying ?? false;
      return actualIsPlaying;
    } on PlatformException catch (e) {
      log("Error playing binaural beat: '${e.message}'.");
      return false;
    }
  }
  Future<bool> stopBinauralBeats() async {
    log("stop binaural beats method channel call to native iOS / Android");

    try {
      // TODO: give other parameters to native code
      bool? isPlaying = await platform.invokeMethod<bool>('stopBinauralBeat');
      bool stopped = isPlaying ?? false;

      log("Method on android executed, result: $stopped");

      return stopped;
    } on PlatformException catch (e) {
      log("Error stopping binaural beat: '${e.message}'.");
      return false;
    }
  }
}
