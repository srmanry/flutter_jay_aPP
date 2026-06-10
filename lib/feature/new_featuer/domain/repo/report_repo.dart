import '../../../home/data/model/reports_model.dart';

abstract class ReportRepo {
  Future<List<ReportModel>> getReports();

  Future<ReportModel> createReport({required String title, required String type, required String description, required double latitude, required double longitude});
}
