import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class IncidentReport {
  String? incident_id;
  String? incident_type;
  String? name;
  String? sex;
  String? age;
  String? description;
  List<XFile>? incident_images;
  String? longitude;
  String? latitude;
  String? landmark;
  String? victim_status;
  String? account_id;
  String? permanent_address;
  String? temperature;
  String? pulse_rate;
  String? respiration_rate;
  String? blood_pressure;
  String? address;

  IncidentReport({
    this.incident_id,
    this.incident_type,
    this.name,
    this.sex,
    this.age,
    this.description,
    this.incident_images,
    this.longitude,
    this.latitude,
    this.landmark,
    this.victim_status,
    this.account_id,
    this.permanent_address,
    this.temperature,
    this.pulse_rate,
    this.respiration_rate,
    this.blood_pressure,
    this.address,
  });

  factory IncidentReport.fromMap(Map<String, dynamic> map) {
    return IncidentReport(
      incident_id: map['incident_id'],
      incident_type: map['incident_type'],
      name: map['name'],
      sex: map['sex'],
      age: map['age'],
      description: map['description'],
      longitude: map['longitude'],
      latitude: map['latitude'],
      landmark: map['landmark'],
      victim_status: map['victim_status'],
      account_id: map['account_id'],
      permanent_address: map['permanent_address'],
      temperature: map['temperature'],
      pulse_rate: map['pulse_rate'],
      respiration_rate: map['respiration_rate'],
      blood_pressure: map['blood_pressure'],
      address: map['address'],
    );
  }

  @override
  String toString() {
    return 'IncidentReport(incident_id: $incident_id, incident_type: $incident_type, name: $name, sex: $sex, age: $age, description: $description, incident_images: $incident_images, longitude: $longitude, latitude: $latitude, landmark: $landmark, victim_status: $victim_status, account_id: $account_id, permanent_address: $permanent_address, temperature: $temperature, pulse_rate: $pulse_rate, respiration_rate: $respiration_rate, blood_pressure: $blood_pressure, address: $address)';
  }

  @override
  int get hashCode {
    return incident_id.hashCode ^
        incident_type.hashCode ^
        name.hashCode ^
        sex.hashCode ^
        age.hashCode ^
        description.hashCode ^
        incident_images.hashCode ^
        longitude.hashCode ^
        latitude.hashCode ^
        landmark.hashCode ^
        victim_status.hashCode ^
        account_id.hashCode ^
        permanent_address.hashCode ^
        temperature.hashCode ^
        pulse_rate.hashCode ^
        respiration_rate.hashCode ^
        blood_pressure.hashCode ^
        address.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'incident_id': incident_id,
      'incident_type': incident_type,
      'name': name,
      'sex': sex,
      'age': age,
      'description': description,
      'longitude': longitude,
      'latitude': latitude,
      'landmark': landmark,
      'victim_status': victim_status,
      'account_id': account_id,
      'permanent_address': permanent_address,
      'temperature': temperature,
      'pulse_rate': pulse_rate,
      'respiration_rate': respiration_rate,
      'blood_pressure': blood_pressure,
      'address': address,
    };
  }

  String toJson() => json.encode(toMap());

  factory IncidentReport.fromJson(String source) =>
      IncidentReport.fromMap(json.decode(source));
}
