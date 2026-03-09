import 'package:spotem/feature/home/data/model/reports_model.dart';

import '../entities/report_coordinate.dart';

abstract class ReportRepository {
  Future<ReportModel> createReport({
    required String title,
    required String type,
    required String description,
    required double latitude,
    required double longitude,
  });

  Future<List<ReportCoordinate>> getReportCoordinates();
}
