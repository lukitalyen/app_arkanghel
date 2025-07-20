import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AssessmentTrackerChart extends StatelessWidget {
  AssessmentTrackerChart({super.key});

  final Color passedColor = Colors.lightBlue;
  final Color failedColor = Colors.blue.shade800;

  @override
  Widget build(BuildContext context) {
    final List<_ChartData> chartData = [
      _ChartData('DA', 12, 5),
      _ChartData('BDT', 15, 6),
      _ChartData('AD', 8, 3),
      _ChartData('UH', 11, 4),
      _ChartData('AI', 18, 7),
      _ChartData('OR', 14, 9),
      _ChartData('CM', 16, 4),
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
        _buildLegend(context),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.8,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              maxY: 25, // Adjust based on max data
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < chartData.length) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4.0,
                          child: Text(chartData[index].workstream, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 60,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value % 5 == 0) {
                        return Text('${value.toInt()}', style: const TextStyle(fontSize: 12, color: Colors.grey));
                      }
                      return const Text('');
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 5,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(color: Colors.black12, strokeWidth: 1);
                },
              ),
              barGroups: List.generate(chartData.length, (index) {
                final data = chartData[index];
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data.passed.toDouble() + data.failed.toDouble(),
                      width: 16,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                      rodStackItems: [
                        BarChartRodStackItem(0, data.passed.toDouble(), passedColor),
                        BarChartRodStackItem(data.passed.toDouble(), data.passed.toDouble() + data.failed.toDouble(), failedColor),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(passedColor, 'Passed'),
        const SizedBox(width: 20),
        _legendItem(failedColor, 'Failed'),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }
}

class _ChartData {
  final String workstream;
  final int passed;
  final int failed;

  _ChartData(this.workstream, this.passed, this.failed);
}

