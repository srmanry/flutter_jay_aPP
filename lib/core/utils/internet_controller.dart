import 'dart:async';

import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  var isConnected = true.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnection();

    // Internet changes stream
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      isConnected.value = results.any((result) => result != ConnectivityResult.none);
    });
  }

  Future<void> checkConnection() async {
    isLoading.value = true;
    final results = await _connectivity.checkConnectivity();
    isConnected.value = results.any((result) => result != ConnectivityResult.none);
    await Future.delayed(const Duration(milliseconds: 500)); // optional delay
    isLoading.value = false;
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}
