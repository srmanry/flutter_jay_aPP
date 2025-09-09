import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:spotem/core/common/common_text.dart';
import 'package:spotem/core/util/app_colors.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isPermissionGranted = false.obs;


  Future<void> requestLocationPermission(BuildContext context) async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      isPermissionGranted.value = true;
      await _getCurrentLocation();
    } else if (status.isDenied) {
      bool? userChoice = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: SizedBox(


          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on,size: 80,color: AppColors.appColor,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: appName,
              ),
              
              Text("Would like to access your location",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
              const Text(
                  "To straw real time emergency activity in your area",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),

              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Don't allow",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontSize: 16),),
                ),
                SizedBox(width: 20,),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child:  Text("Allow",style: TextStyle(fontSize: 16,color: AppColors.appColor,fontWeight: FontWeight.w700),),
                ),
              ],)
            ],
          ),
          )
      ));

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

  ///  Location data fetch
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

    debugPrint(" Location: ${latitude.value}, ${longitude.value}");
  }
}
