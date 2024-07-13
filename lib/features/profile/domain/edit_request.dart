// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class EditRequest {
  String? name;
  String? phone;
  String? email;
  int? areaId;
  int? locationId;
  File? image;
  EditRequest({
    this.name,
    this.phone,
    this.email,
    this.areaId,
    this.locationId,
    this.image,
  });

  Future<Map<String, dynamic>> edit() async {
    return <String, dynamic>{
      'name': name,
      'mobile': phone,
      'email': email,
      'area_id': areaId,
      'location_id': locationId,
      if (image != null)
        'image': await MultipartFile.fromFile(image?.path ?? ""),
    };
  }

  String toJson() => json.encode(edit());
}
