import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:admin/screens/splash_screen.dart';
import 'package:admin/data/graphql_config.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VKS Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SplashScreen(), 
    );
  }
}
