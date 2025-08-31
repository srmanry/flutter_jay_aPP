class ReportModel {
  final String id;
  final UserModel user;
  final String type;
  final String title;
  final String description;
  final LocationModel location;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.user,
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    required this.createdAt,
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
      publicId: json["public_id"],
      url: json["url"],
    );
  }
}

class LocationModel {
  final String type;
  final List<double> coordinates;

  LocationModel({
    required this.type,
    required this.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json["type"],
      coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    );
  }
}
