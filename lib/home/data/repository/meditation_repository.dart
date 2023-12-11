import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/session_parameter_model.dart';

abstract class MeditationRepository {
  static const String sessionKey = "meditation";

  Future<MeditationModel?> getMeditation();
  Future<MeditationModel?> createNewMeditation();
  void saveMeditation(MeditationModel settings);
  double getAverageHeartRate(MeditationModel model); 
  double getMinHeartRate(MeditationModel model); 
  double getMaxHeartRate(MeditationModel model); 
  void restoreMeditation();
  void addHeartRate(MeditationModel model, int timestamp, double heartRate);
  SessionParameterModel getLatestSessionParamaters(MeditationModel model); 
}
