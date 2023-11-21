import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  final double progress;
  final VoidCallback? onTap;

  const CircleWidget({Key? key, required this.progress, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(alignment: Alignment.center, children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(217, 217, 217, 0.4),
          ),
          width: 240 + 80 * progress, // Use the animated value for width
          height: 240 + 80 * progress, // Use the animated value for height
        ),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(217, 217, 217, 0.8),
          ),
          width: 140,
          height: 140,
        ),
        Icon(
          Icons.play_arrow,
          size: 60.0, // Set the desired size of the play icon
          color: Theme.of(context).colorScheme.background, // Set the desired color of the play icon
        ),
      ]),
    );
  }
}
