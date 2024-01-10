/// {@category Widget}
library circle_widget;
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
          width: 240 + 80 * progress, 
          height: 240 + 80 * progress, 
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
          size: 60.0,
          color: Theme.of(context).colorScheme.background, 
        ),
      ]),
    );
  }
}
