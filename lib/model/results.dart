import 'package:tenderapp/model/result.dart';

class Results {
  List<Result> results;

  Results({this.results});

  factory Results.fromJson(Map<String, dynamic> json) {
    print('${json['results']}');
    return Results(
        results: (json['results'] as List)
            .map((value) => Result.fromJson(value))
            .toList());
  }
}
