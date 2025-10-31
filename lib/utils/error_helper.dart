class ErrorHelper {
  static bool isNetworkError(String message) {
    final lower = message.toLowerCase();
    return lower.contains("socketexception") ||
        lower.contains("failed host lookup") ||
        lower.contains("network is unreachable") ||
        lower.contains("bad state: no element") ||
        lower.contains("unknownexception") ||
        lower.contains("network error");
  }

  static String getFriendlyMessage(String error) {
    if (error.isEmpty) return "Something went wrong. Please try again.";

    final lower = error.toLowerCase();

    if (isNetworkError(lower)) {
      return "No internet connection. Please check your network and try again.";
    } else if (lower.contains("access token expired") ||
        lower.contains("handledtokenexpired")) {
      return "Your session has expired. Please log in again.";
    } else if (lower.contains("timeout") ||
        lower.contains("connection closed")) {
      return "Request timed out. Please try again later.";
    } else if (lower.contains("unauthorized") ||
        lower.contains("forbidden")) {
      return "You are not authorized to perform this action.";
    } else if (lower.contains("graphql")) {
      return "A server error occurred while fetching data.";
    }

    return "Something went wrong. Please try again.";
  }
}
