class ReportResponse {
  bool success;
  String message;
  ReportData data;

  ReportResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) => ReportResponse(
    success: json['success'],
    message: json['message'],
    data: ReportData.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

class ReportData {
  String user;
  String type;
  Location location;
  String title;
  String description;
  String id;
  DateTime createdAt;
  int v;

  ReportData({
    required this.user,
    required this.type,
    required this.location,
    required this.title,
    required this.description,
    required this.id,
    required this.createdAt,
    required this.v,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) => ReportData(
    user: json['user'],
    type: json['type'],
    location: Location.fromJson(json['location']),
    title: json['title'],
    description: json['description'],
    id: json['_id'],
    createdAt: DateTime.parse(json['createdAt']),
    v: json['__v'],
  );

  Map<String, dynamic> toJson() => {
    'user': user,
    'type': type,
    'location': location.toJson(),
    'title': title,
    'description': description,
    '_id': id,
    'createdAt': createdAt.toIso8601String(),
    '__v': v,
  };
}

class Location {
  String type;
  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json['type'],
    coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': coordinates,
  };
}
