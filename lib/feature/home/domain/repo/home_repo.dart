import 'package:spotem/feature/home/data/model/reports_model.dart';

abstract class HomeRepo {
  Future<List<ReportModel>> getReports();
}
