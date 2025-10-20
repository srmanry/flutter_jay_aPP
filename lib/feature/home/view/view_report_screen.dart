import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/home/model/reports_model.dart';

class ViewReportScreen extends StatelessWidget {
  final ReportModel report;
  const ViewReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final LatLng reportLatLng = LatLng(report.location.lat, report.location.lng);
    final Set<Marker> markers = {
      Marker(
        markerId: MarkerId(report.id),
        position: reportLatLng,
        infoWindow: InfoWindow(title: report.title, snippet: report.placeName),
      ),
    };

    return Scaffold(
      appBar: AppBar(

         leading: GestureDetector(onTap: () {Get.back();}, child: Icon(Icons.arrow_back_ios_rounded)),centerTitle: true,
          elevation: 0,
          title: Text(report.title)),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: reportLatLng, zoom: 16),
        markers: markers,
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
