import 'package:spotem/core/network/api_service/api_client.dart';
import 'package:spotem/feature/profile/data/model/profile.dart';
import 'package:spotem/feature/profile/domain/repo/profile_repo.dart';

import '../../../../core/network/api_service/api_endpoints.dart';

class ProfileRepoImpl implements ProfileRepo {
    final ApiClient apiClient;
    ProfileRepoImpl(this.apiClient);
  @override
  Future<List<UserData>> getUserProfile() async{
    final response = await apiClient.get(UserEndpoints.getProfile);
    if (response.statusCode == 200 && response.data["success"] == true) {
        return [UserData.fromJson(response.data["data"])];
      } else {
        throw Exception(response.data["message"] ?? "Failed to fetch profile");
      }
 
  }
}
