import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetController extends GetxController {
  var isConnected = true.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnection();

    // Internet changes stream
    Connectivity().onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        isConnected.value = results.isNotEmpty && results.first != ConnectivityResult.none;
      },
    );
  }

  Future<void> checkConnection() async {
    isLoading.value = true;
    var connectivityResult = await Connectivity().checkConnectivity();
    isConnected.value = connectivityResult != ConnectivityResult.none;
    await Future.delayed(const Duration(milliseconds: 500)); // optional delay
    isLoading.value = false;
  }
}
