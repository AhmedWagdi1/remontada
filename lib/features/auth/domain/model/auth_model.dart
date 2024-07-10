import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  UserModel? user;
  String? token;
  String? type;
  bool? mobileChanged;
  int? code;
  User({
    this.user,
    this.token,
    this.type,
    this.mobileChanged,
    this.code,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      user: map["user"] != null ? UserModel.fromJson(map["user"]) : null,
      token: map['access_token'] != null ? map['access_token'] : null,
      type: map['type'] != null ? map['type'] as String : null,
      mobileChanged:
          map['mobile_changed'] != null ? map['mobile_changed'] as bool : null,
      code: map['code'] != null ? map['code'] as int : null,
    );
  }

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}

class UserModel {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? image;
  bool? notify;
  String? lang;
  bool? banned;
  bool? active;
  String? type;
  String? coaching;
  String? location;
  int? locationId;
  String? city;
  int? cityId;

  String? fcm_token;

  UserModel({
    this.name,
    this.email,
    this.type,
    this.active,
    this.banned,
    this.coaching,
    this.id,
    this.image,
    this.lang,
    this.notify,
    this.phone,
    this.fcm_token,
    this.city,
    this.cityId,
    this.location,
    this.locationId,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json['name'];
    email = json['email'];
    phone = json['mobile'];
    type = json['type'];
    image = json['image'];
    lang = json['lang'];
    notify = json["notify"];
    banned = json["banned"];
    active = json["active"];
    location = json["location"];
    locationId = json["location_id"];
    city = json["area"];
    cityId = json["area_id"];

    coaching = json["coaching"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['type'] = this.type;
    data['notify'] = this.notify;
    data['lang'] = this.lang;
    data['banned'] = this.banned;
    data['active'] = this.active;
    data['coaching'] = this.coaching;
    return data;
  }
}

class Location {
  int? id;
  String? name;
  Location({
    this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Locations {
  List<Location>? locations;
  Locations({
    this.locations,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'locations': locations?.map((x) => x.toMap()).toList(),
    };
  }

  Locations.fromMap(Map<String, dynamic> map) {
    if (map['locations'] != null) {
      locations = <Location>[];
      (map['locations'] as List).forEach((v) {
        locations!.add(Location.fromMap(v));
      });
    }
  }

  String toJson() => json.encode(toMap());

  factory Locations.fromJson(String source) =>
      Locations.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Areas {
  List<Location>? areas;
  Areas({
    this.areas,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cities': areas?.map((x) => x.toMap()).toList(),
    };
  }

  factory Areas.fromMap(Map<String, dynamic> json) {
    return Areas(
      areas: json['cities'] != null
          ? List<Location>.from(
              (json['cities'] as List).map<Location?>(
                (x) => Location.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Areas.fromJson(String source) =>
      Areas.fromMap(json.decode(source) as Map<String, dynamic>);
}
