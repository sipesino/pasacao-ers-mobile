import 'dart:convert';

class User {
  User({
    this.account_type,
    this.address,
    this.birthdate,
    this.email,
    this.first_name,
    this.sex,
    this.last_name,
    this.mobile_no,
    this.password,
    this.remember_token,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      address: map['address'],
      birthdate: map['birthdate'],
      email: map['email'],
      first_name: map['first_name'],
      sex: map['sex'],
      last_name: map['last_name'],
      mobile_no: map['mobile_no'],
      password: map['password'],
      remember_token: map['remember_token'],
      account_type: map['account_type'],
    );
  }

  final String? address;
  final String? birthdate;
  final String? account_type;
  final String? email;
  final String? first_name;
  final String? sex;
  final String? last_name;
  final String? mobile_no;
  final String? password;
  final String? remember_token;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.address == address &&
        other.birthdate == birthdate &&
        other.email == email &&
        other.first_name == first_name &&
        other.sex == sex &&
        other.last_name == last_name &&
        other.mobile_no == mobile_no &&
        other.password == password &&
        other.remember_token == remember_token;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        birthdate.hashCode ^
        email.hashCode ^
        first_name.hashCode ^
        sex.hashCode ^
        last_name.hashCode ^
        mobile_no.hashCode ^
        password.hashCode ^
        remember_token.hashCode;
  }

  @override
  String toString() {
    return 'User(address: $address, birthdate: $birthdate, email: $email, first_name: $first_name, sex: $sex, last_name: $last_name, mobile_no: $mobile_no, password: $password, remember_token: $remember_token, account_type: $account_type)';
  }

  User copyWith({
    String? address,
    String? birthdate,
    String? email,
    String? first_name,
    String? sex,
    String? last_name,
    String? mobile_no,
    String? password,
    String? remember_token,
    String? account_type,
  }) {
    return User(
      address: address ?? this.address,
      birthdate: birthdate ?? this.birthdate,
      email: email ?? this.email,
      first_name: first_name ?? this.first_name,
      sex: sex ?? this.sex,
      last_name: last_name ?? this.last_name,
      mobile_no: mobile_no ?? this.mobile_no,
      password: password ?? this.password,
      remember_token: remember_token ?? this.remember_token,
      account_type: account_type ?? this.account_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'birthdate': birthdate,
      'email': email,
      'first_name': first_name,
      'sex': sex,
      'last_name': last_name,
      'mobile_no': mobile_no,
      'password': password,
      'remember_token': remember_token,
      'account_type': account_type,
    };
  }

  String toJson() => json.encode(toMap());
}
