import 'package:pers/src/models/emergency_contact.dart';
import 'package:pers/src/models/locations.dart';
import 'package:pers/src/models/user.dart';

List<EmergencyContact> _emergencyContacts = [
  EmergencyContact(
    contact_name: 'Guy Dunn',
    contact_number: '+63 898 555 9138',
  ),
  EmergencyContact(
    contact_name: 'Carl Gill',
    contact_number: '+63 917 467 8856',
  ),
  EmergencyContact(
    contact_name: 'Anna Boyd',
    contact_number: '+63 897 163 7011',
  ),
  EmergencyContact(
    contact_name: 'Camille Flores',
    contact_number: '+63 918 778 5738',
  ),
  EmergencyContact(
    contact_name: 'Bryan Flowers',
    contact_number: '+63 896 128 4499',
  ),
  EmergencyContact(
    contact_name: 'Ivan Johnston',
    contact_number: '+63 817 492 9909',
  ),
  EmergencyContact(
    contact_name: 'Kim Ruiz',
    contact_number: '+63 897 459 1746',
  ),
  EmergencyContact(
    contact_name: 'Ruben Lee',
    contact_number: '+63 813 434 6680',
  ),
  EmergencyContact(
    contact_name: 'Zachary Murphy',
    contact_number: '+63 909 978 1662',
  ),
  EmergencyContact(
    contact_name: 'Shelia Mullins',
    contact_number: '+63 817 373 5449',
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

User? user;
