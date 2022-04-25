import 'dart:convert';

class LocationInfo {
  final int? location_id;
  final String? location_name;
  final String? location_type;
  final String? address;
  final String? longitude;
  final String? latitude;

  LocationInfo({
    this.location_id,
    this.location_name,
    this.location_type,
    this.address,
    this.longitude,
    this.latitude,
  });

  LocationInfo copyWith({
    int? location_id,
    String? location_name,
    String? location_type,
    String? address,
    String? longitude,
    String? latitude,
  }) {
    return LocationInfo(
      location_id: location_id ?? this.location_id,
      location_name: location_name ?? this.location_name,
      location_type: location_type ?? this.location_type,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: latitude ?? this.longitude,
    );
  }

  ///this method will prevent the override of toString
  String locationAsString() {
    return '#${this.location_name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(LocationInfo model) {
    return this.location_name == model.location_name;
  }

  Map<String, dynamic> toMap() {
    return {
      'location_id': location_id,
      'location_name': location_name,
      'location_type': location_type,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory LocationInfo.fromMap(Map<String, dynamic> map) {
    return LocationInfo(
      location_id: map['location_id'] ?? '',
      location_name: map['location_name'] ?? '',
      location_type: map['location_type'] ?? '',
      address: map['address'] ?? '',
      longitude: map['longitude'],
      latitude: map['latitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationInfo.fromJson(String source) =>
      LocationInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return location_name!;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationInfo &&
        other.location_id == location_id &&
        other.location_name == location_name &&
        other.location_type == location_type &&
        other.address == address &&
        other.longitude == longitude &&
        other.latitude == latitude;
  }

  @override
  int get hashCode {
    return location_id.hashCode ^
        location_name.hashCode ^
        location_type.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
