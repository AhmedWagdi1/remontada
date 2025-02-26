import 'dart:convert';

import '../../../../core/utils/utils.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MatchModel {
  int? id;
  bool? isPending;
  String? playGround;
  String? subscribers;
  String? date;
  String? start;
  String? price;
  String? details;
  String? lat;
  String? lng;
  String? constSub;
  String? actualSub;
  int? duration;
  String? amount;
  String? type;
  String? startTime;
  String? endTime;
  String? durations_text;
  bool? flag;
  bool? is_reserved;
  bool? is_owner;
  bool? isCCompleted;

  // bool? validSub;
  MatchModel(
      {this.id,
      this.playGround,
      this.subscribers,
      this.is_reserved,
      this.durations_text,
      this.date,
      this.is_owner,
      this.type,
      this.start,
      this.price,
      this.details,
      this.amount,
      this.lat,
      this.lng,
      this.startTime,
      this.endTime,
      this.constSub,
      this.actualSub,
      this.flag,
      this.duration,
      this.isCCompleted,
      this.isPending
      // this.validSub,
      });

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      constSub: map['subscribers_count'] != null
          ? (map['subscribers_count'] as String).split("/").last
          : null,

      // validSub:  int.parse(constSub) == 20,
      actualSub: map['subscribers_count'] != null
          ? (map['subscribers_count'] as String).split("/").first
          : null,
      is_reserved:
          map['is_reserved'] != null ? (map['is_reserved'] as bool) : null,
      type: map['type'] != null ? (map['type'] as String) : null,
      id: map['id'] != null ? map['id'] as int : null,
      playGround:
          map['playground'] != null ? map['playground'] as String : null,
      durations_text: map['durations_text'] != null
          ? map['durations_text'] as String
          : null,
      subscribers: map['subscribers_count'] != null
          ? map['subscribers_count'] as String
          : null,
      is_owner: map['is_owner'] != null ? map['is_owner'] as bool : null,
      // startTime: map['is_owner'] != null ? map['is_owner'] as bool : null,
      endTime: map['end_time'] != null ? map['end_time'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      amount: map['amount'] != null ? map['amount'] as String : null,
      start: map['start_time'] != null ? map['start_time'] as String : null,
      price: map['amount'] != null ? map['amount'] as String : null,
      details: map['details'] != null ? map['details'] as String : null,
      lat: map['lat'] != null ? map['lat'] as String : null,
      lng: map['lng'] != null ? map['lng'] as String : null,
      flag: map['flagged'] != null ? map['flagged'] as bool : null,
      isPending: map['is_pending'] != null ? map['is_pending'] as bool : null,
      isCCompleted:
          map['is_completed'] != null ? map['is_completed'] as bool : null,
      duration: map['durations'] != null ? map['durations'] as int : null,
    );
  }

  factory MatchModel.fromJson(String source) =>
      MatchModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SliderModel {
  int? id;
  String? image;
  String? link;
  SliderModel({
    this.id,
    this.image,
    this.link,
  });

  factory SliderModel.fromMap(Map<String, dynamic> map) {
    return SliderModel(
      id: map['id'] != null ? map['id'] as int : null,
      image: map['image'] != null ? map['image'] as String : null,
      link: map['link'] != null ? map['link'] as String : null,
    );
  }

  factory SliderModel.fromJson(String source) =>
      SliderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class HomeModel {
  List<SliderModel>? slider;
  List<MatchModel>? match;
  HomeModel({
    this.slider,
    this.match,
  });

  HomeModel.fromMap(Map<String, dynamic> map) {
    if (map['sliders'] != null) {
      slider = <SliderModel>[];
      (map['sliders'] as List).forEach((v) {
        slider!.add(SliderModel.fromMap(v));
      });
    }
    if (map['matches'] != null) {
      match = <MatchModel>[];
      (map['matches'] as List).forEach((v) {
        match!.add(MatchModel.fromMap(v));
      });
    }
  }

  factory HomeModel.fromJson(String source) =>
      HomeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PlayGroundModel {
  int? id;
  String? name;
  bool? isActive;
  PlayGroundLocationModel? location;
  PlayGroundModel({
    this.isActive = false,
    this.id,
    this.name,
    this.location,
  });

  factory PlayGroundModel.fromMap(Map<String, dynamic> map) {
    return PlayGroundModel(
      id: map["id"] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      location: map['location'] != null
          ? PlayGroundLocationModel.fromMap(
              map['location'],
            )
          : null,
    );
  }

  factory PlayGroundModel.fromJson(String source) =>
      PlayGroundModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PlayGroundLocationModel {
  String? lat;
  String? lng;
  String? location;
  PlayGroundLocationModel({
    this.lat,
    this.lng,
    this.location,
  });

  factory PlayGroundLocationModel.fromMap(Map<String, dynamic> map) {
    return PlayGroundLocationModel(
      lat: map['lat'] != null ? map['lat'] as String : null,
      lng: map['lng'] != null ? map['lng'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
    );
  }

  factory PlayGroundLocationModel.fromJson(String source) =>
      PlayGroundLocationModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class PlayGrounds {
  List<PlayGroundModel>? playgrounds;
  PlayGrounds({
    this.playgrounds,
  });

  PlayGrounds.fromMap(Map<String, dynamic> map) {
    if (map["playgrounds"] != null) {
      playgrounds = <PlayGroundModel>[];
      (map["playgrounds"] as List).forEach(
        (e) => playgrounds?.add(
          PlayGroundModel.fromMap(e),
        ),
      );
    }
  }

  factory PlayGrounds.fromJson(String source) =>
      PlayGrounds.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Day {
  String? text;
  String? date;
  bool? isActive;
  Day({
    this.text,
    this.date,
    this.isActive = false,
  });

  factory Day.fromMap(Map<String, dynamic> map) {
    return Day(
      text: map['date_text'] != null ? map['date_text'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
    );
  }

  factory Day.fromJson(String source) =>
      Day.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Days {
  List<Day>? days;

  Days({
    this.days,
  });

  Days.fromMap(Map<String, dynamic> map) {
    if (map["days"] != null) {
      days = <Day>[];
      (map["days"] as List).forEach((e) {
        days?.add(Day.fromMap(e));
      });
    }
  }

  factory Days.fromJson(String source) =>
      Days.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Subscriber {
  int? id;
  String? image;
  String? name;
  String? location;
  String? phone;
  String? city;
  bool? presence;
  Subscriber({
    this.id,
    this.image,
    this.name,
    this.location,
    this.phone,
    this.city,
    this.presence,
  });

  factory Subscriber.fromMap(Map<String, dynamic> map) {
    return Subscriber(
      id: map['id'] != null ? map['id'] as int : null,
      image: map['image'] != null ? map['image'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      presence: map['presence'] != null ? map['presence'] as bool : null,
    );
  }

  factory Subscriber.fromJson(String source) =>
      Subscriber.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SubScribersModel {
  bool? isMymatch;

  List<Subscriber>? subscribers;
  SubScribersModel({
    this.subscribers,
  });

  SubScribersModel.fromMap(Map<String, dynamic> map) {
    if (map["subscribers"] != null) {
      subscribers = <Subscriber>[];
      final List ids = [];
      (map["subscribers"] as List).forEach((element) {
        element["id"] != null ? ids.add(element["id"]) : null;
      });
      isMymatch = ids.contains(Utils.user.user?.id) ? true : false;
      (map["subscribers"] as List).forEach((s) {
        subscribers?.add(Subscriber.fromMap(s));
      });
    }
  }

  factory SubScribersModel.fromJson(String source) =>
      SubScribersModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
