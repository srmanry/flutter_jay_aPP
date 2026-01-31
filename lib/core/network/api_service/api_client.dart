import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_endpoints.dart';
import 'token_meneger.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(String baseUrl)
    : _dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 30), receiveTimeout: const Duration(seconds: 30))) {
    _dio.interceptors.add(
      PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: false, error: true, compact: true),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenManager.getToken();
          if (token != null) {
            options.headers['Authorization'] = "Bearer $token";
          }

          print("➡ [REQUEST] ${options.method} ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          /*  if (Get.isSnackbarOpen) {
            Get.closeAllSnackbars();
          } */

          final token = await TokenManager.getToken();

          // Token missing → force logout
          if (token == null) {
            await TokenManager.clearToken();

            return handler.reject(e);
          }

          // Token expired → refresh and retry
          if (e.response?.statusCode == 401) {
            try {
              await _refreshToken();
              final retryResponse = await _dio.fetch(e.requestOptions);
              return handler.resolve(retryResponse);
            } catch (err) {
              await TokenManager.clearToken();

              return handler.reject(e);
            }
          }

          return handler.reject(e);
        },
      ),
    );
  }

  // --- Refresh token logic ---
  Future<void> _refreshToken() async {
    final refreshToken = await TokenManager.getRefreshToken();
    if (refreshToken != null) {
      final response = await _dio.post("$baseApiUrl/auth/refresh-token", data: {"refreshToken": refreshToken}, cancelToken: CancelToken());
      final data = response.data["data"];
      await TokenManager.accessToken(data["accessToken"]);
      await TokenManager.refreshToken(data["refreshToken"]);
    } else {}
  }

  // --- HTTP methods ---
  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return await _dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path, {dynamic data, Options? options}) async {
    return await _dio.post(path, data: data, options: options);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> patch(String url, {dynamic data, File? file}) async {
    return await _dio.patch(url, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) async {
    return _dio.delete(path, data: data);
  }
}
