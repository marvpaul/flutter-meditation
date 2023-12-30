import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/impl/meditation_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/meditation_repository.dart';
import 'package:injectable/injectable.dart';
import '../../di/Setup.dart';

@injectable
class SessionSummaryPageViewModel extends BaseViewModel {
  final MeditationRepository _meditationRepository =
      getIt<MeditationRepositoryLocal>();

  double getAverageHeartRate(MeditationModel meditation) {
    return _meditationRepository.getAverageHeartRate(meditation);
  }
  double getMinHeartRate(MeditationModel meditation) {
    return _meditationRepository.getMinHeartRate(meditation);
  }
  double getMaxHeartRate(MeditationModel meditation) {
    return _meditationRepository.getMaxHeartRate(meditation);
  }
}
