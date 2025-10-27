import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin/main.dart'; // for navigatorKey

/// Interceptor that checks for GraphQL errors such as token expiry
class GraphQLErrorInterceptor extends Link {
  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    if (forward == null) {
      throw Exception("NextLink not found for GraphQLErrorInterceptor");
    }

    return forward(request).map((response) {
      // Check for GraphQL errors
      if (response.errors != null && response.errors!.isNotEmpty) {
        for (final error in response.errors!) {
          log("🟡 GraphQL Error: ${error.message}");

          // Detect token expiry
          if (error.message.toLowerCase().contains("access token expired")) {
            log("🔴 Token expired detected — showing dialog...");
            _handleTokenExpired();
          }
        }
      }
      return response;
    });
  }

  void _handleTokenExpired() async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      log("⚠️ navigatorKey context is null — cannot show dialog");
      return;
    }

    // Avoid showing multiple dialogs if already shown
    if (ModalRoute.of(context)?.isCurrent != true) return;

    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken'); // remove token only

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text(
              "Session Expired",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Your session has expired. Please login again to continue.",
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Clear everything
                  await prefs.clear();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  "Login Again",
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
