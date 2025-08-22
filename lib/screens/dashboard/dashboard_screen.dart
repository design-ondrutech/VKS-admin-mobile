import 'package:admin/blocs/card/card_bloc.dart';
import 'package:admin/blocs/card/card_event.dart';
import 'package:admin/blocs/card/card_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/dashboard/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/dashboard/dashboard_bloc.dart';
import 'package:admin/blocs/dashboard/dashboard_event.dart';
import 'package:admin/blocs/dashboard/dashboard_state.dart';
import 'package:admin/widgets/bottom_navigation.dart';
import 'widgets/schemes.dart';
import 'widgets/barchart.dart';
import 'package:admin/utils/colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
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

  ///  Header Section
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Image.asset('assets/images/icon.jpg', height: 40),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Dashboard",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "Welcome back, Admin",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Appcolors.buttoncolor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.menu, size: 26, color: Colors.black87),
          ),
        ],
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
                  _iconCard("Customers", "${summary.totalCustomers}", Icons.group, Colors.blue),
                  _iconCard("Active Schemes", "${summary.totalActiveSchemes}", Icons.layers, Colors.orange),
                  _iconCard("Online Payment", "₹${summary.totalOnlinePayment}", Icons.account_balance_wallet, Colors.teal),
                  _iconCard("Cash Payment", "₹${summary.totalCashPayment}", Icons.monetization_on, Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Chart Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                height: 300,
                child: BarChartSample(),
              ),
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
Widget _iconCard(String title, String value, IconData icon, Color color) {
  return Container(
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
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}


}
