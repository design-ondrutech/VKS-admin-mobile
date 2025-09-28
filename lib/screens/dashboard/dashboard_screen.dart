import 'dart:async';
import 'package:admin/blocs/card/card_bloc.dart';
import 'package:admin/blocs/card/card_event.dart';
import 'package:admin/blocs/card/card_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/total_active_list.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/today_active_list.dart';
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

class DashboardScreen extends StatelessWidget {
  final CardRepository repository;
  const DashboardScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CardBloc(repository)..add(FetchCardSummary())),
        BlocProvider(create: (_) => DashboardBloc(repository)),
      ],
      child: const DashboardHeader(),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
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
                  final tab = state.selectedTab.isEmpty ? "Overview" : state.selectedTab;
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

  /// Tab Selection
  Widget _getSelectedTab(BuildContext context, String selectedTab) {
    if (selectedTab == "Overview") {
      return RefreshIndicator(
        onRefresh: () async {
          //  Swipe down refresh trigger
          context.read<CardBloc>().add(FetchCardSummary());
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: _overviewContent(),
        ),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _iconCard("Customers", "${summary.totalCustomers}", Icons.group, Colors.blue,
                onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomersScreen()));
            }),
            const SizedBox(height: 16),
            _iconCard("Today Active", "${summary.todayActiveSchemes}", Icons.layers, Colors.orange,
                onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TotalActiveSchemesScreen()));
            }),
            const SizedBox(height: 16),
            _iconCard("Total Active", "${summary.totalActiveSchemes}", Icons.layers,
                const Color.fromARGB(255, 86, 136, 211), onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TodayActiveSchemesScreen()));
            }),
            const SizedBox(height: 16),
            _iconCard("Online Payment", "₹${summary.totalOnlinePayment}", Icons.account_balance_wallet,
                Colors.teal, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OnlinePaymentScreen()));
            }),
            const SizedBox(height: 16),
            _iconCard("Cash Payment", "₹${summary.totalCashPayment}", Icons.monetization_on, Colors.purple,
                onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CashPaymentScreen()));
            }),
          ],
        );
      } else if (state is CardError) {
        return Center(child: Text(state.message));
      }
      return const SizedBox();
    },
  );
}

Widget _iconCard(String title, String value, IconData icon, Color color, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon with gradient background
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.7), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          // Title and value stacked vertically
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Small arrow icon at the end for navigation hint
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    ),
  );
}



}
