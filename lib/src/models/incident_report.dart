import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class IncidentReport {
  final String? incident_type;
  final String? patient_name;
  final String? sex;
  final String? age;
  final String? description;
  final List<XFile>? incident_images;
  final String? address;
  final String? landmark;

  IncidentReport({
    this.incident_type,
    this.patient_name,
    this.sex,
    this.age,
    this.description,
    this.incident_images,
    this.address,
    this.landmark,
  });

  IncidentReport copyWith({
    String? incident_type,
    String? patient_name,
    String? sex,
    String? age,
    String? description,
    String? location,
    List<XFile>? incident_images,
    String? address,
    String? landmark,
  }) {
    return IncidentReport(
      incident_type: incident_type ?? this.incident_type,
      patient_name: patient_name ?? this.patient_name,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      description: description ?? this.description,
      incident_images: incident_images ?? this.incident_images,
      address: address ?? this.address,
      landmark: landmark ?? this.landmark,
    );
  }

  @override
  String toString() {
    return 'IncidentReport(incident_type: $incident_type, patient_name: $patient_name, sex: $sex, age: $age, description: $description, incident_images: $incident_images, address: $address, landmark: $landmark)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IncidentReport &&
        other.incident_type == incident_type &&
        other.patient_name == patient_name &&
        other.sex == sex &&
        other.age == age &&
        other.description == description &&
        listEquals(other.incident_images, incident_images) &&
        other.address == address &&
        other.landmark == landmark;
  }

  @override
  int get hashCode {
    return incident_type.hashCode ^
        patient_name.hashCode ^
        sex.hashCode ^
        age.hashCode ^
        description.hashCode ^
        incident_images.hashCode ^
        address.hashCode ^
        landmark.hashCode;
  }
}
