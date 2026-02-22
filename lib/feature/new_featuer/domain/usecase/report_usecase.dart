import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/home/data/model/reports_model.dart';


class FilterReportsByDistance {

  double _degToRad(double deg) => deg * pi / 180;

  double _distanceInMeters(LatLng p1, LatLng p2) {
    const double R = 6371000;

    final dLat = _degToRad(p2.latitude - p1.latitude);
    final dLng = _degToRad(p2.longitude - p1.longitude);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(p1.latitude)) *
            cos(_degToRad(p2.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  List<ReportModel> call(
      List<ReportModel> reports,
      LatLng userLocation,
      double maxDistance,
      ) {

    return reports.where((report) {
      final reportPos =
          LatLng(report.location.lat, report.location.lng);

      final distance =
          _distanceInMeters(userLocation, reportPos);

      return distance <= maxDistance;
    }).toList();
  }
}