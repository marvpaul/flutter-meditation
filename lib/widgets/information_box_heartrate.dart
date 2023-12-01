import 'package:flutter/material.dart';
import 'package:flutter_meditation/session/view_model/session_page_view_model.dart';
import 'package:flutter_meditation/widgets/heart_rate_graph.dart';

class InformationBoxHeartRate extends StatelessWidget {
  final String kind;
  final String value;
  final String unit;
  final SessionPageViewModel viewModel;

  InformationBoxHeartRate({
    required this.kind,
    required this.value,
    required this.unit,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 100,
      width: screenWidth * 0.45,
      margin:
          EdgeInsets.fromLTRB(0.025 * screenWidth, 0, 0.025 * screenWidth, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15.0),
            child: HeartRateGraph(
              viewModel: viewModel,
              key: viewModel.heartRateGraphKey,
            ),
          ),
          // InformationBox on top of the HeartRateGraph
          Container(
            padding: const EdgeInsets.all(16.0),
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
    );
  }
}
