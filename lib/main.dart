import 'package:admin/widgets/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:admin/screens/splash_screen.dart';
import 'package:admin/data/graphql_config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final graphQLClient = await getGraphQLClient();

  runApp(
    GraphQLProvider(
      client: ValueNotifier(graphQLClient),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Connectivity _connectivity;
  ConnectivityResult? _previousStatus;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();

    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final current = results.isNotEmpty ? results.first : ConnectivityResult.none;

      if (current == ConnectivityResult.none &&
          _previousStatus != ConnectivityResult.none) {
        // Internet disconnected
        NetworkHelper.showNoInternetDialog(context);
      } else if (_previousStatus == ConnectivityResult.none &&
          current != ConnectivityResult.none) {
        // Internet reconnected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Back Online"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }

      _previousStatus = current;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     navigatorKey: navigatorKey,
      title: 'VKS Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SplashScreen(),
    );
  }
}
