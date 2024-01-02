import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../home/data/model/meditation_model.dart';
import '../past_sessions_repository.dart';


@singleton
class PastSessionsRepositoryLocal implements PastSessionsRepository{
  final SharedPreferences prefs;
  PastSessionsRepositoryLocal(this.prefs);

  @override
  void fetchMeditationSessions() {
    // TODO: implement fetchMeditationSessions
    throw UnimplementedError();
  }

  @override
  // TODO: implement pastSessionsStream
  Stream<List<MeditationModel>> get pastSessionsStream => throw UnimplementedError();

}