import 'package:pers/src/models/emergency_contact.dart';

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

List<EmergencyContact> getEmergencyContacts() {
  return _emergencyContacts;
}

void addEmergencyContacts(EmergencyContact contact) {
  _emergencyContacts.add(contact);
}
