import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:injectable/injectable.dart';

import '../../../home/data/model/heartrate_measurement_model.dart';
import '../../../home/data/model/session_parameter_model.dart';

@injectable
class MeditationSessionValidationService {
  MeditationModel validateMeditationSession(MeditationModel session) {
    // Interpolating heart rates for each session parameter
    List<SessionParameterModel> updatedSessionParameters = session.sessionParameters
        .map((param) => param.copyWith(
        heartRates: _interpolateHeartRates(param.heartRates)))
        .toList();

    // Returning a new instance of MeditationModel with updated session parameters
    return session.copyWith(sessionParameters: updatedSessionParameters);
  }

  List<HeartrateMeasurementModel> _interpolateHeartRates(
      List<HeartrateMeasurementModel> heartRates) {
    if (heartRates.isEmpty) {
      return [];
    }

    List<HeartrateMeasurementModel> interpolatedHeartRates = [];
    interpolatedHeartRates.add(heartRates.first); // Add the first measurement

    for (var i = 1; i < heartRates.length; i++) {
      int previousTimestamp = heartRates[i - 1].timestamp;
      int currentTimestamp = heartRates[i].timestamp;

      // Check if the gap between two consecutive measurements is exactly 3 seconds
      if (currentTimestamp - previousTimestamp == 3000) {
        // Interpolate a measurement halfway between the two measurements
        double interpolatedRate = _interpolateHeartRate(
          heartRates[i - 1],
          heartRates[i],
          previousTimestamp + 1500, // Halfway timestamp
        );
        interpolatedHeartRates.add(
          HeartrateMeasurementModel(
            timestamp: previousTimestamp + 1500,
            heartRate: interpolatedRate,
          ),
        );
      }

      interpolatedHeartRates.add(heartRates[i]); // Add the current measurement
    }

    return interpolatedHeartRates;
  }

  double _interpolateHeartRate(
      HeartrateMeasurementModel before,
      HeartrateMeasurementModel after,
      int targetTimestamp,
      ) {
    double timeDiff = after.timestamp.toDouble() - before.timestamp.toDouble();
    double weightBefore = (after.timestamp - targetTimestamp) / timeDiff;
    double weightAfter = 1.0 - weightBefore;

    return weightBefore * before.heartRate + weightAfter * after.heartRate;
  }
}