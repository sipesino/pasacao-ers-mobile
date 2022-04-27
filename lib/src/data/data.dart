import 'package:pers/src/models/emergency_contact.dart';
import 'package:pers/src/models/locations.dart';
import 'package:pers/src/models/user.dart';

List<LocationInfo> _locations = [
  LocationInfo(
    location_id: 1,
    location_type: 'Police Station',
    address: 'Pasacao, Camarines Sur',
    latitude: '13.5124',
    longitude: '123.04249',
    location_name: 'Pasacao Municipal Police Station',
  ),
  LocationInfo(
    location_id: 2,
    location_type: 'Fire Station',
    address: 'Pasacao, Camarines Sur',
    latitude: '13.5082966305',
    longitude: '123.041959332',
    location_name: 'Pasacao Fire Station',
  ),
  LocationInfo(
    location_id: 3,
    location_type: 'Hospital',
    address: 'Pasacao, Camarines Sur',
    latitude: '13.504323',
    longitude: '123.040576',
    location_name: 'Pasacao Rural Health Unit',
  ),
  LocationInfo(
    location_id: 4,
    location_type: 'Evacuation Center',
    address: 'Pasacao, Camarines Sur',
    latitude: '13.514365889568493',
    longitude: '123.04275664858702',
    location_name: 'Evacuation Center (PCS)',
  ),
];

List<LocationInfo> getLocations() {
  return _locations;
}

User? user;
