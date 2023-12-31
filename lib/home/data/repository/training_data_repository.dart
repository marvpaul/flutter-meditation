
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/model/training_data_model.dart';

abstract class TrainingDataRepository{
  static const String trainingDataKey = "training_data";
  Future<TrainingDataModel?> getTrainingsData();
  void addTrainingsData(MeditationModel model, int duration, List<String> kaleidoscopeOptions);
  void saveData(TrainingDataModel data);
}