import '../entities/report_coordinate.dart';

abstract class ReportRepository {
  Future<void> createReport({
    required String title,
    required String type,
    required String description,
    required double latitude,
    required double longitude,
  });

  Future<List<ReportCoordinate>> getReportCoordinates();
}
