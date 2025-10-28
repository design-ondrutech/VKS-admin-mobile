import 'dart:developer';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:admin/services/network_service.dart';

class NetworkErrorInterceptor extends Link {
  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    if (forward == null) {
      throw Exception("NextLink not found for NetworkErrorInterceptor");
    }

    return forward(request).handleError((error, stackTrace) async {
      log("🛑 GraphQL Network Error: $error");

      // Detect offline-like errors
      if (error.toString().contains("SocketException") ||
          error.toString().contains("Failed host lookup") ||
          error.toString().contains("Network is unreachable") ||
          error.toString().contains("UnknownException") ||
          error.toString().contains("Bad state: No element")) {

        // Just trigger a network check — main.dart will handle snackbar
        await NetworkService().checkNow();
      }

      // Return an empty stream to stop propagation
      return const Stream.empty();
    });
  }
}
