// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../blocs/gold_price/gold_bloc.dart';
// import '../blocs/gold_price/gold_event.dart';
// import '../blocs/schemes/schemes_bloc.dart';
// import '../blocs/schemes/schemes_event.dart';
// import '../blocs/card/card_bloc.dart';
// import '../blocs/card/card_event.dart';
// import '../blocs/customers/customer_bloc.dart';
// import '../blocs/customers/customer_event.dart';
// import '../blocs/total_active_scheme/total_active_bloc.dart';
// import '../blocs/total_active_scheme/total_active_event.dart';
// import '../blocs/today_active_scheme/today_active_bloc.dart';
// import '../blocs/today_active_scheme/today_active_event.dart';
// import '../blocs/online_payment/online_payment_bloc.dart';
// import '../blocs/online_payment/online_payment_event.dart';
// import '../blocs/cash_payment/cash_payment_bloc.dart';
// import '../blocs/cash_payment/cash_payment_event.dart';
// import '../blocs/notification/notification_bloc.dart';
// import '../blocs/notification/notification_event.dart';

// void handleAppLifecycleStateChange(BuildContext context, AppLifecycleState state) {
//   if (state == AppLifecycleState.resumed) {
//     context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
//     context.read<SchemesBloc>().add(FetchSchemes());
//     context.read<CardBloc>().add(FetchCardSummary());
//     context.read<CustomerBloc>().add(FetchCustomers(page: 1, limit: 10));
//     context.read<TotalActiveBloc>().add(FetchTotalActiveSchemes());
//     context.read<TodayActiveSchemeBloc>()
//       .add(FetchTodayActiveSchemes(page: 1, limit: 10, startDate: 'today'));
//     context.read<OnlinePaymentBloc>().add(FetchOnlinePayments(page: 1, limit: 10));
//     context.read<CashPaymentBloc>().add(FetchCashPayments());
//     context.read<NotificationBloc>().add(FetchNotificationEvent());
//   }
// }
