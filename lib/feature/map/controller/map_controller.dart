import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotem/feature/map/service/location_services.dart';

class LocationController extends GetxController {
  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var markers = <Marker>{}.obs;
  GoogleMapController? mapController;

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }


  Future<void> moveCamera() async {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(lat.value, lng.value),
          16, // zoom level
        ),
      );
    }
  }

  Future<void> loadLocation() async {
    final position = await LocationServices().getUserLocation();
    if (position != null) {
      lat.value = position.latitude;
      lng.value = position.longitude;

      // camera automatically move
      await moveCamera();
    }
  }
  Future<void> createReport(
      String title,
      String description,
      String type,
      LatLng position,
      ) async {
    final marker = Marker(
      markerId: MarkerId("${title}_${DateTime.now()}"),
      position: position,
      icon: await _getMarkerIcon(type),
      infoWindow: InfoWindow(
        title: "$title ($type)",
        snippet: description,
      ),
    );

    markers.add(marker);
  }



  Future<BitmapDescriptor> _getMarkerIcon(String type) async {
    switch (type) {
      case "Hospital":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case "Police":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case "Fire":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }


  @override
  void onInit() {
    super.onInit();
    loadLocation();
  }
}
