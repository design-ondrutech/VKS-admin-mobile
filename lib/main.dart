import 'package:admin/blocs/notification/notification_event.dart';
import 'package:admin/blocs/schemes/schemes_event.dart';
import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_event.dart';
import 'package:admin/blocs/total_active_scheme/total_active_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_event.dart';
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
import 'package:admin/data/graphql_config.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/bloc/add_gld_bloc.dart';
import 'package:admin/screens/login_screen.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/widgets/global_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  Wait for GraphQL client (includes token if saved)
  final graphQLClient = await getGraphQLClient();
  runApp(
    GraphQLProvider(
      client: ValueNotifier(graphQLClient),
      child: MyApp(client: graphQLClient),
    ),
  );
}

class MyApp extends StatefulWidget {
  final GraphQLClient client;
  const MyApp({super.key, required this.client});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
      context.read<SchemesBloc>().add(FetchSchemes());
      context.read<CardBloc>().add(FetchCardSummary());
      context.read<CustomerBloc>().add(FetchCustomers(page: 1, limit: 10));
      context.read<TotalActiveBloc>().add(FetchTotalActiveSchemes());
      context.read<TodayActiveSchemeBloc>().add(
        FetchTodayActiveSchemes(page: 1, limit: 10, startDate: 'today'),
      );
      context.read<OnlinePaymentBloc>().add(FetchOnlinePayments(page: 1, limit: 10));
      context.read<CashPaymentBloc>().add(FetchCashPayments());
      context.read<NotificationBloc>().add(FetchNotificationEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(widget.client);
    final dashboardRepository = CardRepository(widget.client);
    final goldRepository = GoldPriceRepository(widget.client);
    final addGoldPriceRepository = AddGoldPriceRepository(widget.client);
    final customerRepository = CustomerRepository(widget.client);
    final goldDashboardRepository = GoldDashboardRepository(widget.client);
    final totalActiveSchemesRepository =
        TotalActiveSchemesRepository(client: widget.client);
    final todayActiveSchemeRepository = TodayActiveSchemeRepository(widget.client);
    final onlinePaymentRepository = OnlinePaymentRepository(widget.client);
    final cashPaymentRepository = CashPaymentRepository(widget.client);
    final notificationRepository = NotificationRepository(widget.client);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)),
        BlocProvider(create: (_) => DashboardBloc(dashboardRepository)),
        BlocProvider(
          create: (_) => SchemesBloc(SchemeRepository(widget.client))
            ..add(FetchSchemes()),
        ),
        BlocProvider(
          create: (_) => CardBloc(dashboardRepository)..add(FetchCardSummary()),
        ),
        BlocProvider(
          create: (_) => GoldPriceBloc(goldRepository)
            ..add(const FetchGoldPriceEvent()),
        ),
        BlocProvider(create: (_) => AddGoldPriceBloc(addGoldPriceRepository)),
        BlocProvider(
          create: (_) => CustomerBloc(
                customerRepository,
                TotalActiveSchemesRepository(client: widget.client),
              )..add(FetchCustomers(page: 1, limit: 10)),
        ),
        BlocProvider(create: (_) => GoldDashboardBloc(goldDashboardRepository)),
        BlocProvider(
          create: (_) => TotalActiveBloc(
            repository: totalActiveSchemesRepository,
          )..add(FetchTotalActiveSchemes()),
        ),
        BlocProvider(
          create: (_) => TodayActiveSchemeBloc(
            repository: todayActiveSchemeRepository,
          )..add(FetchTodayActiveSchemes(page: 1, limit: 10, startDate: 'today')),
        ),
        BlocProvider(
          create: (_) => OnlinePaymentBloc(onlinePaymentRepository)
            ..add(FetchOnlinePayments(page: 1, limit: 10)),
        ),
        BlocProvider(
          create: (_) => CashPaymentBloc(cashPaymentRepository)
            ..add(FetchCashPayments()),
        ),
        BlocProvider(create: (_) => NotificationBloc(notificationRepository)),
      ],
      child: MaterialApp(
        title: 'VKS Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: FutureBuilder(
          future: _getInitialScreen(widget.client), //  Pass the client
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else {
              return GlobalRefreshWrapper(
                child: snapshot.data ?? const LoginScreen(),
              );
            }
          },
        ),
      ),
    );
  }

  ///  Redirect user based on login token
  Future<Widget> _getInitialScreen(GraphQLClient client) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token != null && token.isNotEmpty) {
      final cardRepository = CardRepository(client);
      return DashboardScreen(repository: cardRepository); //  fixed
    }

    return const LoginScreen();
  }
}
