import 'package:admin/blocs/card/card_bloc.dart';
import 'package:admin/blocs/card/card_event.dart';
import 'package:admin/blocs/card/card_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/today_active_list.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/total_active_list.dart';
import 'package:admin/screens/dashboard/cash_payment/cash_payment_list.dart';
import 'package:admin/screens/dashboard/customer/customer_list.dart';
import 'package:admin/screens/dashboard/gold_price/goldrate.dart';
import 'package:admin/screens/dashboard/notification/notification.dart';
import 'package:admin/screens/dashboard/online_payment/online_payment_list.dart';
import 'package:admin/screens/dashboard/scheme/schemes.dart';
import 'package:admin/screens/dashboard/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/dashboard/dashboard_bloc.dart';
import 'package:admin/blocs/dashboard/dashboard_event.dart';
import 'package:admin/blocs/dashboard/dashboard_state.dart';
import 'package:admin/widgets/bottom_navigation.dart';
import 'widgets/barchart.dart';

class DashboardScreen extends StatelessWidget {
  final CardRepository repository;
  const DashboardScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CardBloc(repository)..add(FetchCardSummary()),
      child: const DashboardHeader(),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FC),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardTopHeader(), 
            Expanded(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  final tab =
                      state.selectedTab.isEmpty
                          ? "Overview"
                          : state.selectedTab;
                  return _getSelectedTab(context, tab);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return CustomBottomNav(
            selectedTab: state.selectedTab,
            onTabChange: (tab) {
              context.read<DashboardBloc>().add(ChangeDashboardTab(tab));
            },
          );
        },
      ),
    );
  }

  ///  Tab Selection
  Widget _getSelectedTab(BuildContext context, String selectedTab) {
    if (selectedTab == "Overview") {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _overviewContent(),
      );
    } else if (selectedTab == "Schemes") {
      return const SchemesTab();
    } else if (selectedTab == "GoldAdd") {
      return const GoldPriceScreen();
    } else {
      return const NotificationsTab();
    }
  }

  Widget _overviewContent() {
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state) {
        if (state is CardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CardLoaded) {
          final summary = state.summary;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Cards Row
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  children: [
                    _iconCard(
                      "Customers",
                      "${summary.totalCustomers}",
                      Icons.group,
                      Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomersScreen(),
                          ),
                        );
                      },
                    ),

                    _iconCard(
                      "Total Active",
                      "${summary.totalActiveSchemes}",
                      Icons.layers,
                      Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TotalActiveSchemesScreen(),
                          ),
                        );
                      },
                    ),

                     _iconCard(
                      "Today Active",
                      "${summary.todayActiveSchemes}",
                      Icons.layers,
                      const Color.fromARGB(255, 86, 136, 211),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TodayActiveSchemesScreen(),
                          ),
                        );
                      },
                    ),
                    
                    _iconCard(
                      "Online Payment",
                      "₹${summary.totalOnlinePayment}",
                      Icons.account_balance_wallet,
                      Colors.teal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OnlinePaymentScreen(),
                          ),
                        );
                      },
                    ),

                    _iconCard(
                      "Cash Payment",
                      "₹${summary.totalCashPayment}",
                      Icons.monetization_on,
                      Colors.purple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CashPaymentScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Chart Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox(height: 500, child: PerformanceChartScreen()),
              ),
            ],
          );
        } else if (state is CardError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }

  // Simple Icon Card Widget
  Widget _iconCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// na input update pannurathuku vera api tharan athuku bloc and model class and repository and athuku ui ready panni kutu 