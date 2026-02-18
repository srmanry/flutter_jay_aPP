abstract class ReportRepository {
  Future<bool> createReport({
    required String type,
    required String description,
    required double latitude,
    required double longitude,
  });
}
