import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class IncidentReport {
  final String? incident_type;
  final String? patient_name;
  final String? sex;
  final String? age;
  final String? description;
  final String? location;
  final List<XFile>? incident_images;

  IncidentReport({
    this.incident_type,
    this.patient_name,
    this.sex,
    this.age,
    this.description,
    this.location,
    this.incident_images,
  });

  IncidentReport copyWith({
    String? incident_type,
    String? patient_name,
    String? sex,
    String? age,
    String? description,
    String? location,
    List<XFile>? incident_images,
  }) {
    return IncidentReport(
      incident_type: incident_type ?? this.incident_type,
      patient_name: patient_name ?? this.patient_name,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      description: description ?? this.description,
      location: location ?? this.location,
      incident_images: incident_images ?? this.incident_images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'incident_type': incident_type,
      'patient_name': patient_name,
      'sex': sex,
      'age': age,
      'description': description,
      'location': location,
    };
  }

  factory IncidentReport.fromMap(Map<String, dynamic> map) {
    return IncidentReport(
      incident_type: map['incident_type'],
      patient_name: map['patient_name'],
      sex: map['sex'],
      age: map['age'],
      description: map['description'],
      location: map['location'],
      incident_images: map['incident_images'] != null
          ? List<XFile>.from(map['incident_images']?.map((x) => XFile(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IncidentReport.fromJson(String source) =>
      IncidentReport.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IncidentReport(incident_type: $incident_type, patient_name: $patient_name, sex: $sex, age: $age, description: $description, location: $location, incident_images: $incident_images)';
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
        other.location == location &&
        listEquals(other.incident_images, incident_images);
  }

  @override
  int get hashCode {
    return incident_type.hashCode ^
        patient_name.hashCode ^
        sex.hashCode ^
        age.hashCode ^
        description.hashCode ^
        location.hashCode ^
        incident_images.hashCode;
  }
}
