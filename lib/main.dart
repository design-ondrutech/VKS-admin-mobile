import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:admin/screens/splash_screen.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/data/graphql_config.dart';
import 'package:admin/services/network_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GraphQL Client
  final graphQLClient = await getGraphQLClient();

  // Initialize Network Listener
  NetworkService();

  runApp(MyApp(graphQLClient: graphQLClient));
}

class MyApp extends StatefulWidget {
  final GraphQLClient graphQLClient;
  const MyApp({super.key, required this.graphQLClient});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _snackbarController;

  @override
  void initState() {
    super.initState();

    //  Listen to network status changes
    NetworkService().onStatusChange.listen((online) {
      final context = navigatorKey.currentContext;
      if (context == null) return;

      if (!online) {
        //  Show offline snackbar (if not already visible)
        _snackbarController ??= ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "You’re offline. Please check your connection.",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              duration: Duration(days: 1),
            ),
          );
      } else {
        //  Hide offline snackbar
        _snackbarController?.close();
        _snackbarController = null;

        //  Show back online message
        _showOnlineSnackbar(context);
      }
    });
  }

  // ---------------- SNACKBAR HANDLERS ----------------

  void _showOnlineSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Back online ",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(widget.graphQLClient),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'VKS Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => DashboardScreen(
                repository: CardRepository(widget.graphQLClient),
              ),
        },
        home: const SplashScreen(),
      ),
    );
  }
}
