class ReportCoordinate {
  final double latitude;
  final double longitude;
  final String type;
  final String title;
  final String description;
  final DateTime? createdAt;

  const ReportCoordinate({
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.title,
    required this.description,
    this.createdAt,
  });
}

