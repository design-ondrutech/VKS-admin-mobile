import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:admin/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLErrorInterceptor extends Link {
  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    if (forward == null) {
      throw Exception("NextLink not found for GraphQLErrorInterceptor");
    }

    return forward(request).map((response) {
      if (response.errors != null && response.errors!.isNotEmpty) {
        for (final error in response.errors!) {
          log("⚠️ GraphQL Error: ${error.message}");

          if (_isTokenExpired(error.message)) {
            _handleTokenExpiry();
          }

          else if (_isNetworkError(error.message)) {
            log("🔹 Ignored network error (already handled).");
          }

          else {
            log("❗Unhandled GraphQL Error: ${error.message}");
          }
        }
      }

      return response;
    }).handleError((error, stackTrace) {
      log("🟥 GraphQL Stream Error: $error");
      return error;
    });
  }

  bool _isTokenExpired(String message) {
    return message.contains("TokenExpiredError") ||
        message.contains("jwt expired") ||
        message.contains("Invalid token") ||
        message.contains("Unauthorized");
  }

  bool _isNetworkError(String message) {
    return message.contains("SocketException") ||
        message.contains("Failed host lookup") ||
        message.contains("Network is unreachable") ||
        message.contains("HandshakeException");
  }

  Future<void> _handleTokenExpiry() async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      log("⚠️ Token expiry dialog skipped (context null)");
      return;
    }

    log("🔴 Token expired detected — clearing token and redirecting.");

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');

    // Optional: You can also clear other saved data like tenant_uuid
    // await prefs.clear();

    // Navigate to login
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    });
  }
}
