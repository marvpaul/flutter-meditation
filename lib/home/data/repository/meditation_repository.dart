import 'package:flutter_meditation/home/data/model/meditation_model.dart';

abstract class MeditationRepository {
  static const String sessionKey = "meditation";

  Future<MeditationModel?> getMeditation();
  Future<MeditationModel?> createNewMeditation();
  void saveMeditation(MeditationModel settings);
  void restoreMeditation();
}
