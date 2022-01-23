import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pers/src/models/emergency_contact.dart';
import 'package:pers/src/models/locations.dart';

List<EmergencyContact> _emergencyContacts = [
  EmergencyContact(
    contact_name: 'Guy Dunn',
    contact_number: '+63 898 555 9138',
    contact_image: 'assets/images/mock_images/1.png',
  ),
  EmergencyContact(
    contact_name: 'Carl Gill',
    contact_number: '+63 917 467 8856',
    contact_image: 'assets/images/mock_images/2.png',
  ),
  EmergencyContact(
    contact_name: 'Anna Boyd',
    contact_number: '+63 897 163 7011',
    contact_image: 'assets/images/mock_images/5.png',
  ),
  EmergencyContact(
    contact_name: 'Camille Flores',
    contact_number: '+63 918 778 5738',
    contact_image: 'assets/images/mock_images/6.png',
  ),
  EmergencyContact(
    contact_name: 'Bryan Flowers',
    contact_number: '+63 896 128 4499',
    contact_image: 'assets/images/mock_images/2.png',
  ),
  EmergencyContact(
    contact_name: 'Ivan Johnston',
    contact_number: '+63 817 492 9909',
    contact_image: 'assets/images/mock_images/4.png',
  ),
  EmergencyContact(
    contact_name: 'Kim Ruiz',
    contact_number: '+63 897 459 1746',
    contact_image: 'assets/images/mock_images/1.png',
  ),
  EmergencyContact(
    contact_name: 'Ruben Lee',
    contact_number: '+63 813 434 6680',
    contact_image: 'assets/images/mock_images/5.png',
  ),
  EmergencyContact(
    contact_name: 'Zachary Murphy',
    contact_number: '+63 909 978 1662',
    contact_image: 'assets/images/mock_images/6.png',
  ),
  EmergencyContact(
    contact_name: 'Shelia Mullins',
    contact_number: '+63 817 373 5449',
    contact_image: 'assets/images/mock_images/3.png',
  ),
];

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

List<EmergencyContact> getEmergencyContacts() {
  return _emergencyContacts;
}

List<LocationInfo> getLocations() {
  return _locations;
}

void addEmergencyContacts(EmergencyContact contact) {
  _emergencyContacts.add(contact);
}

void editEmergencyContact(EmergencyContact contact, int index) {
  _emergencyContacts[index] = contact;
}
