import 'package:get/get.dart';
import 'package:spotem/app_ground.dart';
import 'package:spotem/core/network/api_service/api_endpoints.dart';
import 'package:spotem/feature/home/data/model/reports_model.dart';
import 'package:spotem/feature/new_featuer/domain/repo/report_repo.dart';
import '../../../../core/network/api_service/api_client.dart';

class ReportRepoImpl implements ReportRepo {
  final ApiClient apiClient;

  ReportRepoImpl(this.apiClient);

  @override
  Future<ReportModel> createReport({
    required String title,
    required String type,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    final body = {
      "title": title,
      "type": type,
      "description": description,
      "location": {
        "type": "Point",
        "coordinates": [longitude, latitude],
      },
    };

    final response = await apiClient.post(ReportEndpoints.create, data: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.to(() => AppGroundView(currentIndex: 3));
      return ReportModel.fromJson(response.data['data']);
    } else {
      throw Exception("Failed to create report");
    }
  }

  @override
  Future<List<ReportModel>> getReports() async {
    final response = await apiClient.get(ReportEndpoints.getAll);

    if (response.statusCode == 200) {
      final data = response.data['data'] as List;
      return data.map((e) => ReportModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch reports");
    }
  }
}
