/// {@category Service}
/// Service for handling binaural beats functionality using method channels. We implemented a native solution for Android and iOS.
///
/// This service communicates with native code to play and stop binaural beats.
library binaural_beats_method_channel_service;
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:developer';

import 'package:injectable/injectable.dart';

/// Service for handling binaural beats functionality using method channels. We implemented a native solution for Android and iOS.
///
/// This service communicates with native code to play and stop binaural beats.
@singleton
class BinauralBeatsMethodChannelService {
  static const platform =
      MethodChannel('htw.berlin.de/public_health/binaural_beats');

  /// Plays binaural beats with the specified frequencies.
  ///
  /// Returns `true` if the operation is successful, otherwise returns `false`.
  Future<bool> playBinauralBeat(
    double frequencyLeft,
    double frequencyRight,
    double duration,
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

  /// Stops playing binaural beats.
  ///
  /// Returns `true` if the operation is successful, otherwise returns `false`.
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
