import 'package:path/path.dart';

class Profile {
  String sha1;
  String public;
  String birthday;
  String address;
  String phone;
  String email;
  String picture;

  Profile(this.sha1, this.public, this.birthday, this.address, this.phone,this.email,
      this.picture);

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      json['sha1'],
      json['public'],
      json['birthday'],
      json['address'],
      json['phone'],
      json['email'],
      json['picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sha1': sha1,
      'public': public,
      'birthday': birthday,
      'address': address,
      'phone': phone,
      'email':email,
      'picture': picture
    };
  }
}
