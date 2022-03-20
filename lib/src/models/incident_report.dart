import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class IncidentReport {
  final String? incident_type;
  final String? sex;
  final String? age;
  final String? description;
  final List<XFile>? incident_images;
  final String? longitude;
  final String? latitude;
  final String? landmark;
  final String? status;
  final String? account_id;
  final String? name;

  IncidentReport({
    this.incident_type,
    this.sex,
    this.age,
    this.description,
    this.status,
    this.incident_images,
    this.landmark,
    this.account_id,
    this.longitude,
    this.latitude,
    this.name,
  });

  IncidentReport copyWith({
    String? incident_type,
    String? sex,
    String? age,
    String? description,
    String? location,
    String? status,
    String? account_id,
    List<XFile>? incident_images,
    String? longitude,
    String? latitude,
    String? landmark,
    String? name,
  }) {
    return IncidentReport(
      incident_type: incident_type ?? this.incident_type,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      description: description ?? this.description,
      status: status ?? this.status,
      account_id: account_id ?? this.account_id,
      incident_images: incident_images ?? this.incident_images,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      landmark: landmark ?? this.landmark,
      name: landmark ?? this.name,
    );
  }

  @override
  String toString() {
    return 'IncidentReport(incident_type: $incident_type, name: $name, sex: $sex, age: $age, status: $status, description: $description, incident_images: $incident_images, latitude: $latitude, longitude: $longitude, landmark: $landmark, account_id: $account_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IncidentReport &&
        other.incident_type == incident_type &&
        other.name == name &&
        other.sex == sex &&
        other.age == age &&
        other.status == status &&
        other.description == description &&
        listEquals(other.incident_images, incident_images) &&
        other.longitude == longitude &&
        other.latitude == latitude &&
        other.landmark == landmark &&
        other.account_id == account_id;
  }

  @override
  int get hashCode {
    return incident_type.hashCode ^
        name.hashCode ^
        sex.hashCode ^
        age.hashCode ^
        status.hashCode ^
        description.hashCode ^
        incident_images.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        landmark.hashCode ^
        account_id.hashCode;
  }
}
