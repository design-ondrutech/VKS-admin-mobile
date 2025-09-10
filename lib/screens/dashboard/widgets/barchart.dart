import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceChartScreen extends StatefulWidget {
  const PerformanceChartScreen({super.key});

  @override
  State<PerformanceChartScreen> createState() => _PerformanceChartScreenState();
}

class _PerformanceChartScreenState extends State<PerformanceChartScreen> {
  bool isMonthSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Performance Chart",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ChoiceChip(
                  label: const Text("Month"),
                  selected: isMonthSelected,
                  selectedColor: Colors.deepPurple,
                  labelStyle: TextStyle(
                    color: isMonthSelected ? Colors.white : Colors.black,
                  ),
                  onSelected: (_) => setState(() => isMonthSelected = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("Year"),
                  selected: !isMonthSelected,
                  selectedColor: Colors.deepPurple,
                  labelStyle: TextStyle(
                    color: !isMonthSelected ? Colors.white : Colors.black,
                  ),
                  onSelected: (_) => setState(() => isMonthSelected = false),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        interval: 20,
                        getTitlesWidget: (value, _) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text("Jan 25");
                            case 1:
                              return const Text("Feb 25");
                            case 2:
                              return const Text("Mar 25");
                            case 3:
                              return const Text("Apr 25");
                            case 4:
                              return const Text("May 25");
                            case 5:
                              return const Text("Jun 25");
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: 120,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 30),
                        FlSpot(1, 42),
                        FlSpot(2, 33),
                        FlSpot(3, 55),
                        FlSpot(4, 45),
                        FlSpot(5, 110),
                      ],
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.greenAccent],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.4),
                            Colors.green.withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 15),
                        FlSpot(1, 30),
                        FlSpot(2, 20),
                        FlSpot(3, 35),
                        FlSpot(4, 50),
                        FlSpot(5, 42),
                      ],
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.amber],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.withOpacity(0.3),
                            Colors.orange.withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
