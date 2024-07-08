// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../../home/domain/model/home_model.dart';

class MyMatches {
  List<MatchModel>? matches;
  MyMatches({
    this.matches,
  });

  MyMatches.fromMap(Map<String, dynamic> map) {
    if (map["matches"] != null) {
      matches = <MatchModel>[];
      (map["matches"] as List).forEach(
        (m) {
          matches?.add(
            MatchModel.fromMap(m),
          );
        },
      );
    }
  }

  factory MyMatches.fromJson(String source) =>
      MyMatches.fromMap(json.decode(source) as Map<String, dynamic>);
}
