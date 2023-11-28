import 'package:flutter/material.dart';
import 'package:flutter_meditation/common/helpers.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';

class PastSessionsListEntry extends StatelessWidget {
  final MeditationModel meditation;
  final VoidCallback onPlayPressed;
  final double averageBPM; 

  PastSessionsListEntry({
    required this.meditation,
    required this.onPlayPressed,
    required this.averageBPM,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side with two text fields
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  secondsToHRF(meditation.duration.toDouble()).toString() + ' min',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  timestampToHRF(meditation.timestamp),
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.0), // Spacer between left and right sides
          // Right side with "BPM" text and play button
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    (averageBPM).toInt().toString() + 'BPM',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: onPlayPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
