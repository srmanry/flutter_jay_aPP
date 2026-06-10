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
      // The create response may return `user` as a String id, which doesn't match
      // `ReportModel`'s expected user object. Fetch full reports and match by id.
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final created = data["data"];
        if (created is Map<String, dynamic>) {
          final createdId = created["_id"]?.toString();
          if (createdId != null && createdId.isNotEmpty) {
            try {
              final all = await getReports();
              final match = all.where((r) => r.id == createdId).toList();
              if (match.isNotEmpty) return match.first;
            } catch (_) {
              // Fallback below.
            }
          }

          // Fallback: build a minimal ReportModel (may have empty user info).
          final userId = created["user"]?.toString() ?? "";
          final locationJson = created["location"];
          return ReportModel(
            id: createdId ?? "",
            user: UserModel(
              id: userId,
              name: "",
              avatar: AvatarModel(publicId: "", url: ""),
            ),
            type: created["type"]?.toString() ?? type,
            title: created["title"]?.toString() ?? title,
            description: created["description"]?.toString() ?? description,
            location: locationJson is Map<String, dynamic> ? LocationModel.fromJson(locationJson) : LocationModel(lat: latitude, lng: longitude),
            createdAt: DateTime.tryParse(created["createdAt"]?.toString() ?? "") ?? DateTime.now(),
          );
        }
      }

      throw Exception("Invalid create report response");
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
