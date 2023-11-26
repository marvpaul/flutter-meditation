
import 'package:flutter_meditation/home/data/model/meditation_model.dart';

abstract class AllMeditationsRepository{
  static const String sessionKey = "all_meditations";
  Future<List<MeditationModel>?> getAllMeditation();
  void addMeditation(MeditationModel meditation);
  void saveMeditations(List<MeditationModel> meditations);
}