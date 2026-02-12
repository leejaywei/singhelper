import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Widget for visualizing pitch over time
class PitchVisualizationChart extends StatelessWidget {
  final List<double?> referencePitches;
  final List<double?> recordedPitches;
  final Color referenceColor;
  final Color recordedColor;

  const PitchVisualizationChart({
    super.key,
    required this.referencePitches,
    required this.recordedPitches,
    this.referenceColor = Colors.blue,
    this.recordedColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 50,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}s',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 100,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}Hz',
                  style: const TextStyle(fontSize: 10),
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        minX: 0,
        maxX: referencePitches.length.toDouble(),
        minY: 0,
        maxY: 1000,
        lineBarsData: [
          // Reference pitch line
          LineChartBarData(
            spots: _createSpots(referencePitches),
            isCurved: true,
            color: referenceColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Recorded pitch line
          LineChartBarData(
            spots: _createSpots(recordedPitches),
            isCurved: true,
            color: recordedColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _createSpots(List<double?> pitches) {
    final spots = <FlSpot>[];
    for (int i = 0; i < pitches.length; i++) {
      final pitch = pitches[i];
      if (pitch != null && pitch > 0) {
        spots.add(FlSpot(i.toDouble(), pitch));
      }
    }
    return spots;
  }
}
