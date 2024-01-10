import 'package:flutter_meditation/home/data/model/meditation_model.dart';

abstract class PastSessionsRepository {
  Stream<List<MeditationModel>> get pastSessionsStream;
  void fetchMeditationSessions();
}
