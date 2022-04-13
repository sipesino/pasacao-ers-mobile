import 'dart:convert';

class EmergencyContact {
  final String contact_name;
  final String contact_number;

  const EmergencyContact({
    required this.contact_name,
    required this.contact_number,
  });

  EmergencyContact copyWith({
    String? contact_name,
    String? contact_number,
    String? contact_image,
  }) {
    return EmergencyContact(
      contact_name: contact_name ?? this.contact_name,
      contact_number: contact_number ?? this.contact_number,
    );
  }

  static Map<String, dynamic> toMap(EmergencyContact contact) {
    return {
      'contact_name': contact.contact_name,
      'contact_number': contact.contact_number,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      contact_name: map['contact_name'],
      contact_number: map['contact_number'],
    );
  }

  static String encode(List<EmergencyContact> contacts) => json.encode(
        contacts
            .map<Map<String, dynamic>>((music) => EmergencyContact.toMap(music))
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
    );
  }

  @override
  String toString() =>
      'EmergencyContact(contact_name: $contact_name, contact_number: $contact_number)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmergencyContact &&
        other.contact_name == contact_name &&
        other.contact_number == contact_number;
  }

  @override
  int get hashCode => contact_name.hashCode ^ contact_number.hashCode;
}
