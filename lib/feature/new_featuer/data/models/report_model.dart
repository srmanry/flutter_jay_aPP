


class ReportModel {
  final String title;
  final String type;
  final String description;
  final LocationModel location;

  ReportModel({
    required this.title,
    required this.type,
    required this.description,
    required this.location,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      location: LocationModel.fromJson(json['location'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "type": type,
      "description": description,
      "location": location.toJson(),
    };
  }
}

class LocationModel {
  final String type;
  final List<double> coordinates;

  LocationModel({
    required this.type,
    required this.coordinates,
  });

  // ✅ getter
  double get longitude => coordinates[0];
  double get latitude => coordinates[1];

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] ?? [0.0, 0.0];
    return LocationModel(
      type: json['type'] ?? '',
      coordinates: [
        (coords[0] as num).toDouble(),
        (coords[1] as num).toDouble(),
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "coordinates": coordinates,
    };
  }
}
