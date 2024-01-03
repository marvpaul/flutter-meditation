/// {@category Widget}
library heart_rate_graph;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditation/session/view_model/session_page_view_model.dart';

class HeartRateGraph extends StatefulWidget {
  final SessionPageViewModel viewModel;
  const HeartRateGraph({Key? key, required this.viewModel}) : super(key: key);


  @override
  State<HeartRateGraph> createState() => HeartRateGraphState();
}

class HeartRateGraphState extends State<HeartRateGraph> {
  List<Color> colors = [Colors.orange, Colors.red]
                  .map((color) => color.withOpacity(0.3))
                  .toList();

  void refreshHeartRate() {
    setState(() {
      widget.viewModel.updateHeartRate();
    });
  }

  double maximumValue() {
    double max = 0;
    for (int i = 0; i < widget.viewModel.dataPoints.length; i++) {
      if (widget.viewModel.dataPoints[i].y > max) {
        max = widget.viewModel.dataPoints[i].y;
      }
    }
    return max;
  }

  double minimumValue() {
    double min = 200;
    for (int i = 0; i < widget.viewModel.dataPoints.length; i++) {
      if (widget.viewModel.dataPoints[i].y < min) {
        min = widget.viewModel.dataPoints[i].y;
      }
    }
    return min;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(12.0),
      child: Container(
        height: 200,
        width: 200,
        child: LineChart(
          mainData(),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
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
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      titlesData: const FlTitlesData(
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      minX: 0,
      maxX: 6,
      minY: 40,
      maxY: 155,
      lineBarsData: [
        LineChartBarData(
          spots: widget.viewModel.dataPoints,
          isCurved: true,
          gradient: LinearGradient(
            colors: colors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: colors,
            ),
          ),
        ),
      ],
    );
  }
}
