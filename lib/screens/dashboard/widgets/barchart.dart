import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:admin/blocs/barchart/barchart_bloc.dart';
import 'package:admin/blocs/barchart/barchart_event.dart';
import 'package:admin/blocs/barchart/barchart_state.dart';

class PerformanceChartScreen extends StatefulWidget {
  const PerformanceChartScreen({super.key});

  @override
  State<PerformanceChartScreen> createState() => _PerformanceChartScreenState();
}

class _PerformanceChartScreenState extends State<PerformanceChartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GoldDashboardBloc>().add(FetchGoldDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<GoldDashboardBloc, GoldDashboardState>(
          builder: (context, state) {
            if (state is GoldDashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GoldDashboardError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            if (state is GoldDashboardLoaded) {
              ///  Get data safely
              final schemeData = state.dashboard.schemeMonthlySummary;

              if (schemeData.isEmpty) {
                debugPrint(" schemeMonthlySummary is EMPTY!");
              }

              //  Separate scheme data by scheme_name
              final digiGold = schemeData.where((e) => e.schemeName == "DigiGold").toList();
              final superGold = schemeData.where((e) => e.schemeName == "SuperGold").toList();
              final thangamagal = schemeData.where((e) => e.schemeName == "Thangamagal").toList();

              List<FlSpot> buildSpots(List<dynamic> data) {
                return data.asMap().entries.map((e) {
                  return FlSpot(e.key.toDouble(), e.value.totalGoldBought);
                }).toList();
              }

              final digiGoldSpots = buildSpots(digiGold);
              final superGoldSpots = buildSpots(superGold);
              final thangamagalSpots = buildSpots(thangamagal);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Performance Chart",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  //  Horizontal scroll for months to avoid overflow
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: (schemeData.length * 80).toDouble(), // adjust width dynamically
                        child: LineChart(
                          LineChartData(
                            minX: 0,
                            maxX: (schemeData.length - 1).toDouble(),
                            minY: 0,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Colors.grey.shade300,
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, _) {
                                    if (value < 0 || value > schemeData.length - 1) {
                                      return const SizedBox.shrink();
                                    }
                                    return Text(
                                      schemeData[value.toInt()].month,
                                      style: const TextStyle(fontSize: 12),
                                    );
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: digiGoldSpots,
                                isCurved: true,
                                barWidth: 3,
                                color: Colors.green,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.withOpacity(0.3),
                                      Colors.green.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                dotData: FlDotData(show: false),
                              ),
                              LineChartBarData(
                                spots: superGoldSpots,
                                isCurved: true,
                                barWidth: 3,
                                color: Colors.orange,
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
                              LineChartBarData(
                                spots: thangamagalSpots,
                                isCurved: true,
                                barWidth: 3,
                                color: Colors.purple,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple.withOpacity(0.3),
                                      Colors.purple.withOpacity(0.05),
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
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 🔧 Legend for better UX
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _LegendItem(color: Colors.green, text: "DigiGold"),
                      SizedBox(width: 16),
                      _LegendItem(color: Colors.orange, text: "SuperGold"),
                      SizedBox(width: 16),
                      _LegendItem(color: Colors.purple, text: "Thangamagal"),
                    ],
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
