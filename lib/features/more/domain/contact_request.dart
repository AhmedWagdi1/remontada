import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ContactRequest {
  String? name;
  String? email;
  String? phone;
  String? message;
  ContactRequest({
    this.name,
    this.email,
    this.phone,
    this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
    };
  }

  String toJson() => json.encode(toMap());
}
