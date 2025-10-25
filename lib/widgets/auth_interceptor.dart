import 'package:admin/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin/main.dart'; //  for navigatorKey

class GraphQLErrorInterceptor extends Link {
  bool _dialogShown = false; // prevent multiple dialogs

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    return forward!(request).map((response) {
      final errors = response.errors;
      if (errors != null && errors.isNotEmpty) {
        for (final error in errors) {
          //  Add your debug log here
          print(" GraphQL Error: ${error.message}");

          final message = error.message.toLowerCase();
          if (message.contains("access token expired")) {
            //  Add your debug log here
            print(" Token Expired Detected – showing dialog...");
            _handleTokenExpiry();
            break;
          }
        }
      }
      return response;
    });
  }

  void _handleTokenExpiry() async {
    if (_dialogShown) return;
    _dialogShown = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Session Expired"),
          content: const Text("Your session has expired. Please login again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
                _dialogShown = false;
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      await prefs.clear();
      _dialogShown = false;
    }
  }
}
