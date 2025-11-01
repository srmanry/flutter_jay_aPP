class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'];

    double lat = 0.0;
    double lng = 0.0;

    if (coords is List && coords.length >= 2) {
      lng = (coords[0] as num?)?.toDouble() ?? 0.0;
      lat = (coords[1] as num?)?.toDouble() ?? 0.0;
    }

    return Location(latitude: lat, longitude: lng);
  }

  @override
  String toString() => 'Location(lat: $latitude, lng: $longitude)';
}
