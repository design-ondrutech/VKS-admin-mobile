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
import 'package:admin/screens/dashboard/overview/overview_content.dart';
import 'package:admin/screens/dashboard/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/card/card_bloc.dart';
import 'package:admin/blocs/card/card_event.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/data/graphql_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:admin/screens/dashboard/gold_price/goldrate.dart';
import 'package:admin/screens/dashboard/notification/notification.dart';
import 'package:admin/screens/dashboard/scheme/schemes.dart';
import 'package:admin/screens/dashboard/widgets/header.dart';
import 'package:admin/blocs/dashboard/dashboard_bloc.dart';
import 'package:admin/blocs/dashboard/dashboard_event.dart';
import 'package:admin/blocs/dashboard/dashboard_state.dart';
import 'package:admin/screens/dashboard/widgets/bottom_navigation.dart';
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
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: const OverviewContent(),

            ),
          );
        },
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

}
