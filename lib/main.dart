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

  //  Load client with token (if user logged in before)
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

  // 🔹 Auto-refresh when app is resumed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
        context.read<SchemesBloc>().add(FetchSchemes());
        context.read<CardBloc>().add(FetchCardSummary());
        context.read<CustomerBloc>().add(FetchCustomers(page: 1, limit: 10));
        context.read<TotalActiveBloc>().add(FetchTotalActiveSchemes());
        context.read<TodayActiveSchemeBloc>().add(
          FetchTodayActiveSchemes(page: 1, limit: 10, startDate: 'today'),
        );
        context.read<OnlinePaymentBloc>().add(
          FetchOnlinePayments(page: 1, limit: 10),
        );
        context.read<CashPaymentBloc>().add(FetchCashPayments());
        context.read<NotificationBloc>().add(FetchNotificationEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VKS Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: FutureBuilder(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return snapshot.data ?? _buildLoginWithProvider(widget.client);
          }
        },
      ),
    );
  }

  ///  Redirect user based on token
  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token != null && token.isNotEmpty) {
      final client = await getGraphQLClient(); // authenticated client
      return _buildDashboardWithProviders(client);
    }

    //  If not logged in — wrap LoginScreen with AuthBloc
    return _buildLoginWithProvider(widget.client);
  }

  ///  LoginScreen with AuthBloc provider
  Widget _buildLoginWithProvider(GraphQLClient client) {
    final authRepository = AuthRepository(client);
    return BlocProvider(
      create: (_) => AuthBloc(authRepository),
      child: const LoginScreen(),
    );
  }

  ///  Create all BLoCs with authenticated client
  Widget _buildDashboardWithProviders(GraphQLClient client) {
    final authRepository = AuthRepository(client);
    final dashboardRepository = CardRepository(client);
    final goldRepository = GoldPriceRepository(client);
    final addGoldPriceRepository = AddGoldPriceRepository(client);
    final customerRepository = CustomerRepository(client);
    final goldDashboardRepository = GoldDashboardRepository(client);
    final totalActiveSchemesRepository = TotalActiveSchemesRepository(
      client: client,
    );
    final todayActiveSchemeRepository = TodayActiveSchemeRepository(client);
    final onlinePaymentRepository = OnlinePaymentRepository(client);
    final cashPaymentRepository = CashPaymentRepository(client);
    final notificationRepository = NotificationRepository(client);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)),
        BlocProvider(create: (_) => DashboardBloc(dashboardRepository)),
        BlocProvider(
          create:
              (_) => SchemesBloc(SchemeRepository(client))..add(FetchSchemes()),
        ),

        BlocProvider(
          create: (_) => CardBloc(dashboardRepository)..add(FetchCardSummary()),
        ),
        BlocProvider(
          create:
              (_) =>
                  GoldPriceBloc(goldRepository)
                    ..add(const FetchGoldPriceEvent()),
        ),
        BlocProvider(create: (_) => AddGoldPriceBloc(addGoldPriceRepository)),
        BlocProvider(
          create:
              (_) => CustomerBloc(
                customerRepository,
                TotalActiveSchemesRepository(client: client),
              )..add(FetchCustomers(page: 1, limit: 10)),
        ),
        BlocProvider(create: (_) => GoldDashboardBloc(goldDashboardRepository)),
        BlocProvider(
          create:
              (_) =>
                  TotalActiveBloc(repository: totalActiveSchemesRepository)
                    ..add(FetchTotalActiveSchemes()),
        ),
        BlocProvider(
          create:
              (_) => TodayActiveSchemeBloc(
                repository: todayActiveSchemeRepository,
              )..add(
                FetchTodayActiveSchemes(page: 1, limit: 10, startDate: 'today'),
              ),
        ),
        BlocProvider(
          create:
              (_) =>
                  OnlinePaymentBloc(onlinePaymentRepository)
                    ..add(FetchOnlinePayments(page: 1, limit: 10)),
        ),
        BlocProvider(
          create:
              (_) =>
                  CashPaymentBloc(cashPaymentRepository)
                    ..add(FetchCashPayments()),
        ),
        BlocProvider(create: (_) => NotificationBloc(notificationRepository)),
      ],
      child: GlobalRefreshWrapper(
        child: DashboardScreen(repository: dashboardRepository),
      ),
    );
  }
}
