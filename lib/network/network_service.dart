import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<dynamic> _subscription;

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  NetworkService() {
    _initConnectivity();
    _setupConnectivityListener();
  }

  Future<void> _initConnectivity() async {
    try {
      _isConnected = await _checkConnectionStatus();
      notifyListeners();
    } catch (e) {
      _isConnected = false;
      notifyListeners();
    }
  }

  void _setupConnectivityListener() {
    _subscription =
        _connectivity.onConnectivityChanged.listen((dynamic event) async {
          try {
            final newConnectionStatus = await _checkConnectionStatus();

            if (_isConnected != newConnectionStatus) {
              _isConnected = newConnectionStatus;
              notifyListeners();
            }
          } catch (e) {
            return;
          }
        });
  }

  Future<bool> _checkConnectionStatus() async {
    final result = await _connectivity.checkConnectivity();

    return result.any((r) =>
    r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet);
  }

  Future<void> checkConnection() async {
    final newStatus = await _checkConnectionStatus();
    if (_isConnected != newStatus) {
      _isConnected = newStatus;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
