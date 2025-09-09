// core/network/auth_service.dart
import 'dart:io';
import 'package:dio/dio.dart';

class AuthService {
  final Dio dioClient = Dio(BaseOptions(
    baseUrl: "https://backend-jay.onrender.com/api/v1",
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // =================== Auth ===================
  Future<Response> login(String email, String password) async {
    return await dioClient.post(
      "/auth/login",
      data: {"email": email, "password": password},
      options: Options(headers: {"Content-Type": "application/json"}),
    );
  }

  Future<Response> register(Map<String, dynamic> data) async {
    return await dioClient.post(
      "/auth/register",
      data: data,
      options: Options(headers: {"Content-Type": "application/json"}),
    );
  }

  Future<Response> sendOtp(String email) async {
    return await dioClient.post(
      "/auth/forget",
      data: {"email": email},
      options: Options(headers: {"Content-Type": "application/json"}),
    );
  }

  Future<Response> verifyOtp(String email, String otp) async {
    return await dioClient.post(
      "/auth/verify-otp",
      data: {"email": email, "otp": otp},
      options: Options(headers: {"Content-Type": "application/json"}),
    );
  }

  Future<Response> resetPassword(String email, String otp, String newPassword) async {
    return await dioClient.post(
      "/auth/reset-password",
      data: {"email": email, "otp": otp, "password": newPassword},
      options: Options(headers: {"Content-Type": "application/json"}),
    );
  }

  // =================== User ===================
  Future<Response> fetchProfile(String token) async {
    return await dioClient.get(
      "/user/profile",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> changePassword(
      String token, String currentPassword, String newPassword, String confirmPassword) async {
    return await dioClient.post(
      "/user/change-password",
      data: {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> updateProfile(
      {required String token,
        required String name,
        required String phone,
        required String address,
        File? imageFile}) async {
    FormData formData = FormData.fromMap({
      "name": name,
      "phone": phone,
      "address": address,
      if (imageFile != null) "avatar": await MultipartFile.fromFile(imageFile.path),
    });

    return await dioClient.patch(
      "/user/update-profile",
      data: formData,
      options: Options(
        headers: {"Authorization": "Bearer $token", "Content-Type": "multipart/form-data"},
      ),
    );
  }
}
