import 'package:admin/blocs/gold_price/gold_bloc.dart';
import 'package:admin/blocs/gold_price/gold_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/utils/colors.dart';

class DashboardTopHeader extends StatelessWidget {
  const DashboardTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     blurRadius: 8,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
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

                // Gold & Silver Prices
                BlocBuilder<GoldPriceBloc, GoldPriceState>(
                  builder: (context, state) {
                    if (state is GoldPriceLoading) {
                      return const Text(
                        "Loading prices...",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      );
                    }
                    if (state is GoldPriceLoaded) {
                      final todayGold =
                          state.goldRates.isNotEmpty ? state.goldRates.first.price : "N/A";
                      final todaySilver =
                          state.silverRates.isNotEmpty ? state.silverRates.first.price : "N/A";

                      return Row(
                        children: [
                          _priceTag("Gold", todayGold, Colors.orange),
                          const SizedBox(width: 12),
                          _priceTag("Silver", todaySilver, Colors.blueGrey),
                        ],
                      );
                    }
                    if (state is GoldPriceError) {
                      return Text(
                        "Error: ${state.message}",
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),

          // Menu Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Appcolors.buttoncolor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.menu, size: 28, color: Colors.black87),
          ),
        ],
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
