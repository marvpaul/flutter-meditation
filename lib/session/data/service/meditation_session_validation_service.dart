/// {@category Service}
library meditation_session_validation_service;
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
    // Replace 0 (failed measurements) with interpolated values
    for (int i = 0; i < heartRates.length; i++) {
      if (heartRates[i].heartRate == 0) {
        double interpolatedRate = _interpolateForZeroHeartRate(heartRates, i);
        heartRates[i] = heartRates[i].copyWith(heartRate: interpolatedRate);
      }
    }

    // If there are fewer than 15 measurements, add interpolated ones.
    while (heartRates.length < 15) {
      int lastTimestamp = heartRates.last.timestamp;
      // Assuming a fixed interval (e.g., 2000 milliseconds) for additional measurements.
      int newTimestamp = lastTimestamp + 2000;
      double newHeartRate = _interpolateForAdditionalHeartRate(heartRates);
      heartRates.add(HeartrateMeasurementModel(timestamp: newTimestamp, heartRate: newHeartRate));
    }

    // If there are more than 15 measurements, downsample to 15.
    if (heartRates.length > 15) {
      heartRates = _downsampleTo15HeartRates(heartRates);
    }

    return heartRates;
  }

  double _interpolateForZeroHeartRate(List<HeartrateMeasurementModel> heartRates, int index) {
    int prevIndex = index - 1;
    int nextIndex = index + 1;

    // Find the previous non-zero measurement
    while (prevIndex >= 0 && heartRates[prevIndex].heartRate == 0) {
      prevIndex--;
    }

    // Find the next non-zero measurement
    while (nextIndex < heartRates.length && heartRates[nextIndex].heartRate == 0) {
      nextIndex++;
    }

    // If there are no valid measurements before and after the current index,
    // it's not possible to interpolate. Return a default or calculated value.
    if (prevIndex < 0 && nextIndex >= heartRates.length) {
      return 75.0;  // Replace this with a more appropriate default value if needed
    }

    // Linear interpolation
    double startValue, endValue;
    int startTime, endTime;

    if (prevIndex >= 0) {
      startValue = heartRates[prevIndex].heartRate;
      startTime = heartRates[prevIndex].timestamp;
    } else {
      // If there is no previous valid measurement, use the next valid measurement
      startValue = heartRates[nextIndex].heartRate;
      startTime = heartRates[index].timestamp - 2000; // Assuming a fixed interval
    }

    if (nextIndex < heartRates.length) {
      endValue = heartRates[nextIndex].heartRate;
      endTime = heartRates[nextIndex].timestamp;
    } else {
      // If there is no next valid measurement, use the previous valid measurement
      endValue = heartRates[prevIndex].heartRate;
      endTime = heartRates[index].timestamp + 2000; // Assuming a fixed interval
    }

    double fraction = (heartRates[index].timestamp - startTime).toDouble() / (endTime - startTime).toDouble();
    return startValue + fraction * (endValue - startValue);
  }

  double _interpolateForAdditionalHeartRate(List<HeartrateMeasurementModel> heartRates) {
    // Logic to determine a heart rate value for an additional measurement
    // This could be an average of the last few measurements, a trend-based value, etc.
    // For simplicity in this example, just return the last heart rate value
    return heartRates.last.heartRate;
  }

  List<HeartrateMeasurementModel> _downsampleTo15HeartRates(List<HeartrateMeasurementModel> heartRates) {
    List<HeartrateMeasurementModel> downsampledHeartRates = [];
    int totalMeasurements = heartRates.length;
    double interval = totalMeasurements / 15.0;

    for (int i = 0; i < 15; i++) {
      // Calculate the start and end indices for the current segment
      int startIdx = (i * interval).floor();
      int endIdx = ((i + 1) * interval).floor();

      // Avoid going out of bounds
      endIdx = endIdx < totalMeasurements ? endIdx : totalMeasurements;

      // Aggregate or interpolate measurements in the segment
      double aggregatedHeartRate = 0;
      int aggregatedTimestamp = 0;
      for (int j = startIdx; j < endIdx; j++) {
        aggregatedHeartRate += heartRates[j].heartRate;
        aggregatedTimestamp += heartRates[j].timestamp;
      }

      // Calculate the average for the segment
      int segmentLength = endIdx - startIdx;
      double avgHeartRate = aggregatedHeartRate / segmentLength;
      int avgTimestamp = (aggregatedTimestamp / segmentLength).round();

      // Add the averaged measurement to the downsampled list
      downsampledHeartRates.add(
        HeartrateMeasurementModel(timestamp: avgTimestamp, heartRate: avgHeartRate),
      );
    }

    return downsampledHeartRates;
  }
}