import 'dart:async';
import 'package:admin/blocs/gold_price/gold_bloc.dart';
import 'package:admin/blocs/gold_price/gold_event.dart';
import 'package:admin/blocs/gold_price/gold_state.dart';
import 'package:admin/data/models/gold_rate.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/utils/colors.dart';

class DashboardTopHeader extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey; //  added

  const DashboardTopHeader({super.key, this.scaffoldKey});

  @override
  State<DashboardTopHeader> createState() => _DashboardTopHeaderState();
}

class _DashboardTopHeaderState extends State<DashboardTopHeader> {
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();

    //  First fetch when screen loads
    context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());

    // Auto refresh every 30 sec
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              // Logo
              Image.asset('assets/images/icon.jpg', height: 50),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dashboard",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Welcome back, Admin",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 6),

                    //  Gold & Silver Prices Bloc
                    BlocBuilder<GoldPriceBloc, GoldPriceState>(
                      builder: (context, state) {
                        if (state is GoldPriceLoading) {
                          return const Text(
                            "Loading prices...",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          );
                        }

                        if (state is GoldPriceLoaded) {
                          final today = DateTime.now();
                          final todayStr =
                              "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

                          GoldPrice? todayGold;
                          if (state.goldRates.any(
                            (rate) => rate.date == todayStr,
                          )) {
                            todayGold = state.goldRates.firstWhere(
                              (rate) => rate.date == todayStr,
                            );
                          } else {
                            todayGold = null;
                          }

                          GoldPrice? todaySilver;
                          if (state.silverRates.any(
                            (rate) => rate.date == todayStr,
                          )) {
                            todaySilver = state.silverRates.firstWhere(
                              (rate) => rate.date == todayStr,
                            );
                          } else {
                            todaySilver = null;
                          }

                          final goldPrice = todayGold?.price ?? "N/A";
                          final silverPrice = todaySilver?.price ?? "N/A";

                          return Row(
                            children: [
                              _priceTag(
                                "Gold",
                                " ${formatAmount(goldPrice)}",
                                Colors.orange,
                              ),
                              const SizedBox(width: 12),
                              _priceTag(
                                "Silver",
                                " ${formatAmount(silverPrice)}",
                                Colors.blueGrey,
                              ),
                            ],
                          );
                        }

                        if (state is GoldPriceError) {
                          return Text(
                            "Error: ${state.message}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),

              // Menu Icon
              InkWell(
                onTap: () {
                  //  open the Drawer when menu icon tapped
                  widget.scaffoldKey?.currentState?.openDrawer();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Appcolors.buttoncolor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.menu,
                    size: 28,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Small reusable price tag widget
  Widget _priceTag(String title, dynamic value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$title: ₹$value",
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
