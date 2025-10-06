import 'package:admin/blocs/notification/notification_event.dart';
import 'package:admin/blocs/schemes/schemes_event.dart';
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
import 'package:admin/data/graphql_config.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/bloc/add_gld_bloc.dart';
import 'package:admin/screens/login_screen.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/widgets/global_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final HttpLink httpLink = HttpLink(
  // //  'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin',
  // );
   final HttpLink httpLink = HttpLink('http://10.0.2.2:4000/graphql/admin');
   
  //final HttpLink httpLink = HttpLink('https://api.vkskumaran.in/graphql/admin');

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
      //  App minimize pannitu open aana udane refresh pannalaam
      // Gold price refresh
      context.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());

      // Other Blocs refresh (optional)
      context.read<SchemesBloc>().add(FetchSchemes());
      context.read<CardBloc>().add(FetchCardSummary());
      context.read<CustomerBloc>().add(FetchCustomers(page: 1, limit: 10));
      context.read<TotalActiveBloc>().add(FetchTotalActiveSchemes());
      context.read<TodayActiveSchemeBloc>().add(FetchTodayActiveSchemes());
      context.read<OnlinePaymentBloc>().add(
        FetchOnlinePayments(page: 1, limit: 10),
      );
      context.read<CashPaymentBloc>().add(FetchCashPayments());
      context.read<NotificationBloc>().add(
        FetchNotificationEvent(),
      ); // if exists
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize repositories using widget.client
    final authRepository = AuthRepository(widget.client);
    final dashboardRepository = CardRepository(widget.client);
    final goldRepository = GoldPriceRepository(widget.client);
    final addGoldPriceRepository = AddGoldPriceRepository(widget.client);
    final customerRepository = CustomerRepository(widget.client);
    final goldDashboardRepository = GoldDashboardRepository(widget.client);
    final totalActiveSchemesRepository = TotalActiveSchemesRepository(
      client: widget.client,
    );
    final todayActiveSchemeRepository = TodayActiveSchemeRepository(
      widget.client,
    );
    final onlinePaymentRepository = OnlinePaymentRepository(widget.client);
    final cashPaymentRepository = CashPaymentRepository(widget.client);
    final notificationRepository = NotificationRepository(widget.client);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)),
        BlocProvider(create: (_) => DashboardBloc(dashboardRepository)),
        BlocProvider(
          create:
              (_) =>
                  SchemesBloc(SchemeRepository(getGraphQLClient()))
                    ..add(FetchSchemes()),
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
              (_) =>
                  CustomerBloc(customerRepository)
                    ..add(FetchCustomers(page: 1, limit: 10)),
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
              (_) =>
                  TodayActiveSchemeBloc(repository: todayActiveSchemeRepository)
                    ..add(FetchTodayActiveSchemes()),
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

      child: MaterialApp(
        title: 'VKS Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: GlobalRefreshWrapper(
          child: const LoginScreen(), // or DashboardScreen after login
        ),
      ),
    );
  }
}

// import 'package:admin/Test%20_Screen%20_Code.dart';
// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initHiveForFlutter();
//   runApp(const MaterialApp(home: CustomerTestScreen()));
// }
