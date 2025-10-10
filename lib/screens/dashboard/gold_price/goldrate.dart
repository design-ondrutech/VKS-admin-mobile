import 'package:admin/data/models/add_gold_price.dart';
import 'package:admin/data/models/gold_rate.dart';
import 'package:admin/blocs/gold_price/gold_bloc.dart';
import 'package:admin/blocs/gold_price/gold_event.dart';
import 'package:admin/blocs/gold_price/gold_state.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/bloc/add_gld_bloc.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/bloc/add_gold_event.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/bloc/add_gold_state.dart';
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
  bool _hasFetchedOnce = false;

  @override
  void initState() {
    super.initState();
    _fetchOnce();
  }

  void _fetchOnce() {
    if (!_hasFetchedOnce) {
      _hasFetchedOnce = true;
      context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
    }
  }

  Future<void> _onManualRefresh() async {
    context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gold & Silver Rates", style: ThemeText.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.buttoncolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              label: const Text(
                "Add Gold",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => const AddGoldRateDialog(),
                );
                // Delay to avoid rebuild-triggered loop
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) {
                    context
                        .read<GoldPriceBloc>()
                        .add(const FetchGoldPriceEvent());
                  }
                });
              },
            ),
          ),
        ],
      ),

      body: BlocListener<AddGoldPriceBloc, AddGoldPriceState>(
        listener: (context, state) {
          if (state is AddGoldPriceDeleted && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

            // Delay fetch to prevent rapid rebuild loop
            Future.delayed(const Duration(milliseconds: 400), () {
              if (mounted) {
                context
                    .read<GoldPriceBloc>()
                    .add(const FetchGoldPriceEvent());
              }
            });
          } else if (state is AddGoldPriceFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<GoldPriceBloc, GoldPriceState>(
          buildWhen: (previous, current) => current is! GoldPriceLoading,
          builder: (context, state) {
            if (state is GoldPriceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GoldPriceLoaded) {
              final allRates = [...state.goldRates, ...state.silverRates];
              final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

              allRates.sort((a, b) {
                final dateA = DateTime.tryParse(a.date) ?? DateTime(1900);
                final dateB = DateTime.tryParse(b.date) ?? DateTime(1900);
                return dateB.compareTo(dateA);
              });

              if (allRates.isEmpty) {
                return const Center(child: Text("No Gold & Silver Data"));
              }

              return RefreshIndicator(
                onRefresh: _onManualRefresh,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: allRates.length,
                  itemBuilder: (context, index) {
                    final price = allRates[index];
                    return _buildPriceCard(context, price, today);
                  },
                ),
              );
            } else if (state is GoldPriceError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const Center(child: Text("No data"));
            }
          },
        ),
      ),
    );
  }

  Widget _buildPriceCard(BuildContext context, GoldPrice price, String today) {
    final parsedDate = DateTime.tryParse(price.date) ?? DateTime(1900);
    final displayDate = DateFormat('dd-MM-yyyy').format(parsedDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: date + edit/delete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A235A),
                ),
              ),
              if (price.date == today)
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AddGoldRateDialog(
                            existingPrice: GoldPriceInput(
                              id: price.id,
                              date: price.date,
                              metal: price.metal,
                              value: price.value,
                              unit: price.unit,
                              price: price.price,
                            ),
                          ),
                        );
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted) {
                            context
                                .read<GoldPriceBloc>()
                                .add(const FetchGoldPriceEvent());
                          }
                        });
                      },
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Confirm Deletion"),
                            content: const Text(
                                "Are you sure you want to delete this rate?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () {
                                  context
                                      .read<AddGoldPriceBloc>()
                                      .add(DeleteGoldPrice(price.priceId));
                                  Navigator.pop(ctx);
                                },
                                child: const Text("Delete",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Values
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labelValue("Metal", price.metal),
                    const SizedBox(height: 8),
                    _labelValue("Value", price.value),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labelValue("Unit", price.unit),
                    const SizedBox(height: 8),
                    _labelValue("Price", "₹${price.price}",
                        isBold: true, color: const Color(0xFF4A235A)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _labelValue(String label, String value,
      {bool isBold = false, Color color = Colors.black87}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
