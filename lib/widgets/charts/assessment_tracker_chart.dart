import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AssessmentTrackerChart extends StatelessWidget {
  const AssessmentTrackerChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);
                String text;
                switch (value.toInt()) {
                  case 0:
                    text = 'Jan';
                    break;
                  case 1:
                    text = 'Feb';
                    break;
                  case 2:
                    text = 'Mar';
                    break;
                  case 3:
                    text = 'Apr';
                    break;
                  case 4:
                    text = 'May';
                    break;
                  case 5:
                    text = 'Jun';
                    break;
                  default:
                    text = '';
                    break;
                }
                return SideTitleWidget(axisSide: meta.axisSide, space: 4.0, child: Text(text, style: style));
              },
              reservedSize: 32,
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: Colors.lightBlueAccent)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: Colors.lightBlueAccent)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, color: Colors.lightBlueAccent)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15, color: Colors.lightBlueAccent)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13, color: Colors.lightBlueAccent)]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 17, color: Colors.lightBlueAccent)]),
        ],
      ),
    );
  }
}
