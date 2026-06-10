import 'package:spotem/core/network/api_service/api_client.dart';
import 'package:spotem/core/network/api_service/api_endpoints.dart';
import 'package:spotem/feature/home/data/model/reports_model.dart';
import 'package:spotem/feature/home/domain/repo/home_repo.dart';

class HomeRepositoryImpl implements HomeRepo {
  final ApiClient apiClient;

  HomeRepositoryImpl(this.apiClient);

  @override
  Future<List<ReportModel>> getReports() async {
    try {
      final response = await apiClient.get(ReportEndpoints.getAll);

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch reports (status: ${response.statusCode})");
      }

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception("Invalid response body (expected JSON object)");
      }

      final list = data['data'];
      if (list is! List) {
        throw Exception("Invalid response body (expected 'data' as List)");
      }

      return list.map((e) => ReportModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, stackTrace) {
      // Keep stack trace for higher layers/loggers.
      Error.throwWithStackTrace(e, stackTrace);
    }
  }
}
