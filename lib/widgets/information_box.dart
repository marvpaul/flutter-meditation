import 'package:flutter/material.dart';

class InformationBox extends StatelessWidget {
  final String kind;
  final String value;
  final String unit;

  InformationBox({required this.kind, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 100,
      width: screenWidth * 0.45,
      margin: EdgeInsets.fromLTRB(0.025 * screenWidth, 0, 0.025 * screenWidth, 0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12.0),
      ),
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
          Spacer(), // Add Spacer to push the next widget to the bottom
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
                      fontSize: 18.0, // Adjust the font size for "MIN"
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
