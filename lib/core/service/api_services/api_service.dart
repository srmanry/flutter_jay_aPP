import 'package:dio/dio.dart';
import 'package:spotem/core/service/socket/socket_service.dart';

import 'api_call_interceptor.dart';

class ApiService {
  ApiService() {
    _dio.interceptors.add(
      ApiCallInterceptor(),
    );
  }
  
  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://backend-jay.onrender.com/api/v1",
    ),
  );
  final SocketService _socketService = SocketService();


  Future<Response> get(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
  }) {
    return _dio.get(path, queryParameters: query, data: data);
  }

  Future<Response> post(String path, {dynamic data, Options? options}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data, Options? options}) {
    return _dio.put(path, data: data, options: options);
  }

  Future<Response> patch(String path, {dynamic data, Options? options}) {
    return _dio.patch(path, data: data, options: options);
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.delete(path, data: data, queryParameters: queryParameters);
  }

  /// Listen to socket event
  Stream<dynamic> listen(String channelName) {
    return _socketService.listen(channelName); // forward events, not just yield the stream object
  }
  /// Emit an event through socket
  void emit(String eventName, [dynamic data]) {
    _socketService.emit(eventName, data);
  }

}