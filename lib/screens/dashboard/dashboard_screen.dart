import 'package:admin/blocs/cash_payment/cash_payment_bloc.dart';
import 'package:admin/blocs/cash_payment/cash_payment_event.dart';
import 'package:admin/blocs/customers/customer_bloc.dart';
import 'package:admin/blocs/customers/customer_event.dart';
import 'package:admin/blocs/online_payment/online_payment_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_event.dart';
import 'package:admin/blocs/schemes/schemes_state.dart';
import 'package:admin/blocs/today_active_scheme/today_active_bloc.dart';
import 'package:admin/blocs/today_active_scheme/today_active_event.dart';
import 'package:admin/blocs/total_active_scheme/total_active_bloc.dart';
import 'package:admin/blocs/total_active_scheme/total_active_event.dart';
import 'package:admin/blocs/schemes/schemes_bloc.dart';
import 'package:admin/blocs/schemes/schemes_event.dart';
import 'package:admin/blocs/gold_price/gold_bloc.dart';
import 'package:admin/blocs/gold_price/gold_event.dart';
import 'package:admin/blocs/notification/notification_bloc.dart';
import 'package:admin/blocs/notification/notification_event.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/bloc/add_gld_bloc.dart';
import 'package:admin/screens/dashboard/widgets/admin_drawer.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/card/card_bloc.dart';
import 'package:admin/blocs/card/card_event.dart';
import 'package:admin/blocs/card/card_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/data/graphql_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/total_active_list.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/today_active_list.dart';
import 'package:admin/screens/dashboard/cash_payment/cash_payment_list.dart';
import 'package:admin/screens/dashboard/customer/customer_list.dart';
import 'package:admin/screens/dashboard/gold_price/goldrate.dart';
import 'package:admin/screens/dashboard/notification/notification.dart';
import 'package:admin/screens/dashboard/online_payment/online_payment_list.dart';
import 'package:admin/screens/dashboard/scheme/schemes.dart';
import 'package:admin/screens/dashboard/widgets/header.dart';
import 'package:admin/blocs/dashboard/dashboard_bloc.dart';
import 'package:admin/blocs/dashboard/dashboard_event.dart';
import 'package:admin/blocs/dashboard/dashboard_state.dart';
import 'package:admin/widgets/bottom_navigation.dart';
import 'package:admin/widgets/global_refresh.dart';

class DashboardScreen extends StatefulWidget {
  final CardRepository repository;
  const DashboardScreen({super.key, required this.repository});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  GraphQLClient? _client;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initClient();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///  Auto refresh when app resumes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      try {
        final ctx = context;
        ctx.read<GoldPriceBloc>().add(const FetchGoldPriceEvent());
        ctx.read<SchemesBloc>().add(FetchSchemes());
        ctx.read<CardBloc>().add(FetchCardSummary());
        ctx.read<CustomerBloc>().add(FetchCustomers(page: 1, limit: 10));
        ctx.read<TotalActiveBloc>().add(
          FetchTotalActiveSchemes(page: 1, limit: 10),
        );
        ctx.read<TodayActiveSchemeBloc>().add(
          FetchTodayActiveSchemes(page: 1, limit: 10, startDate: 'today'),
        );
        ctx.read<OnlinePaymentBloc>().add(
          FetchOnlinePayments(page: 1, limit: 10),
        );
        ctx.read<CashPaymentBloc>().add(FetchCashPayments(page: 1, limit: 10));
        ctx.read<NotificationBloc>().add(FetchNotificationEvent());
      } catch (e) {
        debugPrint("⚠️ Skipped refresh — bloc closed after logout: $e");
      }
    }
  }

  Future<void> _initClient() async {
    final client = await getGraphQLClient();
    setState(() {
      _client = client;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _client == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final repository = CardRepository(_client!);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CardBloc(repository)..add(FetchCardSummary()),
        ),
        BlocProvider(create: (_) => DashboardBloc(repository)),
      ],
      child: const DashboardHeader(),
    );
  }
}

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7F7FC),
      drawer: const AdminDrawer(),
      body: SafeArea(
        child: GlobalRefreshWrapper(
          child: Column(
            children: [
              DashboardTopHeader(scaffoldKey: _scaffoldKey),
              Expanded(
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    final tab =
                        state.selectedTab.isEmpty
                            ? "Overview"
                            : state.selectedTab;
                    return _getSelectedTab(context, tab);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return CustomBottomNav(
            selectedTab: state.selectedTab,
            onTabChange: (tab) {
              context.read<DashboardBloc>().add(ChangeDashboardTab(tab));
            },
          );
        },
      ),
    );
  }

  Widget _getSelectedTab(BuildContext context, String selectedTab) {
    // ---------- OVERVIEW ----------
    if (selectedTab == "Overview") {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: _overviewContent(context),
      );
    }
    // ---------- SCHEMES ----------
    else if (selectedTab == "Schemes") {
      final schemesBloc = context.read<SchemesBloc>();

      if (schemesBloc.state is SchemeInitial) {
        schemesBloc.add(FetchSchemes());
      }

      return BlocProvider.value(value: schemesBloc, child: const SchemesTab());
    }
    // ---------- GOLD PRICE ADD ----------
    else if (selectedTab == "GoldAdd") {
      final client = GraphQLProvider.of(context).value;

      return BlocProvider(
        create: (_) => AddGoldPriceBloc(AddGoldPriceRepository(client)),
        child: const GoldPriceScreen(),
      );
    }
    // ---------- NOTIFICATIONS ----------
    else {
      return const NotificationsTab();
    }
  }

  Widget _overviewContent(BuildContext context) {
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state) {
        if (state is CardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CardLoaded) {
          final summary = state.summary;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _iconCard(
                "Customers",
                "${summary.totalCustomers}",
                Icons.group,
                Colors.blue,
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
                "Total Active",
                "${summary.totalActiveSchemes}",
                Icons.layers,
                Colors.orange,
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
                "Today Active",
                "${summary.todayActiveSchemes}",
                Icons.layers,
                const Color.fromARGB(255, 86, 136, 211),
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
                "Online Payment",
                "₹${formatAmount(summary.totalOnlinePayment)}",
                Icons.account_balance_wallet,
                Colors.teal,
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
                "Cash Payment",
                "₹${formatAmount(summary.totalCashPayment)}",
                Icons.monetization_on,
                Colors.purple,
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
          //  Don’t show exception text for network issues
          if (state.message.contains("Network Error")) {
            return const SizedBox(); // Snackbar handles it
          }

          //  Show other errors normally
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

  Widget _iconCard(
    String title,
    String value,
    IconData icon,
    Color color, {
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
