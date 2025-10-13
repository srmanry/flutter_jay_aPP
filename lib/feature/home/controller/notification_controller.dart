import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/network/local/token_manager.dart';
import '../model/notification_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isConnected = false.obs;
  late IO.Socket socket;
  final dio = Dio(BaseOptions(baseUrl: 'https://backend-jay.onrender.com/api/v1'));

  @override
  void onInit() {
    super.onInit();
    initSocket();
    fetchNotifications();
  }

  // Fetch saved notifications from backend
  Future<void> fetchNotifications() async {
    final token = await TokenManager.getAccessToken();
    final res = await dio.get('/notifications',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    final List data = res.data['data'];
    notifications.value =
        data.map((e) => NotificationModel.fromJson(e)).toList();
  }

  // Mark notification as read
  Future<void> markAsRead(String id) async {
    final token = await TokenManager.getAccessToken();
    await dio.patch('/notifications/$id/read',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    await fetchNotifications(); // refresh
  }

  // Socket setup
  void initSocket() async {
    final token = await TokenManager.getAccessToken();

    socket = IO.io(
      'https://backend-jay.onrender.com',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'extraHeaders': {'Authorization': 'Bearer $token'},
      },
    );

    socket.connect();

    socket.onConnect((_) {
      print('✅ Socket connected');
      isConnected.value = true;
      socket.emit("joinAlerts");
    });

    socket.on('new_notification', (data) {
      final n = NotificationModel.fromJson(data);
      notifications.insert(0, n); // add instantly on top
    });

    socket.onDisconnect((_) {
      isConnected.value = false;
    });
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
