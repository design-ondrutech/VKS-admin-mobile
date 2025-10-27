import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:admin/main.dart';
import 'package:admin/widgets/offline_overlay.dart';
import 'package:admin/services/network_service.dart';

class NetworkErrorInterceptor extends Link {
  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    if (forward == null) {
      throw Exception("NextLink not found for NetworkErrorInterceptor");
    }

    return forward(request).handleError((error, stackTrace) async {
      log("🛑 GraphQL Network Error: $error");

      if (error.toString().contains("SocketException") ||
          error.toString().contains("Failed host lookup") ||
          error.toString().contains("Network is unreachable")) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          Future.delayed(Duration.zero, () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const OfflineOverlay(),
            );
          });
        }
        await NetworkService().checkNow();
      }

      throw error;
    });
  }
}
