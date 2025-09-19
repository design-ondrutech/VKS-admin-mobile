import 'dart:async';
import 'package:admin/data/models/add_gold_price.dart';
import 'package:admin/data/models/gold_rate.dart';
import 'package:admin/blocs/gold_price/gold_bloc.dart';
import 'package:admin/blocs/gold_price/gold_event.dart';
import 'package:admin/blocs/gold_price/gold_state.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/gold_add_popup.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class GoldPriceScreen extends StatefulWidget {
  const GoldPriceScreen({super.key});

  @override
  State<GoldPriceScreen> createState() => _GoldPriceScreenState();
}

class _GoldPriceScreenState extends State<GoldPriceScreen> {
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    // Initial Fetch
    context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());

    // Auto Refresh every 30 sec
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Swipe down refresh
    context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
    await Future.delayed(const Duration(milliseconds: 500)); // smooth animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gold & Silver Rates", style: ThemeText.titleLarge),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<GoldPriceBloc, GoldPriceState>(
          builder: (context, state) {
            if (state is GoldPriceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GoldPriceLoaded) {
              final allRates = [...state.goldRates, ...state.silverRates];
              final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

              allRates.sort((a, b) {
                if (a.date == today && b.date != today) return -1;
                if (b.date == today && a.date != today) return 1;
                return b.date.compareTo(a.date);
              });

              if (allRates.isEmpty) {
                return const Center(child: Text("No Gold & Silver Data"));
              }

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: allRates.length,
                itemBuilder: (context, index) {
                  final price = allRates[index];
                  return _buildPriceCard(context, price);
                },
              );
            } else if (state is GoldPriceError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const Center(child: Text("No data"));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => const AddGoldRateDialog(),
          );
          context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
        },
        backgroundColor: Appcolors.buttoncolor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPriceCard(BuildContext context, GoldPrice price) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final isToday = price.date == today;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price.date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A235A),
                  ),
                ),
                if (isToday)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => AddGoldRateDialog(
                              existingPrice: GoldPriceInput(
                                date: price.date,
                                metal: price.metal,
                                value: price.value,
                                unit: price.unit,
                                price: price.price,
                              ),
                            ),
                          );
                          context
                              .read<GoldPriceBloc>()
                              .add(const FetchGoldPriceEvent());
                        },
                        icon: const Icon(Icons.edit, color: Color(0xFF4A235A)),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Confirm Deletion"),
                              content: const Text(
                                "Are you sure you want to delete this rate?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (price.id == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Cannot delete: ID not found",
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                      return;
                                    }

                                    context.read<GoldPriceBloc>().add(
                                          DeleteGoldPriceEvent(price.id!),
                                        );
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete,
                            color: Colors.redAccent),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    price.metal,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    price.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Text(
                    price.unit,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Text(
                    "₹${price.price}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A235A),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
