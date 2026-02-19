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

      
      if (response.data == null) {
        throw Exception("API (response.data null)");
      }

      final data = response.data as Map<String, dynamic>?;
      if (data == null) {
        throw Exception("response.data ");
      }

      final list = data['data'];
      if (list == null) {
        throw Exception("'data' Data not found in API response → ${response.data}");
      }
      if (list is! List) {
        throw Exception("'data' ফিল্ড লিস্ট নয় → ${list.runtimeType}");
      }

      print("API থেকে ${list.length} টি আইটেম পাওয়া গেছে");
      return list.map((e) => ReportModel.fromJson(e as Map<String, dynamic>)).toList();

      //return list.map((e) => ReportModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, stackTrace) {
   
      print("Error: $e");
      print("Stack trace: $stackTrace");

      rethrow; 
    }
  }
}
