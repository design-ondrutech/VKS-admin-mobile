// main.dart
import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_event.dart';
import 'package:admin/blocs/total_active_scheme/active_scheme_bloc.dart';
import 'package:admin/blocs/total_active_scheme/active_scheme_event.dart';
import 'package:admin/blocs/auth/auth_bloc.dart';
import 'package:admin/blocs/barchart/barchart_bloc.dart';
import 'package:admin/blocs/card/card_bloc.dart';
import 'package:admin/blocs/card/card_event.dart';
import 'package:admin/blocs/cash_payment/cash_payment_bloc.dart';
import 'package:admin/blocs/cash_payment/cash_payment_event.dart';
import 'package:admin/blocs/customers/customer_bloc.dart';
import 'package:admin/blocs/customers/customer_event.dart';
import 'package:admin/blocs/dashboard/dashboard_bloc.dart';
import 'package:admin/blocs/notification/notification_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_event.dart';
import 'package:admin/blocs/schemes/schemes_bloc.dart';
import 'package:admin/blocs/gold_price/gold_bloc.dart';
import 'package:admin/blocs/gold_price/gold_event.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/bloc/add_gld_bloc.dart';
import 'package:admin/screens/dashboard/scheme/add_scheme/bloc/create_scheme_bloc.dart';
import 'package:admin/screens/login_screen.dart';
import 'package:admin/data/repo/auth_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final HttpLink httpLink = HttpLink(
    'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin',
  );

  // Create the GraphQL client
  final GraphQLClient graphQLClient = GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  );

  runApp(
    GraphQLProvider(
      client: ValueNotifier(graphQLClient),
      child: MyApp(client: graphQLClient),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GraphQLClient client;
  MyApp({required this.client});

  @override
  Widget build(BuildContext context) {
    // Initialize all repositories with the GraphQLClient
    final authRepository = AuthRepository(client);
    final dashboardRepository = CardRepository(client);
    final schemeRepository = SchemeRepository(client);
    final goldRepository = GoldPriceRepository(client);
    final addGoldPriceRepository = AddGoldPriceRepository(client);
    final customerRepository = CustomerRepository(client);
    final goldDashboardRepository = GoldDashboardRepository(client);
    final totalActiveSchemesRepository = TotalActiveSchemesRepository(client: client);
    final todayActiveSchemeRepository = TodayActiveSchemeRepository(client);
    final onlinePaymentRepository = OnlinePaymentRepository(client);
    final cashPaymentRepository = CashPaymentRepository(client);
    final createSchemeRepository = CreateSchemeRepository(client);
    final notificationRepository = NotificationRepository(client);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)),
        BlocProvider(create: (_) => DashboardBloc(dashboardRepository)),
        BlocProvider(create: (_) => SchemesBloc(schemeRepository)),

        BlocProvider(
          create: (_) => CardBloc(dashboardRepository)
            ..add(FetchCardSummary()),
        ),
        BlocProvider(
          create: (_) => GoldPriceBloc(goldRepository)
            ..add(const FetchGoldPriceEvent()),
        ),
        BlocProvider(create: (_) => AddGoldPriceBloc(addGoldPriceRepository)),
        BlocProvider(
          create: (_) => CustomerBloc(customerRepository)
            ..add(FetchCustomers(page: 1, limit: 10)),
        ),
        BlocProvider(create: (_) => GoldDashboardBloc(goldDashboardRepository)),

        //  TotalActiveBloc
        BlocProvider(
          create: (_) => TotalActiveBloc(repository: totalActiveSchemesRepository)
            ..add(FetchTotalActiveSchemes()),
        ),

        //  TodayActiveSchemeBloc
        BlocProvider(
          create: (_) => TodayActiveSchemeBloc(repository: todayActiveSchemeRepository)
            ..add(FetchTodayActiveSchemes()),
        ),

        BlocProvider(
          create: (_) => OnlinePaymentBloc(onlinePaymentRepository)
            ..add(FetchOnlinePayments(page: 1, limit: 10)),
        ),
        BlocProvider(
          create: (_) => CashPaymentBloc(cashPaymentRepository)
            ..add(FetchCashPayments(page: 1, limit: 10)),
        ),
        BlocProvider(create: (_) => CreateSchemeBloc(createSchemeRepository)),
        BlocProvider(create: (_) => NotificationBloc(notificationRepository)),
      ],
      child: MaterialApp(
        title: 'VKS Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: LoginScreen(),
      ),
    );
  }
}
