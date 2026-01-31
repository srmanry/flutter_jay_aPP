/* import 'package:app_pigeon/app_pigeon.dart';
import 'package:dio/src/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:shyfinance/core/network/api_service/api_endpoints.dart';

class RefreshTokenManager implements RefreshTokenManagerInterface{
  
  @override
  Future<RefreshTokenResponse> refreshToken({required String refreshToken, required Dio dio}) async{
    debugPrint("Refreshing token with url: $url, refreshToken: $refreshToken");
    final response = await dio.post(url, data: {
      "refreshToken": refreshToken,
    });
    debugPrint("Refresh token response: ${response.data}");
    final data = response.data["data"];
    return RefreshTokenResponse(
      accessToken: data["accessToken"], 
      refreshToken: data["refreshToken"],
      data: (data["userId"] != null) ? 
        {
          "userId": data["userId"],
        } : null
    );
  }

  @override
  // TODO: implement url
  String get url => AuthEndpoints.refreshToken;

} */