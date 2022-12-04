import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  late StreamSubscription<ConnectivityResult> subscription;

  void listenDeviceConnectivity(
      void Function(ConnectivityResult event)? onData) {
    subscription = Connectivity().onConnectivityChanged.listen(onData);
  }

  Future<bool> isThereConnection() async {
    final connectivity = await Connectivity().checkConnectivity();

    return connectivity != ConnectivityResult.none;
  }
}
