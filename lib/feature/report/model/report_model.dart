class Report {
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  //final String type;
  final String placeName; // Add this field

  Report({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    //required this.type,
    this.placeName = "", // Default value
  });
}