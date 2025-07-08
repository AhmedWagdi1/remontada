import '../../../../core/config/key.dart';

class AuthRequest {
  String? name;
  String? email;
  String? phone;
  String? code;
  int? location_id;
  int? area_id;
  String? token;
  String? fcm_token;

  AuthRequest({
    this.name,
    this.email,
    this.phone,
    this.fcm_token,
    this.token,
    this.location_id,
    this.area_id,
  });

  Map<String, dynamic> register() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'mobile': "${phone}",
      "location_id": location_id,
      "area_id": area_id,

      // 'fcm_token': fcm_token,
    };
  }

  Map<String, dynamic> login() {
    final String mobile = ConstKeys.devEnv
        ? ConstKeys.devLoginPhone
        : phone ?? '';
    return <String, dynamic>{
      // 'fcm_token': fcm_token,
      'mobile': mobile,
      // 'password': password,
    };
  }
}
