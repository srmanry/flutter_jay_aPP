class Place {
  final String name;
  final double lat;
  final double lng;
  final String type; // "hospital", "fire", "police"

  Place({required this.name, required this.lat, required this.lng, required this.type});
}

final List<Place> places = [
  Place(name: "City Hospital", lat: 23.8103, lng: 90.4125, type: "hospital"),
  Place(name: "Central Fire Station", lat: 23.8110, lng: 90.4200, type: "fire"),
  Place(name: "Downtown Police Station", lat: 23.8150, lng: 90.4250, type: "police"),
];
