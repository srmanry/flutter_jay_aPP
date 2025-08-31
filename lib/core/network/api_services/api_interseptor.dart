/* import 'package:dio/dio.dart';
import 'token_manager.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager tokenManager;
  final Dio dio;

  AuthInterceptor({required this.tokenManager, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // By default, token লাগবে যদি extra['requiresToken'] না দেওয়া হয়
    bool requiresToken = options.extra['requiresToken'] ?? true;

    if (requiresToken) {
      final token = await tokenManager.getAccessToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await tokenManager.getRefreshToken();
        if (refreshToken != null) {
          final response = await dio.post('/auth/refresh', data: {'refreshToken': refreshToken});
          final newAccess = response.data['accessToken'];
          final newRefresh = response.data['refreshToken'];

          await tokenManager.saveTokens(newAccess, newRefresh);

          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccess';

          final cloneReq = await dio.request(opts.path,
              options: Options(method: opts.method, headers: opts.headers),
              data: opts.data,
              queryParameters: opts.queryParameters);

          return handler.resolve(cloneReq);
        }
      } catch (e) {
        await tokenManager.clearTokens();
      }
    }

    super.onError(err, handler);
  }
}
 */