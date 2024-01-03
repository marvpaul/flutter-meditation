import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/impl/meditation_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/meditation_repository.dart';
import 'package:flutter_meditation/session/data/model/breathing_pattern_model.dart';
import 'package:injectable/injectable.dart';
import '../../common/helpers.dart';
import '../../di/Setup.dart';
import '../../past_sessions/data/presentation/session_summary_presentation_model.dart';

/// View model for managing the session summary page.
///
/// This class provides functionality for retrieving session
/// summary details, including date, time, duration, heart rate statistics,
/// and session parameters. It interacts with the [MeditationRepository] to
/// retrieve session data and performs calculations to generate information like average heart rate and others.
@injectable
class SessionSummaryPageViewModel extends BaseViewModel {

  late MeditationModel session; // TODO: needed?
  SessionSummaryPresentationModel? sessionSummaryPresentationModel;
  List<SessionSummarySessionPeriodPresentationModel>
      sessionPeriodsPresentationModels = [];

  /// Updates the view model with the provided [session].
  update(MeditationModel session) {
    this.session = session;
    sessionSummaryPresentationModel = SessionSummaryPresentationModel(
      date:
          DateTime.fromMillisecondsSinceEpoch(session.timestamp.toInt() * 1000)
              .formattedDate,
      time:
          DateTime.fromMillisecondsSinceEpoch(session.timestamp.toInt() * 1000)
              .formattedTime,
      totalDuration: '${secondsToHRF(session.duration.toDouble())} min',
      maxHeartRate: '${_getMaxHeartRateForSession(session)} BPM',
      minHeartRate: '${_getMinHeartRateForSession(session)} BPM',
      avgHeartRate: '${_getAverageHeartRateForSession(session)} BPM',
      isHapticFeedbackEnabled: session.isHapticFeedbackEnabled,
    );
    sessionPeriodsPresentationModels = session.sessionParameters.map((period) {
      return SessionSummarySessionPeriodPresentationModel(
        periodTitle: 'Period ${session.sessionParameters.indexOf(period) + 1}',
        visualization: period.visualization,
        beatFrequency: period.binauralFrequency?.toDouble(),
        breathingPattern: period.breathingPattern.value,
        breathingPatternMultiplier: period.breathingMultiplier.toString(),
        maxHeartRate:
            '${_getMaxHeartRate(period.heartRates.map((e) => e.heartRate).toList())} BPM',
        minHeartRate:
            '${_getMinHeartRate(period.heartRates.map((e) => e.heartRate).toList())} BPM',
        avgHeartRate:
            '${_getAverageHeartRate(period.heartRates.map((e) => e.heartRate).toList())} BPM',
      );
    }).toList();
    // notifyListeners();
  }

  /// Calculates the average heart rate for the entire session.
  double _getAverageHeartRateForSession(MeditationModel session) {
    List<double> allHeartRates = session.sessionParameters
        .expand((period) => period.heartRates)
        .map((measurement) => measurement.heartRate)
        .toList();

    return _getAverageHeartRate(allHeartRates);
  }

  /// Calculates the average heart rate from a list of heart rates.
  double _getAverageHeartRate(List<double> heartRates) {
    if (heartRates.isEmpty) {
      return 0.0;
    }

    double sum = heartRates.reduce((a, b) => a + b);
    double average = sum / heartRates.length;
    return double.parse(average.toStringAsFixed(1));
  }

  /// Retrieves the minimum heart rate for the entire session.
  double _getMinHeartRateForSession(MeditationModel session) {
    List<double> allHeartRates = session.sessionParameters
        .expand((period) => period.heartRates)
        .map((measurement) => measurement.heartRate)
        .toList();

    return _getMinHeartRate(allHeartRates);
  }

  /// Calculates the minimum heart rate from a list of heart rates.
  double _getMinHeartRate(List<double> heartRates) {
    if (heartRates.isEmpty) {
      return 0.0;
    }

    double min = heartRates.reduce((a, b) => a < b ? a : b);
    return double.parse(min.toStringAsFixed(1));
  }

  /// Retrieves the maximum heart rate for the entire session.
  double _getMaxHeartRateForSession(MeditationModel session) {
    List<double> allHeartRates = session.sessionParameters
        .expand((period) => period.heartRates)
        .map((measurement) => measurement.heartRate)
        .toList();

    return _getMaxHeartRate(allHeartRates);
  }

  /// Calculates the maximum heart rate from a list of heart rates.
  double _getMaxHeartRate(List<double> heartRates) {
    if (heartRates.isEmpty) {
      return 0.0;
    }

    double max = heartRates.reduce((a, b) => a > b ? a : b);
    return double.parse(max.toStringAsFixed(1));
  }
}

extension DateTimeExtension on DateTime {
  /// Returns a formatted date string in the format 'DD.MM.YYYY'.
  String get formattedDate {
    return '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.${year}';
  }

  /// Returns a formatted time string in the format 'HH:mm'.
  String get formattedTime {
    return toString().split(' ')[1].substring(0, 5);
  }
}
