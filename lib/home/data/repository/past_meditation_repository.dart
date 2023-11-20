
import 'package:flutter_meditation/home/data/model/meditation_model.dart';

abstract class MeditationRepository{
  Future<List<MeditationModel>?> getAllMeditation();
}