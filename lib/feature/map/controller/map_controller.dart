import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:spotem/feature/report/model/report_model.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isPermissionGranted = false.obs;

  // List of reports
  var reports = <Report>[].obs;

  // Request location permission
  Future<void> requestLocationPermission(BuildContext context) async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      isPermissionGranted.value = true;
      await _getCurrentLocation();
    } else if (status.isDenied) {
      bool? userChoice = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: 80, color: Colors.blue),
              SizedBox(height: 15),
              Text(
                "Allow Location Access?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "To track real-time activity in your area",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("Don't allow")),
                  SizedBox(width: 20),
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text("Allow", style: TextStyle(color: Colors.blue))),
                ],
              )
            ],
          ),
        ),
      );

      if (userChoice == true) {
        var newStatus = await Permission.location.request();
        if (newStatus.isGranted) {
          isPermissionGranted.value = true;
          await _getCurrentLocation();
        } else {
          Get.snackbar("Permission Denied", "Location access is required.");
        }
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // Get current user location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", "Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Error", "Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Error", "Location permissions permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude.value = position.latitude;
    longitude.value = position.longitude;
  }

  // Create a new report at current location
  Future<void> createReport(String title, String description) async {
    if (latitude.value == 0.0 && longitude.value == 0.0) {
      await _getCurrentLocation();
    }

    reports.add(
      Report(
        title: title,
        description: description,
        latitude: latitude.value,
        longitude: longitude.value,
      ),
    );
  }
}
