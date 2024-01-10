import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarChart extends StatefulWidget {
  @override
  State<MyBarChart> createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  late int showingTooltip;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(
          fromY: y.toDouble(),
          toY: 0.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bar Chart'),
      ),
      body: BarChart(
        BarChartData(
          barGroups: [
            generateGroupData(0, 8),
            generateGroupData(1, 7),
            generateGroupData(2, 6),
            generateGroupData(3, 8),
            generateGroupData(4, 1),
          ],
        ),
      ),
    );
  }
}