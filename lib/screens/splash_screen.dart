import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Your imports
import 'package:admin/data/graphql_config.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/login_screen.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/blocs/auth/auth_bloc.dart';
import 'package:admin/blocs/dashboard/dashboard_bloc.dart';
import 'package:admin/blocs/card/card_bloc.dart';
import 'package:admin/blocs/schemes/schemes_bloc.dart';
import 'package:admin/blocs/customers/customer_bloc.dart';
import 'package:admin/blocs/gold_price/gold_bloc.dart';
import 'package:admin/blocs/notification/notification_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_bloc.dart';
import 'package:admin/blocs/cash_payment/cash_payment_bloc.dart';
import 'package:admin/widgets/global_refresh.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final tenantUuid = prefs.getString('tenant_uuid');

    print(" Token at startup: $token");
    print(" Tenant UUID at startup: $tenantUuid");

    if (token != null &&
        token.isNotEmpty &&
        tenantUuid != null &&
        tenantUuid.isNotEmpty) {
      final client = await getGraphQLClient();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => _buildDashboardWithProviders(client),
        ),
      );
    } else {
      await prefs.clear(); 
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => _buildLoginWithProvider()),
      );
    }
  }

  Widget _buildLoginWithProvider() {
    final unauthenticatedClient = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: HttpLink( 'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin'),
      
    );

    final authRepository = AuthRepository(unauthenticatedClient);
    return BlocProvider(
      create: (_) => AuthBloc(authRepository),
      child: const LoginScreen(),
    );
  }

  Widget _buildDashboardWithProviders(GraphQLClient client) {
    final dashboardRepository = CardRepository(client);
    final goldRepository = GoldPriceRepository(client);
    final customerRepository = CustomerRepository(client);
    final notificationRepository = NotificationRepository(client);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthRepository(client))),
        BlocProvider(create: (_) => DashboardBloc(dashboardRepository)),
        BlocProvider(create: (_) => CardBloc(dashboardRepository)),
        BlocProvider(create: (_) => SchemesBloc(SchemeRepository(client))),
        BlocProvider(create: (_) => CustomerBloc(
              customerRepository,
              TotalActiveSchemesRepository(client: client),
            )),
        BlocProvider(create: (_) => GoldPriceBloc(goldRepository)),
        BlocProvider(create: (_) => NotificationBloc(notificationRepository)),
        BlocProvider(create: (_) => TodayActiveSchemeBloc(repository: TodayActiveSchemeRepository(client))),
        BlocProvider(create: (_) => TotalActiveBloc(repository: TotalActiveSchemesRepository(client: client))),
        BlocProvider(create: (_) => OnlinePaymentBloc(OnlinePaymentRepository(client))),
        BlocProvider(create: (_) => CashPaymentBloc(CashPaymentRepository(client))),
      ],
      child: GlobalRefreshWrapper(
        child: DashboardScreen(repository: dashboardRepository),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.deepPurple),
            SizedBox(height: 16),
            Text(
              "Loading VKS Admin...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

