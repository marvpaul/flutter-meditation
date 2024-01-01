import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/impl/meditation_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/meditation_repository.dart';
import 'package:flutter_meditation/past_sessions/data/model/past_sessions.dart';
import 'package:injectable/injectable.dart';
import '../../common/helpers.dart';
import '../../di/Setup.dart';

@injectable
class SessionSummaryPageViewModel extends BaseViewModel {
  final MeditationRepository _meditationRepository =
      getIt<MeditationRepositoryLocal>();

  late PastSession session;
  SessionSummaryPresentationModel? sessionSummaryPresentationModel;
  List<SessionSummarySessionPeriodPresentationModel> sessionPeriodsPresentationModels = [];

  update(PastSession session) {
    this.session = session;
    sessionSummaryPresentationModel = SessionSummaryPresentationModel(
      totalDuration: '${secondsToHRF(session.duration.toDouble())} min',
      maxHeartRate: '${_getMaxHeartRateForSession(session)} BPM',
      minHeartRate: '${_getMinHeartRateForSession(session)} BPM',
      avgHeartRate: '${_getAverageHeartRateForSession(session)} BPM',
      isHapticFeedbackEnabled: session.sessionPeriods[0].isHapticFeedbackEnabled,
    );
    sessionPeriodsPresentationModels = session.sessionPeriods.map((period) {
      return SessionSummarySessionPeriodPresentationModel(
        periodTitle: 'Period ${session.sessionPeriods.indexOf(period) + 1}',
        visualization: period.visualization,
        beatFrequency: period.beatFrequency,
        breathingPattern: period.breathingPattern.toFormattedString(),
        breathingPatternMultiplier: period.breathingPatternMultiplier.toString(),
        maxHeartRate: '${_getMaxHeartRate(period.heartRateMeasurements.map((e) => e.heartRate).toList())} BPM',
        minHeartRate: '${_getMinHeartRate(period.heartRateMeasurements.map((e) => e.heartRate).toList())} BPM',
        avgHeartRate: '${_getAverageHeartRate(period.heartRateMeasurements.map((e) => e.heartRate).toList())} BPM',
      );
    }).toList();
    // notifyListeners();
  }

  double _getAverageHeartRateForSession(PastSession session) {
    List<double> allHeartRates = session.sessionPeriods
        .expand((period) => period.heartRateMeasurements)
        .map((measurement) => measurement.heartRate)
        .toList();

    return _getAverageHeartRate(allHeartRates);
  }

  double _getAverageHeartRate(List<double> heartRates) {
    if (heartRates.isEmpty) {
      return 0.0;
    }

    double sum = heartRates.reduce((a, b) => a + b);
    double average = sum / heartRates.length;
    return double.parse(average.toStringAsFixed(1));
  }

  double _getMinHeartRateForSession(PastSession session) {
    List<double> allHeartRates = session.sessionPeriods
        .expand((period) => period.heartRateMeasurements)
        .map((measurement) => measurement.heartRate)
        .toList();

   return _getMinHeartRate(allHeartRates);
  }

  double _getMinHeartRate(List<double> heartRates) {
    if (heartRates.isEmpty) {
      return 0.0;
    }

    double min = heartRates.reduce((a, b) => a < b ? a : b);
    return double.parse(min.toStringAsFixed(1));
  }

  double _getMaxHeartRateForSession(PastSession session) {
    List<double> allHeartRates = session.sessionPeriods
        .expand((period) => period.heartRateMeasurements)
        .map((measurement) => measurement.heartRate)
        .toList();

    return _getMaxHeartRate(allHeartRates);
  }

  double _getMaxHeartRate(List<double> heartRates) {
    if (heartRates.isEmpty) {
      return 0.0;
    }

    double max = heartRates.reduce((a, b) => a > b ? a : b);
    return double.parse(max.toStringAsFixed(1));
  }

}


class SessionSummaryPresentationModel {
  final String totalDuration;
  final String maxHeartRate;
  final String minHeartRate;
  final String avgHeartRate;
  final bool isHapticFeedbackEnabled;

  SessionSummaryPresentationModel({
    required this.totalDuration,
    required this.maxHeartRate,
    required this.minHeartRate,
    required this.avgHeartRate,
    required this.isHapticFeedbackEnabled,
  });
}

class SessionSummarySessionPeriodPresentationModel {
  final String periodTitle;
  final String visualization;
  final double beatFrequency;
  final String breathingPattern;
  final String breathingPatternMultiplier;
  final String maxHeartRate;
  final String minHeartRate;
  final String avgHeartRate;

  SessionSummarySessionPeriodPresentationModel({
    required this.periodTitle,
    required this.visualization,
    required this.beatFrequency,
    required this.breathingPattern,
    required this.breathingPatternMultiplier,
    required this.maxHeartRate,
    required this.minHeartRate,
    required this.avgHeartRate,
  });
}
