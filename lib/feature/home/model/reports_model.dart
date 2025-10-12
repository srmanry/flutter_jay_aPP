import 'package:geocoding/geocoding.dart';

class ReportModel {
  final String id;
  final UserModel user;
  final String type;
  final String title;
  final String description;
  final LocationModel location;
  final DateTime createdAt;

  String? placeName;

  ReportModel({
    required this.id,
    required this.user,
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    required this.createdAt,
    this.placeName,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json["_id"],
      user: UserModel.fromJson(json["user"]),
      type: json["type"],
      title: json["title"],
      description: json["description"],
      location: LocationModel.fromJson(json["location"]),
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  // 🔹 Helper to set placeName after reverse geocoding
  void setPlaceName(String name) {
    placeName = name;
  }
}

class UserModel {
  final String id;
  final String name;
  final AvatarModel avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"],
      name: json["name"],
      avatar: AvatarModel.fromJson(json["avatar"]),
    );
  }
}

class AvatarModel {
  final String publicId;
  final String url;

  AvatarModel({
    required this.publicId,
    required this.url,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      publicId: json["public_id"] ?? "",
      url: json["url"] ?? "",
    );
  }
}

class LocationModel {
  final double lat;
  final double lng;

  LocationModel({required this.lat, required this.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: (json['coordinates'][1] as num).toDouble(),
      lng: (json['coordinates'][0] as num).toDouble(),
    );
  }
}
