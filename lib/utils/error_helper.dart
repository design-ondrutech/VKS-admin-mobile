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
}
