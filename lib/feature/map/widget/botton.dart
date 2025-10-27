/*
Positioned(
bottom: 120,
right: 16,
child: FloatingActionButton(
backgroundColor: Colors.white,
onPressed: () async {
if(locationController.lat.value != 0.0 && locationController.lng.value != 0.0){
locationController.mapController?.animateCamera(
CameraUpdate.newLatLngZoom(
LatLng(locationController.lat.value, locationController.lng.value),
16,
),
);
}
},
child: Icon(Icons.my_location, color: Colors.blue, size: 28),
),
)*/
