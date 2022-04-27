import 'dart:convert';

class EmergencyContact {
  final String contact_name;
  final String contact_number;
  final int? contact_id;

  EmergencyContact({
    required this.contact_name,
    required this.contact_number,
    this.contact_id,
  });

  EmergencyContact copyWith({
    String? contact_name,
    String? contact_number,
    int? contact_id,
  }) {
    return EmergencyContact(
      contact_name: contact_name ?? this.contact_name,
      contact_number: contact_number ?? this.contact_number,
      contact_id: contact_id ?? this.contact_id,
    );
  }

  static Map<String, dynamic> toMap(EmergencyContact contact) {
    return {
      'contact_name': contact.contact_name,
      'contact_number': contact.contact_number,
      'contact_id': contact.contact_id,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      contact_name: map['contact_name'],
      contact_number: map['contact_number'],
      contact_id: map['contact_id'],
    );
  }

  static String encode(List<EmergencyContact> contacts) => json.encode(
        contacts
            .map<Map<String, dynamic>>(
                (contact) => EmergencyContact.toMap(contact))
            .toList(),
      );

  static List<EmergencyContact> decode(String contacts) =>
      (json.decode(contacts) as List<dynamic>)
          .map<EmergencyContact>((item) => EmergencyContact.fromJson(item))
          .toList();

  factory EmergencyContact.fromJson(Map<String, dynamic> jsonData) {
    return EmergencyContact(
      contact_name: jsonData['contact_name'],
      contact_number: jsonData['contact_number'],
      contact_id: jsonData['contact_id'],
    );
  }

  @override
  String toString() =>
      'EmergencyContact(contact_name: $contact_name, contact_number: $contact_number, contact_id: $contact_id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmergencyContact &&
        other.contact_name == contact_name &&
        other.contact_number == contact_number &&
        other.contact_id == contact_id;
  }

  @override
  int get hashCode =>
      contact_name.hashCode ^ contact_number.hashCode ^ contact_id.hashCode;
}
