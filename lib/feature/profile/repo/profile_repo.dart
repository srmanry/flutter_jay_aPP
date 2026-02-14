/* 

import 'dart:io';

import 'package:shyfinance/features/profile/model/profile_model.dart';
import 'package:get/get.dart';

import '../../../core/network/api_service/api_client.dart';
import '../../../core/network/api_service/api_endpoints.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  Future<Map<String, dynamic>> getProfileData() async {
    final response = await _apiClient.get(AuthEndpoints.getProfile);
    return response.data;
  }

}
 */
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:spotem/feature/profile/data/model/profile.dart';
/* 

import '../../../core/network/api_service/api_client.dart';
import '../../../core/network/api_service/api_endpoints.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  /// Fetch profile data from backend
  Future<UserData> getProfileData() async {
    try {
      final response = await _apiClient.get(UserEndpoints.getProfile);

      if (response.statusCode == 200 && response.data["success"] == true) {
        return UserData.fromJson(response.data["data"]);
      } else {
        throw Exception(response.data["message"] ?? "Failed to fetch profile");
      }
    } catch (e) {
      print("getProfileData error: $e");
      rethrow;
    }
  }

 */
/* 
  /// Update profile with optional avatar
  Future<UserData> updateProfile({required String name, File? avatar, String? address, String? phone}) async {
    try {
      final formData = FormData();

      // Backend expects 'fullName'
      formData.fields.add(MapEntry('fullName', name));

      // Add avatar if provided
      if (avatar != null) {
        formData.files.add(MapEntry('profilePicture', await MultipartFile.fromFile(avatar.path, filename: avatar.path.split('/').last)));
      }

      final response = await _apiClient.patch(
        UserEndpoints.updateProfile, // use API Endpoints file
        data: formData,
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return UserData.fromJson(response.data["data"]);
      } else {
        throw Exception(response.data["message"] ?? "Failed to update profile");
      }
    } catch (e) {
      print("updateProfile error: $e");
      rethrow;
    }
  } */
//}
