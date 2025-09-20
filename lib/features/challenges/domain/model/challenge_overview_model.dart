class ChallengeOverviewModel {
  final int id;
  final String name;
  final int status;
  final String? logo;
  final int areaId;
  final String? bio;
  final int remuntadaChallengeLeague;
  final int remuntadaEliteCup;
  final int remuntadaSuperCup;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final RankingModel? ranking;

  ChallengeOverviewModel({
    required this.id,
    required this.name,
    required this.status,
    this.logo,
    required this.areaId,
    this.bio,
    required this.remuntadaChallengeLeague,
    required this.remuntadaEliteCup,
    required this.remuntadaSuperCup,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.ranking,
  });

  factory ChallengeOverviewModel.fromJson(Map<String, dynamic> json) {
    return ChallengeOverviewModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      status: json['status'] as int? ?? 0,
      logo: json['logo'] as String?,
      areaId: json['area_id'] as int? ?? 0,
      bio: json['bio'] as String?,
      remuntadaChallengeLeague: json['remuntada_challenge_league'] as int? ?? 0,
      remuntadaEliteCup: json['remuntada_elite_cup'] as int? ?? 0,
      remuntadaSuperCup: json['remuntada_super_cup'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      deletedAt: json['deleted_at'] as String?,
      ranking: json['ranking'] != null
          ? RankingModel.fromJson(json['ranking'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'logo': logo,
      'area_id': areaId,
      'bio': bio,
      'remuntada_challenge_league': remuntadaChallengeLeague,
      'remuntada_elite_cup': remuntadaEliteCup,
      'remuntada_super_cup': remuntadaSuperCup,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'ranking': ranking?.toJson(),
    };
  }
}

class RankingModel {
  final int id;
  final int teamId;
  final int wins;
  final int draws;
  final int losses;
  final int owns;
  final int againsts;
  final String level;
  final int points;
  final int isCompetitive;
  final String createdAt;
  final String updatedAt;

  RankingModel({
    required this.id,
    required this.teamId,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.owns,
    required this.againsts,
    required this.level,
    required this.points,
    required this.isCompetitive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      id: json['id'] as int? ?? 0,
      teamId: json['team_id'] as int? ?? 0,
      wins: json['wins'] as int? ?? 0,
      draws: json['draws'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      owns: json['owns'] as int? ?? 0,
      againsts: json['againsts'] as int? ?? 0,
      level: json['level'] as String? ?? '',
      points: json['points'] as int? ?? 0,
      isCompetitive: json['is_competitive'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_id': teamId,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'owns': owns,
      'againsts': againsts,
      'level': level,
      'points': points,
      'is_competitive': isCompetitive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  int get played => wins + draws + losses;
  int get goalDifference => owns - againsts;
}
