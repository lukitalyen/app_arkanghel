import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:app_arkanghel/screens/admin/admin_dashboard_screen.dart';

class OverviewChart extends StatelessWidget {
  final TimePeriod period;
  const OverviewChart({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.black12,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: leftTitleWidgets,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _getInterval(),
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: _getMinX(),
        maxX: _getMaxX(),
        minY: _getMinY(),
        maxY: _getMaxY(),
        lineBarsData: [
          LineChartBarData(
            spots: _getSpots(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.blue],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12, color: Colors.grey);
    Widget text;

    switch (period) {
      case TimePeriod.week:
        switch (value.toInt()) {
          case 0: text = const Text('Mo', style: style); break;
          case 1: text = const Text('Tu', style: style); break;
          case 2: text = const Text('We', style: style); break;
          case 3: text = const Text('Th', style: style); break;
          case 4: text = const Text('Fr', style: style); break;
          case 5: text = const Text('Sa', style: style); break;
          case 6: text = const Text('Su', style: style); break;
          default: text = const Text('', style: style); break;
        }
        break;
      case TimePeriod.month:
        switch (value.toInt()) {
          case 0: text = const Text('W1', style: style); break;
          case 1: text = const Text('W2', style: style); break;
          case 2: text = const Text('W3', style: style); break;
          case 3: text = const Text('W4', style: style); break;
          default: text = const Text('', style: style); break;
        }
        break;
      case TimePeriod.year:
        switch (value.toInt()) {
          case 0: text = const Text('Ja', style: style); break;
          case 1: text = const Text('Fe', style: style); break;
          case 2: text = const Text('Ma', style: style); break;
          case 3: text = const Text('Ap', style: style); break;
          case 4: text = const Text('My', style: style); break;
          case 5: text = const Text('Jn', style: style); break;
          case 6: text = const Text('Jl', style: style); break;
          case 7: text = const Text('Au', style: style); break;
          case 8: text = const Text('Se', style: style); break;
          case 9: text = const Text('Oc', style: style); break;
          case 10: text = const Text('No', style: style); break;
          case 11: text = const Text('De', style: style); break;
          default: text = const Text('', style: style); break;
        }
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12, color: Colors.grey);
    String text;

    final double interval = (meta.max - meta.min) / 4;
    if (value == meta.min || value == meta.min + interval || value == meta.min + interval * 2 || value == meta.min + interval * 3 || value == meta.max) {
        text = '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  double _getInterval() {
    switch (period) {
      case TimePeriod.week:
        return 2;
      case TimePeriod.month:
        return 1;
      case TimePeriod.year:
        return 2;
    }
  }

  double _getMinX() {
    switch (period) {
      case TimePeriod.week: return 0;
      case TimePeriod.month: return 0;
      case TimePeriod.year: return 0;
    }
  }

  double _getMaxX() {
    switch (period) {
      case TimePeriod.week: return 6;
      case TimePeriod.month: return 3;
      case TimePeriod.year: return 11;
    }
  }

  double _getMinY() {
    return _getSpots().map((e) => e.y).reduce((a, b) => a < b ? a : b) - 200;
  }

  double _getMaxY() {
    return _getSpots().map((e) => e.y).reduce((a, b) => a > b ? a : b) + 200;
  }

  List<FlSpot> _getSpots() {
    switch (period) {
      case TimePeriod.week:
        return const [
          FlSpot(0, 1350), FlSpot(1, 1420), FlSpot(2, 1300), FlSpot(3, 1480),
          FlSpot(4, 1380), FlSpot(5, 1500), FlSpot(6, 1450),
        ];
      case TimePeriod.month:
        return const [
          FlSpot(0, 1350), FlSpot(1, 1480), FlSpot(2, 1380), FlSpot(3, 1500),
        ];
      case TimePeriod.year:
        return const [
          FlSpot(0, 1350), FlSpot(1, 1420), FlSpot(2, 1300), FlSpot(3, 1480),
          FlSpot(4, 1380), FlSpot(5, 1500), FlSpot(6, 1450), FlSpot(7, 1600),
          FlSpot(8, 1550), FlSpot(9, 1700), FlSpot(10, 1650), FlSpot(11, 1800),
        ];
    }
  }
}
