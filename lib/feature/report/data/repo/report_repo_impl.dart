import 'package:spotem/core/network/api_service/api_client.dart';
import 'package:spotem/core/network/api_service/api_endpoints.dart';
import 'package:spotem/feature/report/domain/entities/report_coordinate.dart';
import 'package:spotem/feature/report/domain/repo/repo.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ApiClient apiClient;

  ReportRepositoryImpl(this.apiClient);

  @override
  Future<void> createReport({
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
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create report (status: ${response.statusCode})");
    }
  }

  @override
  Future<List<ReportCoordinate>> getReportCoordinates() async {
    final response = await apiClient.get(ReportEndpoints.getCoordinates);
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch report coordinates (status: ${response.statusCode})");
    }

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception("Invalid response body (expected JSON object)");
    }
    final list = data["data"];
    if (list is! List) {
      throw Exception("Invalid response body (expected 'data' as List)");
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map((item) {
          final coords = item["coordinates"];
          if (coords is! List || coords.length < 2) {
            throw Exception("Invalid coordinates in response");
          }

          final lng = (coords[0] as num).toDouble();
          final lat = (coords[1] as num).toDouble();

          final ts = item["timestamp"] ?? item["createdAt"];
          DateTime? createdAt;
          if (ts is String) {
            createdAt = DateTime.tryParse(ts);
          }

          return ReportCoordinate(
            latitude: lat,
            longitude: lng,
            type: (item["type"] ?? "").toString(),
            title: (item["title"] ?? "").toString(),
            description: (item["description"] ?? "").toString(),
            createdAt: createdAt,
          );
        })
        .toList();
  }
}
