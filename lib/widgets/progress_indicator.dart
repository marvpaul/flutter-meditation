
import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;

  ProgressIndicatorWidget({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      color: Colors.blue, 
      backgroundColor: Colors.grey,
    );
  }
}