/// {@category Widget}
library information_box;
import 'dart:ui';
import 'package:flutter/material.dart';

class InformationBox extends StatelessWidget {
  final String kind;
  final String value;
  final String unit;
  final Widget? background;
  final double boxHeight;

  const InformationBox({
    Key? key,
    required this.kind,
    required this.value,
    required this.unit,
    this.background,
    required this.boxHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: boxHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            children: [
              Container(
                color: Colors.white.withOpacity(0.4), // White color overlay with opacity
              ),
              if (background != null) background!, // Place the additional background here
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      kind,
                      style: TextStyle(
                        color: const Color(0xFF3C3C43).withOpacity(0.6),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: RichText(
                        text: TextSpan(
                          text: '$value ',
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 30.0,
                          ),
                          children: [
                            TextSpan(
                              text: unit,
                              style: const TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
