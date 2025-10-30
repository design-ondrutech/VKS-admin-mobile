import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin/main.dart';
import 'package:admin/services/network_service.dart';

class NetworkErrorInterceptor extends Link {
  bool _sessionHandled = false;      // Avoid duplicate session messages
  bool _generalErrorShown = false;   // Avoid multiple generic messages

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    if (forward == null) {
      throw Exception("NextLink not found for NetworkErrorInterceptor");
    }

    return forward(request).handleError((error, stackTrace) async {
      log("🛑 GraphQL Network Error: $error");

      //  Handle token expiration
      if (error is OperationException) {
        final gqlErrors = error.graphqlErrors;

        if (gqlErrors.isNotEmpty &&
            gqlErrors.first.message.contains("Access token expired")) {
          if (!_sessionHandled) {
            _sessionHandled = true;

            final prefs = await SharedPreferences.getInstance();
            await prefs.remove("auth_token");

            scaffoldMessengerKey.currentState?.showSnackBar(
              const SnackBar(
                content: Text("Session expired. Please log in again."),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 3),
              ),
            );

            Future.delayed(const Duration(seconds: 1), () {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            });
          }

          return const Stream.empty();
        }

        //  Handle GraphQL internal server errors
        if (gqlErrors.isNotEmpty &&
            gqlErrors.first.message
                .contains("Cannot return null for non-nullable field")) {
          if (!_generalErrorShown) {
            _generalErrorShown = true;
            _showFriendlyMessage(
              "Server data error. Please contact support or try again later.",
              Colors.orangeAccent,
            );

            Future.delayed(const Duration(seconds: 3),
                () => _generalErrorShown = false);
          }

          return const Stream.empty();
        }
      }

      //  Handle network / offline / timeout issues
      final errorString = error.toString();
      if (errorString.contains("SocketException") ||
          errorString.contains("Failed host lookup") ||
          errorString.contains("Network is unreachable") ||
          errorString.contains("UnknownException") ||
          errorString.contains("Bad state: No element") ||
          errorString.contains("TimeoutException") ||
          errorString.contains("timed out")) {
        await NetworkService().checkNow();

        if (!_generalErrorShown) {
          _generalErrorShown = true;
          _showFriendlyMessage(
            "Network timeout. Please check your internet connection.",
            Colors.amber,
          );
          Future.delayed(const Duration(seconds: 3),
              () => _generalErrorShown = false);
        }

        return const Stream.empty();
      }

      //  Any unknown error
      if (!_generalErrorShown) {
        _generalErrorShown = true;
        _showFriendlyMessage(
          "Something went wrong. Please try again later.",
          Colors.redAccent,
        );
        Future.delayed(const Duration(seconds: 3),
            () => _generalErrorShown = false);
      }

      return Stream.error(error, stackTrace);
    });
  }

  void _showFriendlyMessage(String msg, Color color) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
