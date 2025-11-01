class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['coordinates'] as  List<dynamic>).map((e) => e as double).toList()[1],
      longitude: (json['coordinates'] as List<dynamic>).map((e) => e as double).toList()[0],
    );
  }
}

