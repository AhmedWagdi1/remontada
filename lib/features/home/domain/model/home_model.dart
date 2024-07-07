import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MatchModel {
  int? id;
  String? playGround;
  String? subscribers;
  String? date;
  String? start;
  String? price;
  MatchModel({
    this.id,
    this.playGround,
    this.subscribers,
    this.date,
    this.start,
    this.price,
  });

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      id: map['id'] != null ? map['id'] as int : null,
      playGround:
          map['playground'] != null ? map['playground'] as String : null,
      subscribers: map['subscribers_count'] != null
          ? map['subscribers_count'] as String
          : null,
      date: map['date'] != null ? map['date'] as String : null,
      start: map['start_time'] != null ? map['start_time'] as String : null,
      price: map['amount'] != null ? map['amount'] as String : null,
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
