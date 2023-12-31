import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/impl/meditation_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/meditation_repository.dart';
import 'package:flutter_meditation/past_sessions/data/model/past_sessions.dart';
import 'package:injectable/injectable.dart';
import '../../di/Setup.dart';

@injectable
class SessionSummaryPageViewModel extends BaseViewModel {
  final MeditationRepository _meditationRepository =
      getIt<MeditationRepositoryLocal>();

  late PastSession session;

  update(PastSession session) {
    this.session = session;
    notifyListeners();
  }

  double getAverageHeartRate(PastSession session) {
    List<int> allHeartRates = session.sessionPeriods
        .expand((period) => period.heartRateMeasurements)
        .toList();

    if (allHeartRates.isEmpty) {
      return 0.0;
    }

    int sum = allHeartRates.reduce((a, b) => a + b);
    double average = sum / allHeartRates.length;
    return double.parse(average.toStringAsFixed(1));
  }

  double getMinHeartRate(PastSession session) {
    List<int> allHeartRates = session.sessionPeriods
        .expand((period) => period.heartRateMeasurements)
        .toList();

    if (allHeartRates.isEmpty) {
      return 0.0;
    }

    int min = allHeartRates.reduce((a, b) => a < b ? a : b);
    return double.parse(min.toStringAsFixed(1));
  }

  double getMaxHeartRate(PastSession session) {
    List<int> allHeartRates = session.sessionPeriods
        .expand((period) => period.heartRateMeasurements)
        .toList();

    if (allHeartRates.isEmpty) {
      return 0.0;
    }

    int max = allHeartRates.reduce((a, b) => a > b ? a : b);
    return double.parse(max.toStringAsFixed(1));
  }

}
