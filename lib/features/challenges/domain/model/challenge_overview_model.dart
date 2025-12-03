class ChallengeOverviewModel {
  final int id;
  final String name;
  final int status;
  final String? logo;
  final int areaId;
  final String? bio;
  final ChallengeStatsModel? generalStats;
  final ChallengeStatsModel? currentMonthStats;

  ChallengeOverviewModel({
    required this.id,
    required this.name,
    required this.status,
    this.logo,
    required this.areaId,
    this.bio,
    this.generalStats,
    this.currentMonthStats,
  });

  factory ChallengeOverviewModel.fromJson(Map<String, dynamic> json) {
    return ChallengeOverviewModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      status: json['status'] as int? ?? 0,
      logo: json['logo_url'] as String?,
      areaId: json['area_id'] as int? ?? 0,
      bio: json['bio'] as String?,
      generalStats: json['general_stats'] != null
          ? ChallengeStatsModel.fromJson(json['general_stats'])
          : null,
      currentMonthStats: json['current_month_stats'] != null
          ? ChallengeStatsModel.fromJson(json['current_month_stats'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'logo_url': logo,
      'area_id': areaId,
      'bio': bio,
      'general_stats': generalStats?.toJson(),
      'current_month_stats': currentMonthStats?.toJson(),
    };
  }
}

class ChallengeStatsModel {
  final int wins;
  final int draws;
  final int losses;
  final int owns;
  final int againsts;
  final int points;
  final String level;
  final int matchCount;

  ChallengeStatsModel({
    required this.wins,
    required this.draws,
    required this.losses,
    required this.owns,
    required this.againsts,
    required this.points,
    required this.level,
    required this.matchCount,
  });

  factory ChallengeStatsModel.fromJson(Map<String, dynamic> json) {
    return ChallengeStatsModel(
      wins: json['wins'] as int? ?? 0,
      draws: json['draws'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      owns: json['owns'] as int? ?? 0,
      againsts: json['againsts'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      level: json['level'] as String? ?? '',
      matchCount: json['match_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'owns': owns,
      'againsts': againsts,
      'points': points,
      'level': level,
      'match_count': matchCount,
    };
  }

  int get played => matchCount;
  int get goalDifference => owns - againsts;
}
