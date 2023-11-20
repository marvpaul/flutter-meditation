import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/past_meditation_repository.dart';
import 'package:injectable/injectable.dart';

import '../../di/Setup.dart';
import '../data/repository/impl/past_meditation_repository_local.dart';

@injectable
class HomePageViewModel extends BaseViewModel {
  List<MeditationModel>? _meditationData;

  // TODO discuss to move this to a separate view model for past meditations
  final MeditationRepository _meditationRepository = getIt<MeditationRepositoryLocal>();

  String _appbarText = "";
  String get appbarText => _appbarText;
  int get meditationDataCount => _meditationData?.length ?? 0;

  @override
  void init() async {
    _meditationData = await _meditationRepository.getAllMeditation();
    notifyListeners();
  }

  HomePageViewModel() {
    _appbarText = _getGreetingForCurrentTime();
  }

  String _getGreetingForCurrentTime() {
    final hour = DateTime.now().hour;
    if (hour > 6 && hour < 12) {
      return "Good Morning";
    } else if (hour < 18) {
      return "Good Afternoon";
    } else if (hour < 22) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

}