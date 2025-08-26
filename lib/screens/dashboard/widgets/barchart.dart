import 'package:admin/blocs/barchart/barchart_bloc.dart';
import 'package:admin/blocs/barchart/barchart_event.dart';
import 'package:admin/blocs/barchart/barchart_state.dart';
import 'package:admin/data/models/barchart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceChartScreen extends StatefulWidget {
  const PerformanceChartScreen({super.key});

  @override
  State<PerformanceChartScreen> createState() => _PerformanceChartScreenState();
}

class _PerformanceChartScreenState extends State<PerformanceChartScreen> {
  String selectedFilter = "Month";
  final List<String> filters = ["Week", "Month", "Year"];

  @override
  void initState() {
    super.initState();
    context.read<GoldDashboardBloc>().add(FetchGoldDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: BlocBuilder<GoldDashboardBloc, GoldDashboardState>(
        builder: (context, state) {
          if (state is GoldDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GoldDashboardError) {
            return Center(child: Text(state.message));
          }
          if (state is GoldDashboardLoaded) {
            final data = state.data;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _latestCard(data),
                const SizedBox(height: 16),
                _performanceCard(data.monthlySummary),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _latestCard(GoldDashboardModel data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.04), blurRadius: 12),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _kv(
            "Latest Gold Weight",
            "${data.latestGoldWeight.toStringAsFixed(2)} g",
          ),
          _kv("Last Buy Date", data.latestBuyDate),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        Text(
          v,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _performanceCard(List<MonthlySummary> monthlySummary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.04), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Segmented Control
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Performance Chart",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              _filters(),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(height: 250, child: _barChart(monthlySummary)),
        ],
      ),
    );
  }

  Widget _filters() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              filters.map((f) {
                final sel = f == selectedFilter;
                return GestureDetector(
                  onTap: () => setState(() => selectedFilter = f),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: sel ? const Color(0xFF6E56CF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        color: sel ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _barChart(List<MonthlySummary> monthlySummary) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final i = value.toInt();
                if (i >= 0 && i < monthlySummary.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      monthlySummary[i].month,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        barGroups:
            monthlySummary.asMap().entries.map((e) {
              final i = e.key;
              final v = e.value.goldBought; // already double
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: v,
                    width: 18,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.greenAccent.shade400,
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
