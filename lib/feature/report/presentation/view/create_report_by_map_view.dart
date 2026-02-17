/* import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateReportByMapView extends StatelessWidget {
  const CreateReportByMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: const CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 12)),
    );
  }
}
 */

/* import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateReportByMapView extends StatefulWidget {
  const CreateReportByMapView({super.key});

  @override
  State<CreateReportByMapView> createState() => _CreateReportByMapViewState();
}

class _CreateReportByMapViewState extends State<CreateReportByMapView> {
  GoogleMapController? _mapController;
  LatLng _currentCenter = const LatLng(37.7749, -122.4194); // San Francisco default

  // Custom pin icon (আপনি চাইলে asset image ব্যবহার করতে পারেন)
  BitmapDescriptor? _customIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    // Optional: custom red pin icon load করতে পারেন
    // _customIcon = await BitmapDescriptor.fromAssetImage(
    //   const ImageConfiguration(size: Size(48, 48)),
    //   'assets/icons/red_pin.png',
    // );
    // setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Optional: user এর current location-এ move করতে পারেন
    // _goToUserLocation();
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentCenter = position.target;
    });
  }

  Future<void> _confirmLocation() async {
    // এখানে report create করবেন
    final lat = _currentCenter.latitude;
    final lng = _currentCenter.longitude;

    // Example: show dialog or send to backend
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Location"),
        content: Text("Lat: $lat\nLng: $lng\n\nReport create করবেন?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              // TODO: Fire, Police, Ambulance type select করে backend-এ save
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Report created at $lat, $lng")));
              Navigator.pop(context); // screen থেকে বের হয়ে যাবে
            },
            child: const Text("Create Report"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentCenter,
              zoom: 15, // street level
            ),
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: {
              if (_customIcon != null)
                Marker(
                  markerId: const MarkerId('center_pin'),
                  position: _currentCenter,
                  icon: _customIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  anchor: const Offset(0.5, 1.0), // pin-এর নিচের অংশ center-এ
                ),
            },
          ),

          // Center pin overlay (যদি custom icon না load হয় তাহলে default red pin)
          const Center(child: Icon(Icons.location_pin, size: 60, color: Colors.red)),

          // Bottom UI for type selection & confirm
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Select Incident Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTypeButton(Icons.local_fire_department, "Fire", Colors.red),
                      _buildTypeButton(Icons.local_police, "Police", Colors.blue),
                      _buildTypeButton(Icons.medical_services, "Ambulance", Colors.orange),
                    ],
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _confirmLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Create Report Here", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
 */
/* import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateReportByMapView extends StatefulWidget {
  const CreateReportByMapView({super.key});

  @override
  State<CreateReportByMapView> createState() => _CreateReportByMapViewState();
}

class _CreateReportByMapViewState extends State<CreateReportByMapView> {
  Set<Marker> _markers = {};
  String selectedType = "Fire";

  BitmapDescriptor _getMarkerIcon() {
    switch (selectedType) {
      case "Fire":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case "Police":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case "Ambulance":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case "ICE":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.add(Marker(markerId: MarkerId(position.toString()), position: position, icon: _getMarkerIcon()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 GOOGLE MAP
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(23.8103, 90.4125), zoom: 12),
            markers: _markers,
            onTap: _addMarker,
          ),

          /// 🔹 RIGHT SIDE MARKER PANEL
          Positioned(
            right: 16,
            top: 150,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Column(
                children: [
                  _buildTypeButton("ICE", Colors.green),
                  _buildTypeButton("Fire", Colors.red),
                  _buildTypeButton("Police", Colors.blue),
                  _buildTypeButton("Ambulance", Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String type, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Icon(Icons.location_on, color: selectedType == type ? color : color.withOpacity(0.4), size: 32),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateReportByMapView extends StatefulWidget {
  const CreateReportByMapView({super.key});

  @override
  State<CreateReportByMapView> createState() => _CreateReportByMapViewState();
}

class _CreateReportByMapViewState extends State<CreateReportByMapView> {
  Set<Marker> _markers = {};
  String selectedType = "Fire";
  LatLng? selectedPosition;

  BitmapDescriptor _getMarkerIcon() {
    switch (selectedType) {
      case "Fire":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case "Police":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case "Ambulance":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case "ICE":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  void _onMapTap(LatLng position) {
    selectedPosition = position;

    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => _buildReportSheet());
  }

  Widget _buildReportSheet() {
    TextEditingController descriptionController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Create $selectedType Report", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _markers.add(
                    Marker(
                      markerId: MarkerId(DateTime.now().toString()),
                      position: selectedPosition!,
                      icon: _getMarkerIcon(),
                      infoWindow: InfoWindow(title: selectedType, snippet: descriptionController.text),
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text("Submit Report"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Google Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(23.8103, 90.4125), zoom: 12),
            markers: _markers,
            onTap: _onMapTap,
          ),

          /// 🔹 Right Marker Selector
          Positioned(
            right: 16,
            top: 150,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Column(
                children: [
                  _buildTypeButton("ICE", Colors.green),
                  _buildTypeButton("Fire", Colors.red),
                  _buildTypeButton("Police", Colors.blue),
                  _buildTypeButton("Ambulance", Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String type, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Icon(Icons.location_on, color: selectedType == type ? color : color.withOpacity(0.4), size: 32),
      ),
    );
  }
}
