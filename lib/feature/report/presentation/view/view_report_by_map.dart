import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewReportByMap extends StatefulWidget {
  const ViewReportByMap({super.key});

  @override
  State<ViewReportByMap> createState() => _ViewReportByMapState();
}

class _ViewReportByMapState extends State<ViewReportByMap> {
  late GoogleMapController _mapController;

  final LatLng userLocation = const LatLng(23.8103, 90.4125);
  final LatLng reportLocation = const LatLng(23.8200, 90.4250);

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  BitmapDescriptor? userIcon;

  @override
  void initState() {
    super.initState();
    _loadUserIcon();
  }

  /// Load and resize asset image for marker
  Future<BitmapDescriptor> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List bytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<void> _loadUserIcon() async {
    userIcon = await _getBytesFromAsset('assets/icons/polic.png', 80); // width 80 px
    _setupDemoData();
  }

  void _setupDemoData() {
    markers.clear();
    polylines.clear();

    markers.addAll({
      Marker(
        markerId: const MarkerId("user"),
        position: userLocation,
        icon: userIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Your Location (A)"),
      ),
      Marker(
        markerId: const MarkerId("report"),
        position: reportLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: "Report Location (B)"),
      ),
    });

    polylines.add(Polyline(polylineId: const PolylineId("route"), points: [userLocation, reportLocation], width: 5, color: Colors.blue));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: userLocation, zoom: 13),
        markers: markers,
        polylines: polylines,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
