import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/all_meditations_repository.dart';
import 'package:flutter_meditation/home/data/repository/impl/all_meditations_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/impl/meditation_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/meditation_repository.dart';
import 'package:flutter_meditation/past_sessions/data/repository/impl/past_sessions_middleware_repository.dart';
import 'package:flutter_meditation/session_summary/view/screens/session_summary_page_view.dart';
import 'package:injectable/injectable.dart';
import '../../di/Setup.dart';
import '../data/repository/past_sessions_repository.dart';

@injectable
class PastSessionsPageViewModel extends BaseViewModel {
  List<MeditationModel>? get meditations => _allMeditationsModel;
  List<MeditationModel>? _allMeditationsModel;
  List<MeditationModel> _pastSessions = [];
  List<MeditationModel> get pastSessions => _pastSessions;

  late StreamSubscription<List<MeditationModel>> _pastSessionsSubscription;

  final AllMeditationsRepository _meditationsRepository = getIt<AllMeditationsRepositoryLocal>();
  final MeditationRepository _meditationRepository = getIt<MeditationRepositoryLocal>();
  final PastSessionsRepository _pastSessionsRepository = getIt<PastSessionsMiddlewareRepository>();

  final String pageTitle = 'Past Sessions';

  @override
  void init() async {
    _allMeditationsModel = await _meditationsRepository.getAllMeditation();
    _subscribeToPastSessionsStream();
    notifyListeners();
  }

  void _subscribeToPastSessionsStream() {
    _pastSessionsSubscription = _pastSessionsRepository.pastSessionsStream.listen(
          (List<MeditationModel> sessions) {
        _pastSessions = sessions;
        notifyListeners();  // Update UI
      },
      onError: (error) {
        // Handle any errors here
      },
    );
  }

  @override
  void dispose() {
    _pastSessionsSubscription.cancel();  // Cancel the subscription
    super.dispose();
  }

  double getAverageHeartRate(MeditationModel meditation){
    return _meditationRepository.getAverageHeartRate(meditation);
  }

  void navigateToSummary(var context, MeditationModel meditation) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SessionSummaryPageView(session: meditation)),
    );
  }

  double getAverageHeartRateForSession(MeditationModel session){
    List<double> allHeartRates = session.sessionParameters
        .expand((period) => period.heartRates)
        .map((measurement) => measurement.heartRate)
        .toList();

    if (allHeartRates.isEmpty) {
      return 0.0;
    }

    double sum = allHeartRates.reduce((a, b) => a + b);
    return sum / allHeartRates.length;
  }

}
