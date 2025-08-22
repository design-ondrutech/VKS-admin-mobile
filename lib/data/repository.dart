import 'package:admin/data/graphql_config.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final graphQLClient = getGraphQLClient();

  runApp(MyApp(graphQLClient: graphQLClient));
}

class MyApp extends StatelessWidget {
  final GraphQLClient graphQLClient;
  const MyApp({super.key, required this.graphQLClient});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen(
        repository: CardRepository(graphQLClient),
      ),
    );
  }
}
