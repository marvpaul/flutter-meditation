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
      double volumeLeft,
      double volumeRight,
      double duration) async {
    log("playBinauralBeatAndroid called with frequencyLeft: $frequencyLeft, frequencyRight: $frequencyRight");

    try {
      // TODO: give other parameters to native code
      bool? isPlaying = await platform.invokeMethod<bool>('playBinauralBeat', {
        'frequencyLeft': frequencyLeft,
        'frequencyRight': frequencyRight,
      });
      bool actualIsPlaying = isPlaying ?? false;

      log("Method on android executed, result: $actualIsPlaying");

      return actualIsPlaying;
    } on PlatformException catch (e) {
      log("Error playing binaural beat: '${e.message}'.");
      return false;
    }
  }
}
