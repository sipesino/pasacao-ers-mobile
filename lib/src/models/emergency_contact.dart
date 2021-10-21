import 'dart:convert';

class EmergencyContact {
  final String contact_name;
  final String contact_number;
  final String contact_image;

  const EmergencyContact({
    required this.contact_name,
    required this.contact_number,
    required this.contact_image,
  });

  EmergencyContact copyWith({
    String? contact_name,
    String? contact_number,
    String? contact_image,
  }) {
    return EmergencyContact(
      contact_name: contact_name ?? this.contact_name,
      contact_number: contact_number ?? this.contact_number,
      contact_image: contact_image ?? this.contact_image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contact_name': contact_name,
      'contact_number': contact_number,
      'contact_image': contact_image,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      contact_name: map['contact_name'],
      contact_number: map['contact_number'],
      contact_image: map['contact_image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EmergencyContact.fromJson(String source) =>
      EmergencyContact.fromMap(json.decode(source));

  @override
  String toString() =>
      'EmergencyContact(contact_name: $contact_name, contact_number: $contact_number, contact_image: $contact_image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmergencyContact &&
        other.contact_name == contact_name &&
        other.contact_number == contact_number &&
        other.contact_image == contact_image;
  }

  @override
  int get hashCode =>
      contact_name.hashCode ^ contact_number.hashCode ^ contact_image.hashCode;
}
