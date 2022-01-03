import 'dart:convert';

class User {
  final int? id;
  final String? address;
  final String? birthday;
  final String? account_type;
  final String? email;
  final String? first_name;
  final String? sex;
  final String? last_name;
  final String? mobile_no;
  final String? password;
  final String? password_confirmation;

  User({
    this.id,
    this.address,
    this.birthday,
    this.account_type,
    this.email,
    this.first_name,
    this.sex,
    this.last_name,
    this.mobile_no,
    this.password,
    this.password_confirmation,
  });

  User copyWith({
    int? id,
    String? address,
    String? birthday,
    String? account_type,
    String? email,
    String? first_name,
    String? sex,
    String? last_name,
    String? mobile_no,
    String? password,
    String? password_confirmation,
  }) {
    return User(
      id: id ?? this.id,
      address: address ?? this.address,
      birthday: birthday ?? this.birthday,
      account_type: account_type ?? this.account_type,
      email: email ?? this.email,
      first_name: first_name ?? this.first_name,
      sex: sex ?? this.sex,
      last_name: last_name ?? this.last_name,
      mobile_no: mobile_no ?? this.mobile_no,
      password: password ?? this.password,
      password_confirmation:
          password_confirmation ?? this.password_confirmation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'birthday': birthday,
      'account_type': account_type,
      'email': email,
      'first_name': first_name,
      'sex': sex,
      'last_name': last_name,
      'mobile_no': mobile_no,
      'password': password,
      'password_confirmation': password_confirmation,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] : null,
      address: map['address'] != null ? map['address'] : null,
      birthday: map['birthday'] != null ? map['birthday'] : null,
      account_type: map['account_type'] != null ? map['account_type'] : null,
      email: map['email'] != null ? map['email'] : null,
      first_name: map['first_name'] != null ? map['first_name'] : null,
      sex: map['sex'] != null ? map['sex'] : null,
      last_name: map['last_name'] != null ? map['last_name'] : null,
      mobile_no: map['mobile_no'] != null ? map['mobile_no'] : null,
      password: map['password'] != null ? map['password'] : null,
      password_confirmation: map['password_confirmation'] != null
          ? map['password_confirmation']
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, address: $address, birthday: $birthday, account_type: $account_type, email: $email, first_name: $first_name, sex: $sex, last_name: $last_name, mobile_no: $mobile_no, password: $password, password_confirmation: $password_confirmation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.address == address &&
        other.birthday == birthday &&
        other.account_type == account_type &&
        other.email == email &&
        other.first_name == first_name &&
        other.sex == sex &&
        other.last_name == last_name &&
        other.mobile_no == mobile_no &&
        other.password == password &&
        other.password_confirmation == password_confirmation;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        id.hashCode ^
        birthday.hashCode ^
        account_type.hashCode ^
        email.hashCode ^
        first_name.hashCode ^
        sex.hashCode ^
        last_name.hashCode ^
        mobile_no.hashCode ^
        password.hashCode ^
        password_confirmation.hashCode;
  }
}
