import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample extends StatefulWidget {
  @override
  State<BarChartSample> createState() => _BarChartSampleState();
}

class _BarChartSampleState extends State<BarChartSample> {
  bool isMonth = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Performance Chart",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        _buildToggle("Month", true),
                        _buildToggle("Year", false),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Legend
              Row(
                children: const [
                  CircleAvatar(radius: 5, backgroundColor: Colors.green),
                  SizedBox(width: 6),
                  Text("Gold Eleven"),
                  SizedBox(width: 16),
                  CircleAvatar(radius: 5, backgroundColor: Colors.orange),
                  SizedBox(width: 6),
                  Text("Digital Gold Saving"),
                ],
              ),

              const SizedBox(height: 24),

              // Line Chart
              Expanded(
                child: LineChart(isMonth ? monthData() : yearData()),
              ),

              const SizedBox(height: 24),

              // Cards Row
              // Row(
              //   children: [
              //     Expanded(child: _buildInfoCard("Gold Eleven", "₹ 2,847", "+12.5% this month", Colors.green)),
              //     const SizedBox(width: 12),
              //     Expanded(child: _buildInfoCard("Digital Gold Saving", "₹ 1,923", "+8.3% this month", Colors.orange)),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  /// Toggle button widget
  Widget _buildToggle(String text, bool value) {
    bool selected = isMonth == value;
    return GestureDetector(
      onTap: () => setState(() => isMonth = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Info card widget
  Widget _buildInfoCard(String title, String price, String growth, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 6, backgroundColor: color),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              growth,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Month data
  LineChartData monthData() {
    return chartData(
      greenSpots: [
        FlSpot(1, 35),
        FlSpot(2, 42),
        FlSpot(3, 30),
        FlSpot(4, 55),
        FlSpot(5, 110),
        FlSpot(6, 100),
      ],
      orangeSpots: [
        FlSpot(1, 15),
        FlSpot(2, 35),
        FlSpot(3, 45),
        FlSpot(4, 40),
        FlSpot(5, 60),
        FlSpot(6, 42),
      ],
      bottomLabels: ["Jan 25", "Feb 25", "Mar 25", "Apr 25", "May 25", "Jun 25"],
    );
  }

  /// Year data
  LineChartData yearData() {
    return chartData(
      greenSpots: [
        FlSpot(1, 80),
        FlSpot(2, 95),
        FlSpot(3, 70),
        FlSpot(4, 105),
        FlSpot(5, 120),
        FlSpot(6, 100),
      ],
      orangeSpots: [
        FlSpot(1, 50),
        FlSpot(2, 65),
        FlSpot(3, 80),
        FlSpot(4, 75),
        FlSpot(5, 95),
        FlSpot(6, 85),
      ],
      bottomLabels: ["2020", "2021", "2022", "2023", "2024", "2025"],
    );
  }

  /// Common chart builder
  LineChartData chartData({
    required List<FlSpot> greenSpots,
    required List<FlSpot> orangeSpots,
    required List<String> bottomLabels,
  }) {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int index = value.toInt() - 1;
              if (index >= 0 && index < bottomLabels.length) {
                return Text(bottomLabels[index]);
              }
              return Container();
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 1,
      maxX: 6,
      minY: 0,
      maxY: 130,
      lineBarsData: [
        LineChartBarData(
          spots: greenSpots,
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          belowBarData: BarAreaData(
            show: true,
            color: Colors.green.withOpacity(0.2),
          ),
        ),
        LineChartBarData(
          spots: orangeSpots,
          isCurved: true,
          color: Colors.orange,
          barWidth: 3,
          belowBarData: BarAreaData(
            show: true,
            color: Colors.orange.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}
