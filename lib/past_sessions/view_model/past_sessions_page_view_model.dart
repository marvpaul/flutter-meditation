import 'package:flutter/material.dart';
import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/all_meditations_repository.dart';
import 'package:flutter_meditation/home/data/repository/impl/all_meditations_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/impl/meditation_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/meditation_repository.dart';
import 'package:flutter_meditation/session_summary/view/screens/past_sessions_page_view.dart';
import 'package:injectable/injectable.dart';
import '../../di/Setup.dart';

@injectable
class PastSessionsPageViewModel extends BaseViewModel {
  List<MeditationModel>? get meditations => _allMeditationsModel;
  List<MeditationModel>? _allMeditationsModel;
  final AllMeditationsRepository _meditationsRepository = getIt<AllMeditationsRepositoryLocal>();
  final MeditationRepository _meditationRepository = getIt<MeditationRepositoryLocal>();

  @override
  void init() async {
    _allMeditationsModel = await _meditationsRepository.getAllMeditation();
    notifyListeners();
  }

  double getAverageHeartRate(MeditationModel meditation){
    return _meditationRepository.getAverageHeartRate(meditation);
  }

  void navigateToSummary(var context, MeditationModel meditation) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SessionSummaryPageView(meditation: meditation)),
    );
  }

}
