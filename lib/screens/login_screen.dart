import 'package:admin/blocs/barchart/barchart_bloc.dart';
import 'package:admin/blocs/card/card_bloc.dart';
import 'package:admin/blocs/card/card_event.dart';
import 'package:admin/blocs/cash_payment/cash_payment_bloc.dart';
import 'package:admin/blocs/cash_payment/cash_payment_event.dart';
import 'package:admin/blocs/customers/customer_bloc.dart';
import 'package:admin/blocs/customers/customer_event.dart';
import 'package:admin/blocs/dashboard/dashboard_bloc.dart';
import 'package:admin/blocs/gold_price/gold_bloc.dart';
import 'package:admin/blocs/gold_price/gold_event.dart';
import 'package:admin/blocs/notification/notification_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_event.dart';
import 'package:admin/blocs/schemes/schemes_bloc.dart';
import 'package:admin/blocs/schemes/schemes_event.dart';
import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_event.dart';
import 'package:admin/blocs/total_active_scheme/total_active_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_event.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/bloc/add_gld_bloc.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/widgets/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../data/graphql_config.dart';
import '../data/repo/auth_repository.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../widgets/global_refresh.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phone = TextEditingController();
  final password = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkInternetOnStart();
  }

  Future<void> _checkInternetOnStart() async {
    bool hasInternet = await NetworkHelper.hasInternetConnection();
    if (!hasInternet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NetworkHelper.showNoInternetDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FD),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('accessToken', state.token);

            //  rebuild client with token
            final client = await getGraphQLClient();

            //  navigate with full MultiBlocProvider setup
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => _buildDashboardWithProviders(client),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 70,
                  color: Color(0xFFB38B00),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Welcome to Admin",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Sign in to continue",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: phone,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: const Icon(Icons.phone_android_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: password,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolors.buttoncolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            final phoneText = phone.text.trim();
                            final passwordText = password.text.trim();

                            if (phoneText.isEmpty || passwordText.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all fields"),
                                ),
                              );
                              return;
                            }

                            if (phoneText.length != 10 ||
                                int.tryParse(phoneText) == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Enter a valid 10-digit phone number",
                                  ),
                                ),
                              );
                              return;
                            }
                            context.read<AuthBloc>().add(
                                  LoginRequested(phoneText, passwordText,context),
                                );
                          },
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Include all required BlocProviders here
  Widget _buildDashboardWithProviders(GraphQLClient client) {
    final authRepository = AuthRepository(client);
    final dashboardRepository = CardRepository(client);
    final goldRepository = GoldPriceRepository(client);
    final addGoldPriceRepository = AddGoldPriceRepository(client);
    final customerRepository = CustomerRepository(client);
    final goldDashboardRepository = GoldDashboardRepository(client);
    final totalActiveSchemesRepository =
        TotalActiveSchemesRepository(client: client);
    final todayActiveSchemeRepository = TodayActiveSchemeRepository(client);
    final onlinePaymentRepository = OnlinePaymentRepository(client);
    final cashPaymentRepository = CashPaymentRepository(client);
    final notificationRepository = NotificationRepository(client);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)),
        BlocProvider(create: (_) => DashboardBloc(dashboardRepository)),
        BlocProvider(
          create: (_) =>
              SchemesBloc(SchemeRepository(client))..add(FetchSchemes()),
        ),
        BlocProvider(
          create: (_) =>
              CardBloc(dashboardRepository)..add(FetchCardSummary()),
        ),
        BlocProvider(
          create: (_) =>
              GoldPriceBloc(goldRepository)..add(const FetchGoldPriceEvent()),
        ),
        BlocProvider(create: (_) => AddGoldPriceBloc(addGoldPriceRepository)),
        BlocProvider(
          create: (_) => CustomerBloc(
            customerRepository,
            TotalActiveSchemesRepository(client: client),
          )..add(FetchCustomers(page: 1, limit: 10)),
        ),
        BlocProvider(create: (_) => GoldDashboardBloc(goldDashboardRepository)),
        BlocProvider(
          create: (_) => TotalActiveBloc(
            repository: totalActiveSchemesRepository,
          )..add(FetchTotalActiveSchemes(page: 1, limit: 10)),
        ),
        BlocProvider(
          create: (_) => TodayActiveSchemeBloc(
            repository: todayActiveSchemeRepository,
          )..add(FetchTodayActiveSchemes(
              page: 1, limit: 10, startDate: 'today')),
        ),
        BlocProvider(
          create: (_) => OnlinePaymentBloc(onlinePaymentRepository)
            ..add(FetchOnlinePayments(page: 1, limit: 10)),
        ),
        BlocProvider(
          create: (_) =>
              CashPaymentBloc(cashPaymentRepository)..add(FetchCashPayments(page: 1, limit: 10)),
        ),
        BlocProvider(create: (_) => NotificationBloc(notificationRepository)),
      ],
      child: GlobalRefreshWrapper(
        child: DashboardScreen(repository: dashboardRepository),
      ),
    );
  }
}
