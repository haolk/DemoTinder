class Location {
  String street;
  String city;
  String state;
  String zip;

  Location({this.street, this.city, this.state, this.zip});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        street: json['street'],
        city: json['city'],
        state: json['state'],
        zip: json['zip']);
  }

  Map<String, dynamic> toJson() {
    return {'street': street, 'city': city, 'state': state, 'zip': zip};
  }
}
