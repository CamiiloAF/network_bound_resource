import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Handle connection states
class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({required Connectivity connectivity})
      : _connectivity = connectivity;

  /// Listen network changes
  void listenDeviceConnectivity(
      void Function(ConnectivityResult event)? onData) {
    _connectivity.onConnectivityChanged.listen(onData);
  }

  /// Check if device is connected to internet
  ///
  /// Returns false when there is no connection and returns true when there is
  Future<bool> isThereConnection() async {
    final connectivity = await _connectivity.checkConnectivity();

    return connectivity != ConnectivityResult.none;
  }
}
