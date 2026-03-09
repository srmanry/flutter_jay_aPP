// feature/auth/repo/auth_repo_impl.dart

import 'package:spotem/feature/auth/domain/auth_repo.dart';

import '../../../core/network/api_service/api_client.dart';
import '../../../core/network/api_service/api_endpoints.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await apiClient.post(AuthEndpoints.login, data: {'email': email, 'password': password});

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> signup(String name, String email, String password,String confirmPassword) async {
    final response = await apiClient.post(AuthEndpoints.register, data: {'name': name, 'email': email, 'password': password, 
    'confirmPassword': confirmPassword });

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> sendOtp(String email) async {
    final response = await apiClient.post(AuthEndpoints.resetPassword, data: {'email': email});
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String otp, String email) async {
    final response = await apiClient.post(AuthEndpoints.verifyOtp, data: {'email': email, 'otp': otp});
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> resetPassword(String email, String otp, String newPassword) async {
    final response = await apiClient.post(AuthEndpoints.resetPassword, data: {'email': email, 'otp': otp, 'password': newPassword});

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    final response = await apiClient.post(
      AuthEndpoints.changePassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> deleteAccount() async {
    final response = await apiClient.delete(UserEndpoints.deleteAccount);
    return response.data;
  }
}
