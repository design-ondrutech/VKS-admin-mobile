import 'package:admin/blocs/card/card_bloc.dart';
import 'package:admin/blocs/card/card_event.dart';
import 'package:admin/blocs/cash_payment/cash_payment_bloc.dart';
import 'package:admin/blocs/cash_payment/cash_payment_event.dart';
import 'package:admin/blocs/customers/customer_bloc.dart';
import 'package:admin/blocs/customers/customer_event.dart';
import 'package:admin/blocs/gold_price/gold_bloc.dart';
import 'package:admin/blocs/gold_price/gold_event.dart';
import 'package:admin/blocs/notification/notification_bloc.dart';
import 'package:admin/blocs/notification/notification_event.dart';
import 'package:admin/blocs/online_payment/online_payment_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_event.dart';
import 'package:admin/blocs/schemes/schemes_bloc.dart';
import 'package:admin/blocs/schemes/schemes_event.dart';
import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_event.dart';
import 'package:admin/blocs/total_active_scheme/total_active_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalRefreshWrapper extends StatelessWidget {
  final Widget child;
  const GlobalRefreshWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        //  Refresh all blocs

        // Gold Price
        context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());

        // Schemes
        context.read<SchemesBloc>().add(FetchSchemes());

        // Cards Summary
        context.read<CardBloc>().add(FetchCardSummary());

        // Customers
        context.read<CustomerBloc>().add(FetchCustomers(page: 1, limit: 10));

        // Active Schemes
        context.read<TotalActiveBloc>().add(FetchTotalActiveSchemes(page: 1, limit: 10));
        context.read<TodayActiveSchemeBloc>().add(FetchTodayActiveSchemes(page: 1, limit: 10, startDate: 'today'));

        // Payments
        context.read<OnlinePaymentBloc>().add(FetchOnlinePayments(page: 1, limit: 10));
        context.read<CashPaymentBloc>().add(FetchCashPayments(page: 1, limit: 10));

        // Notifications
        context.read<NotificationBloc>().add(FetchNotificationEvent());

        await Future.delayed(const Duration(milliseconds: 500)); // smooth animation
      },
      child: child,
    );
  }
}

