import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../core/network/local/token_manager.dart';


class NotificationController extends GetxController {
  var notifications = <String>[].obs; // list of notifications
  late IO.Socket socket;

  @override
  void onInit() {
    super.onInit();
    initSocket();
  }

  void initSocket() async {
    final token = await TokenManager.getAccessToken();

    socket = IO.io('https://backend-jay.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {
        'Authorization': 'Bearer $token',
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('********************************************* Socket connected');
    });

    socket.on('new_notification', (data) {
      print('New notification received: $data');
      notifications.add(data.toString());
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.onError((err) {
      print('Socket error: $err');
    });
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
