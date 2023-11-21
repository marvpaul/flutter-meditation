import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HeartRateGraph extends StatefulWidget {
  const HeartRateGraph({super.key});

  @override
  State<HeartRateGraph> createState() => HeartRateGraphState();
}

class HeartRateGraphState extends State<HeartRateGraph> {
  List<Color> gradientColors = [Colors.orange, Colors.red];

  bool showAvg = false;

  Timer? updateTimer;

  List<FlSpot> dataPoints = [
    FlSpot(0, 90),
    FlSpot(1, 120),
    FlSpot(2, 130),
    FlSpot(3, 150),
    FlSpot(4, 120),
    FlSpot(5, 111),
    FlSpot(6, 100),
  ];

  // Method to update the last data point
  void updateLastDataPoint(FlSpot updatedDataPoint) {
    setState(() {
      for (int i = 0; i < dataPoints.length - 1; i++) {
        dataPoints[i] = FlSpot(i.toDouble(), dataPoints[i + 1].y);
      }
      if (dataPoints.isNotEmpty) {
        dataPoints[dataPoints.length - 1] = updatedDataPoint;
      }
    });
  }

  double maximumValue() {
    double max = 0;
    for (int i = 0; i < dataPoints.length; i++) {
      if (dataPoints[i].y > max) {
        max = dataPoints[i].y;
      }
    }
    return max;
  }

  double minimumValue() {
    double min = 200;
    for (int i = 0; i < dataPoints.length; i++) {
      if (dataPoints[i].y < min) {
        min = dataPoints[i].y;
      }
    }
    return min;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
       ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.orange,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.orange,
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      titlesData: FlTitlesData(
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      minX: 0,
      maxX: 6,
      minY: 40 /* minimumValue() */,
      maxY: 140 /* maximumValue() */,
      lineBarsData: [
        LineChartBarData(
          spots: dataPoints,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
