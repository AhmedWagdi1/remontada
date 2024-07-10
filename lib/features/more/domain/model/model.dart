import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Pages {
  int? id;
  String? image;
  String? title;
  String? content;
  Pages({
    this.id,
    this.image,
    this.title,
    this.content,
  });

  factory Pages.fromMap(Map<String, dynamic> map) {
    return Pages(
      id: map['id'] != null ? map['id'] as int : null,
      image: map['image'] != null ? map['image'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
    );
  }

  factory Pages.fromJson(String source) =>
      Pages.fromMap(json.decode(source) as Map<String, dynamic>);
}
