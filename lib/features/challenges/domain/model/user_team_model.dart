class UserTeamModel {
  final int id;
  final String name;
  final String? logo;
  final String? bio;
  final int areaId;
  final int status;
  final String createdAt;
  final String updatedAt;

  UserTeamModel({
    required this.id,
    required this.name,
    this.logo,
    this.bio,
    required this.areaId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserTeamModel.fromJson(Map<String, dynamic> json) {
    return UserTeamModel(
      id: _parseInt(json['id']),
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
      bio: json['bio'] as String?,
      areaId: _parseInt(json['area_id']),
      status: _parseInt(json['status']),
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is bool) return value ? 1 : 0;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}
