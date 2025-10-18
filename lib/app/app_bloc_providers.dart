// import 'package:admin/blocs/barchart/barchart_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// import '../blocs/auth/auth_bloc.dart';
// import '../blocs/dashboard/dashboard_bloc.dart';
// import '../blocs/schemes/schemes_bloc.dart';
// import '../blocs/gold_price/gold_bloc.dart';
// import '../blocs/card/card_bloc.dart';
// import '../blocs/customers/customer_bloc.dart';
// import '../blocs/total_active_scheme/total_active_bloc.dart';
// import '../blocs/today_active_scheme/today_active_bloc.dart';
// import '../blocs/online_payment/online_payment_bloc.dart';
// import '../blocs/cash_payment/cash_payment_bloc.dart';
// import '../blocs/notification/notification_bloc.dart';
// import '../screens/dashboard/gold_price/add_gold_price/bloc/add_gld_bloc.dart';
// import '../data/repo/auth_repository.dart';
// import '../blocs/card/card_event.dart';
// import '../blocs/schemes/schemes_event.dart';
// import '../blocs/gold_price/gold_event.dart';
// import '../blocs/customers/customer_event.dart';
// import '../blocs/total_active_scheme/total_active_event.dart';
// import '../blocs/today_active_scheme/today_active_event.dart';
// import '../blocs/online_payment/online_payment_event.dart';
// import '../blocs/cash_payment/cash_payment_event.dart';

// List<BlocProvider> createAppBlocProviders(GraphQLClient client) {
//   final authRepository = AuthRepository(client);
//   final dashboardRepository = CardRepository(client);
//   final goldRepository = GoldPriceRepository(client);
//   final addGoldPriceRepository = AddGoldPriceRepository(client);
//   final customerRepository = CustomerRepository(client);
//   final goldDashboardRepository = GoldDashboardRepository(client);
//   final totalActiveSchemesRepository = TotalActiveSchemesRepository(client: client);
//   final todayActiveSchemeRepository = TodayActiveSchemeRepository(client);
//   final onlinePaymentRepository = OnlinePaymentRepository(client);
//   final cashPaymentRepository = CashPaymentRepository(client);
//   final notificationRepository = NotificationRepository(client);

//   return [
//     BlocProvider(create: (_) => AuthBloc(authRepository)),
//     BlocProvider(create: (_) => DashboardBloc(dashboardRepository)),
//     BlocProvider(create: (_) => SchemesBloc(SchemeRepository(client))..add(FetchSchemes())),
//     BlocProvider(create: (_) => CardBloc(dashboardRepository)..add(FetchCardSummary())),
//     BlocProvider(create: (_) => GoldPriceBloc(goldRepository)..add(const FetchGoldPriceEvent())),
//     BlocProvider(create: (_) => AddGoldPriceBloc(addGoldPriceRepository)),
//     BlocProvider(create: (_) => CustomerBloc(customerRepository, totalActiveSchemesRepository)
//       ..add(FetchCustomers(page: 1, limit: 10))),
//     BlocProvider(create: (_) => GoldDashboardBloc(goldDashboardRepository)),
//     BlocProvider(create: (_) => TotalActiveBloc(repository: totalActiveSchemesRepository)
//       ..add(FetchTotalActiveSchemes())),
//     BlocProvider(create: (_) => TodayActiveSchemeBloc(repository: todayActiveSchemeRepository)
//       ..add(FetchTodayActiveSchemes(page: 1, limit: 10, startDate: 'today'))),
//     BlocProvider(create: (_) => OnlinePaymentBloc(onlinePaymentRepository)
//       ..add(FetchOnlinePayments(page: 1, limit: 10))),
//     BlocProvider(create: (_) => CashPaymentBloc(cashPaymentRepository)..add(FetchCashPayments())),
//     BlocProvider(create: (_) => NotificationBloc(notificationRepository)),
//   ];
// }
