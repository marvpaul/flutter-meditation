import 'package:flutter_meditation/home/data/model/meditation_model.dart';

import '../model/session_parameter_optimization.dart';

abstract class SessionParameterOptimizationRepository {
  Future<SessionParameterOptimization?> getSessionParameterOptimization(
      MeditationModel session
      );
  Future<void> trainSessionParameterOptimization(
      MeditationModel sessionParameterOptimization
      );
  Stream<bool> get isAiModeAvailable;
  Stream<bool> get isAiModeEnabled;
  void changeAiMode(bool isEnabled);
}
