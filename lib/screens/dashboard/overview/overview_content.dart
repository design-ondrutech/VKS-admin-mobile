import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/card/card_bloc.dart';
import 'package:admin/blocs/card/card_state.dart';
import 'package:admin/utils/style.dart';

// Import screens and blocs used in overview
import 'package:admin/screens/dashboard/customer/customer_list.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/total_active_list.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/today_active_list.dart';
import 'package:admin/screens/dashboard/online_payment/online_payment_list.dart';
import 'package:admin/screens/dashboard/cash_payment/cash_payment_list.dart';

import 'package:admin/blocs/customers/customer_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_bloc.dart';
import 'package:admin/blocs/cash_payment/cash_payment_bloc.dart';

class OverviewContent extends StatelessWidget {
  const OverviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state) {
        if (state is CardLoading) {
          // Avoid double spinners
          return const SizedBox.shrink();
        } else if (state is CardLoaded) {
          final summary = state.summary;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _iconCard(
                context,
                title: "Customers",
                value: "${summary.totalCustomers}",
                icon: Icons.group,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<CustomerBloc>(),
                        child: const CustomersScreen(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _iconCard(
                context,
                title: "Total Active",
                value: "${summary.totalActiveSchemes}",
                icon: Icons.layers,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<TotalActiveBloc>(),
                        child: const TotalActiveSchemesScreen(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _iconCard(
                context,
                title: "Today Active",
                value: "${summary.todayActiveSchemes}",
                icon: Icons.layers,
                color: const Color.fromARGB(255, 86, 136, 211),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<TodayActiveSchemeBloc>(),
                        child: const TodayActiveSchemesScreen(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _iconCard(
                context,
                title: "Online Payment",
                value: "₹${formatAmount(summary.totalOnlinePayment)}",
                icon: Icons.account_balance_wallet,
                color: Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<OnlinePaymentBloc>(),
                        child: const OnlinePaymentScreen(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _iconCard(
                context,
                title: "Cash Payment",
                value: "₹${formatAmount(summary.totalCashPayment)}",
                icon: Icons.monetization_on,
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<CashPaymentBloc>(),
                        child: const CashPaymentScreen(),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        } else if (state is CardError) {
          if (state.message.contains("Network Error")) {
            return const SizedBox();
          }
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  static Widget _iconCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
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
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
