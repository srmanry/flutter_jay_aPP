import 'dart:io';

import 'package:dio/dio.dart';
import 'package:spotem/core/network/api_service/api_client.dart';
import 'package:spotem/feature/profile/data/model/profile.dart';
import 'package:spotem/feature/profile/domain/repo/profile_repo.dart';

import '../../../../core/network/api_service/api_endpoints.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ApiClient apiClient;
  ProfileRepoImpl(this.apiClient);
  @override
  Future<List<UserData>> getUserProfile() async {
    final response = await apiClient.get(UserEndpoints.getProfile);
    if (response.statusCode == 200 && response.data["success"] == true) {
      print("----------------- getUserProfile response: ${response.data}");
      
      return [UserData.fromJson(response.data["data"])];
      
    } else {
      print("============= getUserProfile error: ${response.data}");
      throw Exception(response.data["message"] ?? "Failed to fetch profile");
    }
  }

  @override
  Future<UserProfileModel> updateProfile({required String name, required String address, File? avatar}) async {
    try {
      final formData = FormData.fromMap({
        "name": name,
        "address": address,
        if (avatar != null) "avatar": await MultipartFile.fromFile(avatar.path, filename: avatar.path.split('/').last),
      });

      final response = await apiClient.patch(UserEndpoints.updateProfile, data: formData);

      if (response.statusCode == 200 && response.data["success"] == true) {
        
        return UserProfileModel.fromJson(response.data);
      } else {
        throw Exception(response.data["message"] ?? "Update failed");
      }
    } catch (e) {
      rethrow;
    }
  }
}
