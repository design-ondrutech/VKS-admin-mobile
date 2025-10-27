import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:admin/screens/splash_screen.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/data/graphql_config.dart';
import 'package:admin/services/network_service.dart';
import 'package:admin/widgets/offline_overlay.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GraphQL Client
  final graphQLClient = await getGraphQLClient();

  // Initialize Network Listener
  NetworkService();

  runApp(
    GraphQLProvider(
      client: ValueNotifier(graphQLClient),
      child: MyApp(graphQLClient: graphQLClient), //  pass client down
    ),
  );
}

class MyApp extends StatefulWidget {
  final GraphQLClient graphQLClient; //  receive client

  const MyApp({super.key, required this.graphQLClient});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final networkStream = NetworkService().onStatusChange;

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'VKS Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),

      //  Routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => DashboardScreen(
              repository: CardRepository(widget.graphQLClient), 
            ),
      },

      //  Home with network listener
      home: StreamBuilder<bool>(
        stream: networkStream,
        initialData: true,
        builder: (context, snapshot) {
          final online = snapshot.data ?? true;

          return Stack(
            children: [
              const SplashScreen(),
              if (!online)
                OfflineOverlay(
                  onRetry: () => NetworkService().checkNow(),
                ),
            ],
          );
        },
      ),
    );
  }
}
