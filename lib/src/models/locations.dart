import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  final String location_id;
  final String location_name;
  final String location_type;
  final String address;
  final LatLng coordinates;
  final String? incident_id;

  Location({
    required this.location_id,
    required this.location_name,
    required this.location_type,
    required this.address,
    required this.coordinates,
    this.incident_id,
  });
}
