import 'package:dio/dio.dart';

import '../../../core/network/api_service/api_client.dart';
import '../../../core/network/api_service/api_endpoints.dart';

class AuthRepository {
  final ApiClient _apiClient;
  AuthRepository(this._apiClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiClient.post(
      AuthEndpoints.login,
      data: {"email": email, "password": password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    final response = await _apiClient.post(
      AuthEndpoints.register,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
      data: {"fullName": name, "email": email, "password": password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> sendOtp(String email) async {
    final response = await _apiClient.post(
      AuthEndpoints.forgotPassword,
      data: {"email": email},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> verifyOtp(String otp, String email) async {
    final response = await _apiClient.post(
      AuthEndpoints.verifyOtp,
      data: {"code": otp, "email": email},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> resetPassword(
    String email,
    String otp,
    String password,
  ) async {
    final response = await _apiClient.post(
      AuthEndpoints.resetPassword,
      data: {"email": email, "code": otp, "newPassword": password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final response = await _apiClient.patch(
      ProfileEndpoints.changePassword,
      data: {"currentPassword": oldPassword, "newPassword": newPassword},
    );
    return response.data;
  }
}
