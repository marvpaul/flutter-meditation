import 'package:flutter/material.dart';

class BreathingCircleWidget extends StatelessWidget {
  final double progress;
  final String state;

  const BreathingCircleWidget(
      {Key? key, required this.progress, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(217, 217, 217, 0.4),
        ),
        width: 240 + 20 * progress, // Use the animated value for width
        height: 240 + 20 * progress, // Use the animated value for height
      ),
      Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(217, 217, 217, 0.8),
        ),
        width: 140,
        height: 140,
      ),
      Text(
        state,
        style: TextStyle(
          fontSize: 18.0,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    ]);
  }
}
