import 'package:tenderapp/model/user.dart';

class Result {
  User user;
  String seed;
  String version;

  Result({this.user, this.seed, this.version});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
        user: User.fromJson(json['user']),
        seed: json['seed'],
        version: json['version']);
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'seed': seed,
      'version': version
    };
  }
}
