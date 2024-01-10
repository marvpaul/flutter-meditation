/// {@category Widget}
library gradient_background;
import 'package:flutter/material.dart';

class GradientBackground extends StatefulWidget {
  const GradientBackground({Key? key}) : super(key: key);

  @override
  _GradientBackgroundState createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 14),
    );

    _colorAnimation = ColorTween(
      begin: Color.fromARGB(255, 87, 99, 21),
      end: Color(0xFF3D82E9),
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Set the height to full screen height
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_colorAnimation.value!, Color(0xFF000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          );
        },
      ),
    );
  }
}

