
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotem/core/network/api_service/token_meneger.dart';


import '../local/token_manager.dart';
import 'refresh_token_manager.dart';

class _CancelRefreshToken extends CancelToken {}


class ApiCallInterceptor extends Interceptor {
  final RefreshTokenManager refreshTokenManager = RefreshTokenManager("/auth/refresh-token");
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 2),
      sendTimeout: Duration(seconds: 2),
    ),
  );

  ApiCallInterceptor();

  Future<String?> _currentAccessToken() async=> await TokenManager.getToken();

  bool _refreshingToken = false;

  /// Attaches access token to every request
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _currentAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }
  
  /// Catches errors like 401 and retry with new access token if access token expires.
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // IF TIMEOUT, then possibly internet is down. Hence reject the request.
    debugPrint("Error url:: ${err.requestOptions.uri.toString()}");
    final accessToken = (await _currentAccessToken());
    if(err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.receiveTimeout) {
      return handler.reject(err);
    }
    if(_refreshingToken) {
      return handler.reject(err);
    }
    
    if(err.requestOptions.cancelToken != null) {
      return handler.reject(err);
    }

    if (err.response?.statusCode == 401 && accessToken != null) {
      // get new access token
      RefreshTokenResponse refreshTokenResponse;
      try {
        _refreshingToken = true;
        refreshTokenResponse = await refreshTokenManager.refreshToken(
          refreshToken: await TokenManager.getRefreshToken() ?? ""
        );
        _refreshingToken = false;

        await TokenManager.saveToken(
          accessToken: refreshTokenResponse.accessToken,
          refreshToken: refreshTokenResponse.refreshToken,
          //role: refreshTokenResponse.role,
        );
        
        // Wait a second to receive changes from secure storage.
        await Future.delayed(Duration(seconds: 1)).then((_) async{
          final RequestOptions requestOptions = err.requestOptions;

          try {
            final cloneReq = await dio.request(
              requestOptions.path,
              options: Options(
                method: requestOptions.method,
                contentType: requestOptions.contentType,
              ),
              cancelToken: _CancelRefreshToken(),
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
            );
            return handler.resolve(cloneReq);
          } catch (e) {
            return handler.reject(e as DioException);
          }
        });
      } catch (e) {
        TokenManager.clearToken();
        _refreshingToken = false;
        return handler.reject(DioException(requestOptions: err.requestOptions, error: "Error finding your identity! You need to login!"));
      }
    } else {
      debugPrint(err.message);
      return handler.next(err);
    }
    
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    debugPrint("Api response for ${response.requestOptions.path}::: ${"\n"} ${response.data}");
  }

}
