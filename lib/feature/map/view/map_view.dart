import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreenView extends StatelessWidget {
  const MapScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map View"), elevation: 0),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(23.777176, 90.399452), // Dhaka
          initialZoom: 13,
        ),
        children: [

          MarkerLayer(
            markers: [
              Marker(
                point: const LatLng(23.777176, 90.399452),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
