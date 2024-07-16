import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaginationNotificationModel {
  List<NotificationModel>? notification;
  int? page;
  PaginationNotificationModel({this.notification});
  PaginationNotificationModel.fromJson(Map<String, dynamic> json) {
    page = json['pagination']['lastPage'];

    if (json['data']["notifications"] != null) {
      notification = <NotificationModel>[];
      (json['data']["notifications"] as List).forEach((v) {
        notification!.add(NotificationModel.fromMap(v));
      });
    }
  }
}

class NotificationModel {
  String? id;
  NotificationData? data;
  bool? isread;
  String? createdAt;
  NotificationModel({
    this.id,
    this.data,
    this.isread,
    this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] != null ? map['id'] as String : null,
      data: map['data'] != null
          ? NotificationData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
      isread: map['is_read'] != null ? map['is_read'] as bool : null,
      createdAt: map['created_at'] != null ? map['created_at'] as String : null,
    );
  }

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'data': data?.toMap(),
      'isread': isread,
      'createdAt': createdAt,
    };
  }

  String toJson() => json.encode(toMap());
}

class NotificationData {
  String? title;
  String? message;
  String? type;
  NotificationData({
    this.title,
    this.message,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'message': message,
      'type': type,
    };
  }

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      title: map['title'] != null ? map['title'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationData.fromJson(String source) =>
      NotificationData.fromMap(json.decode(source) as Map<String, dynamic>);
}
