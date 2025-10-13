import 'package:spotem/feature/report/model/report_model.dart';

enum AlertType {
  fire("fire"),
  ambulance("ambulance"),
  police("police"),
  ice("ice");

  final String value;
  const AlertType(this.value);

  static AlertType fromString(String value) {
    switch (value) {
      case "fire":
        return AlertType.fire;
      case "ambulance":
        return AlertType.ambulance;
      case "police":
        return AlertType.police;
      case "ice":
        return AlertType.ice;
      default:
        throw ArgumentError("Invalid AlertType: $value");
    }
  }
}

class AlertReport {
  final String id;
  final String title;
  final String description;

  AlertReport({
    required this.id,
    required this.title,
    required this.description,
  });

  factory AlertReport.fromJson(Map<String, dynamic> json) {
    return AlertReport(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
    );
  }
}

class AlertModel {
  final String id;
  final AlertType type;
  final Location location;
  final AlertReport report;
  final bool isRead;
  final DateTime createdAt;

  AlertModel({
    required this.id,
    required this.type,
    required this.location,
    required this.report,
    required this.isRead,
    required this.createdAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['_id'],
      type: AlertType.fromString(json['type']),
      location: Location.fromJson(json['location']),
      report: AlertReport.fromJson(json['report']),
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}