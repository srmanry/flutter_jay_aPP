import 'package:dio/dio.dart';

import '../../../../core/network/api_service/api_client.dart';
import '../../../../core/network/api_service/token_meneger.dart';
import '../../domain/repo/report_repo.dart';


class ReportRepositoryImpl implements ReportRepository {
  final ApiClient apiClient;

  ReportRepositoryImpl({required this.apiClient});

  @override
  Future<bool> createReport({
    required String type,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) throw Exception("Token missing");

      final body = {
        "type": type,
        "description": description,
        "location": {
          "type": "Point",
          "coordinates": [longitude, latitude],
        },
      };

      final response = await apiClient.post(
        "/report/",
        data: body,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Repository error: $e");
      return false;
    }
  }
}
