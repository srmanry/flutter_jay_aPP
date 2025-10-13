import 'package:flutter/cupertino.dart';
import 'package:spotem/feature/report/model/report_model.dart';

enum AlertType {
  fire("fire"),
  ambulance("ambulance"),
  police("police"),
  ice("ice");

  final String value;
  const AlertType(this.value);

  static AlertType fromString(String value) {
    value = value.toLowerCase();
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
  final AlertReport? report;
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
    debugPrint("Parsing >> $json");
    // debugPrint("Parsed report >> ${AlertReport.fromJson(json['report'])}");
    // debugPrint("Location parsed >> ${Location.fromJson(json['location'])}");
    return AlertModel(
      id: json['_id'],
      type: AlertType.fromString(json['type']),
      location: Location.fromJson(json['location']),
      report: json['report'] == null ? null : AlertReport.fromJson(json['report']),
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  String toString() {
    return 'AlertModel(id: $id, type: $type, location: $location, report: $report, isRead: $isRead, createdAt: $createdAt)';
  }
}