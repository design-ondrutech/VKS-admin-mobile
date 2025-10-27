import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkService {
  NetworkService._internal() {
    _init();
  }

  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  Stream<bool> get onStatusChange => _controller.stream;

  void _init() {
    _checkAndEmit(); // initial check
    Connectivity().onConnectivityChanged.listen((_) => _checkAndEmit());
  }

  Future<void> _checkAndEmit() async {
    final hasInternet = await InternetConnectionChecker().hasConnection;
    _controller.add(hasInternet);
  }

  Future<void> checkNow() => _checkAndEmit(); // retry button use this

  void dispose() {
    _controller.close();
  }
}
