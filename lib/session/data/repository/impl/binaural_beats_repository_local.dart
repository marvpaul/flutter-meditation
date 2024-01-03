/// {@category Repository}
/// Repository responsible for handling local operations related to binaural beats.
library binaural_beats_repository_local;
import 'dart:io';
import 'package:flutter_meditation/session/data/repository/binaural_beats_repository.dart';
import 'package:flutter_meditation/session/data/service/binaural_beats_method_channel_service.dart';
import 'package:injectable/injectable.dart';
import '../../../../di/Setup.dart';

/// Repository responsible for handling local operations related to binaural beats.
///
/// This class implements the [BinauralBeatsRepository] interface, providing
/// methods to play and stop binaural beats locally using a method channel service.
/// It checks the platform before invoking the service methods to ensure
/// compatibility with Android and iOS platforms.
@singleton
class BinauralBeatsRepositoryLocal implements BinauralBeatsRepository {
  BinauralBeatsRepositoryLocal();

  /// Service responsible for interacting with the binaural beats functionality
  /// through a method channel.
  final BinauralBeatsMethodChannelService _binauralBeatsService =
      getIt<BinauralBeatsMethodChannelService>();

  /// Play binaural beats with the specified left and right frequencies.
  ///
  /// Returns `true` if the operation was successful and we were able to start the binaural beats.
  @override
  Future<bool> playBinauralBeats(
    double frequencyLeft,
    double frequencyRight,
    double duration,
  ) async {
    if (Platform.isAndroid || Platform.isIOS) {
      var isPlaying = await _binauralBeatsService.playBinauralBeat(
        frequencyLeft,
        frequencyRight,
        duration,
      );
      return isPlaying;
    } else {
      return false;
    }
  }

  /// Stop playing the currently active binaural beats.
  ///
  /// Returns `true` if we were able to stop the audio, otherwise `false`.
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
