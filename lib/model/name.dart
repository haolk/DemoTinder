class Name {
  String title;
  String first;
  String last;

  Name({this.title, this.first, this.last});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(title: json['title'], first: json['first'], last: json['last']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'first': first, 'last': last};
  }
}
