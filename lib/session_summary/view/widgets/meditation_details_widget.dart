import 'package:flutter/material.dart';

class MeditationDetails extends StatelessWidget {
  final String totalDuration;
  final String timeUntilRelaxation;
  final String maxHeartRate;
  final String minHeartRate;
  final String avgHeartRate;

  MeditationDetails({
    required this.totalDuration,
    required this.timeUntilRelaxation,
    required this.maxHeartRate,
    required this.minHeartRate,
    required this.avgHeartRate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          EdgeInsets.symmetric(horizontal: 8.0), // Small padding left and right
      child: Column(
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Total Duration',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          totalDuration,
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Time until Relaxation',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          timeUntilRelaxation,
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(
            color: Colors.grey[300], // Light gray horizontal line
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Max. Heart Rate',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          maxHeartRate,
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Min. Heart Rate',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          minHeartRate,
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(
            color: Colors.grey[300], // Light gray horizontal line
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Avg. Heart Rate',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          avgHeartRate,
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Center(child: Text('')),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
