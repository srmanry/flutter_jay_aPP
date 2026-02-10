import 'package:spotem/core/network/api_service/api_client.dart';
import 'package:spotem/core/network/api_service/api_endpoints.dart';
import 'package:spotem/feature/home/data/model/reports_model.dart';
import 'package:spotem/feature/home/domain/repo/home_repo.dart';

class HomeRepositoryImpl implements HomeRepo {
  final ApiClient apiClient;

  HomeRepositoryImpl(this.apiClient);
  /* 
  @override
  Future<List<ReportModel>> getReports() async {
    try {
      final response = await apiClient.get(ReportEndpoints.getAll);

      final List list = response.data['data'];

      return list
          .map((e) => ReportModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Failed to load transactions");
    }
  } */

  @override
  Future<List<ReportModel>> getReports() async {
    try {
      print("API কল শুরু → ${ReportEndpoints.getAll}");

      final response = await apiClient.get(ReportEndpoints.getAll);

      print("API স্ট্যাটাস কোড: ${response.statusCode}");
      print("API রেসপন্স (raw): ${response.data}");

      // response চেক করা
      if (response.data == null) {
        throw Exception("API থেকে কোনো ডাটা আসেনি (response.data null)");
      }

      final data = response.data as Map<String, dynamic>?;
      if (data == null) {
        throw Exception("response.data ম্যাপ নয়");
      }

      final list = data['data'];
      if (list == null) {
        throw Exception("'data' ফিল্ড পাওয়া যায়নি");
      }
      if (list is! List) {
        throw Exception("'data' ফিল্ড লিস্ট নয় → ${list.runtimeType}");
      }

      print("API থেকে ${list.length} টি আইটেম পাওয়া গেছে");
      return list.map((e) => ReportModel.fromJson(e as Map<String, dynamic>)).toList();

      //return list.map((e) => ReportModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, stackTrace) {
      print("API কল ফেইল করেছে:");
      print("Error: $e");
      print("Stack trace: $stackTrace");

      rethrow; // ← controller-এ catch করতে পারে
    }
  }
}
