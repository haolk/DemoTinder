import 'package:tenderapp/model/location.dart';
import 'package:tenderapp/model/name.dart';

class User {
  String gender;
  Name name;
  Location location;
  String email;
  String username;
  String password;
  String dob;
  String phone;
  String picture;
  String sha1;

  User(
      {this.gender,
      this.name,
      this.location,
      this.email,
      this.username,
      this.password,
      this.dob,
      this.phone,
      this.picture,
      this.sha1});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        gender: json['gender'],
        name: Name.fromJson(json['name']),
        location: Location.fromJson(json['location']),
        email: json['email'],
        username: json['username'],
        password: json['password'],
        dob: json['dob'],
        phone: json['phone'],
        picture: json['picture'],
        sha1: json['sha1']);
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'name': name.toJson(),
      'location': location.toJson(),
      'email': email,
      'username': username,
      'password': password,
      'dob': dob,
      'phone': phone,
      'picture': picture,
      'sha1': sha1
    };
  }
}
