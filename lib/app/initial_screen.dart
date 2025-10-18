// import 'package:admin/data/repo/auth_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../screens/dashboard/dashboard_screen.dart';
// import '../screens/login_screen.dart';

// Future<Widget> getInitialScreen(GraphQLClient client) async {
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('accessToken');

//   if (token != null && token.isNotEmpty) {
//     final cardRepository = CardRepository(client);
//     return DashboardScreen(repository: cardRepository);
//   }

//   return const LoginScreen();
// }
