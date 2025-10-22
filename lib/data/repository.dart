// import 'package:admin/data/graphql_config.dart';
// import 'package:admin/data/repo/auth_repository.dart';
// import 'package:admin/screens/dashboard/dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   //  Wait for the async function to complete
//   final graphQLClient = await getGraphQLClient();

//   runApp(MyApp(graphQLClient: graphQLClient));
// }

// class MyApp extends StatelessWidget {
//   final GraphQLClient graphQLClient;
//   const MyApp({super.key, required this.graphQLClient});

//   @override
//   Widget build(BuildContext context) {
//     return GraphQLProvider(
//       client: ValueNotifier(graphQLClient),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: DashboardScreen(
//           repository: CardRepository(graphQLClient),
//         ),
//       ),
//     );
//   }
// }
