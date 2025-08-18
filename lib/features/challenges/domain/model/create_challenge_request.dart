class CreateChallengeRequest {
  final int teamId;
  final int matchId;
  final bool isCompetitive;

  CreateChallengeRequest({
    required this.teamId,
    required this.matchId,
    required this.isCompetitive,
  });

  Map<String, dynamic> toJson() {
    return {
      'team_id': teamId,
      'match_id': matchId,
      'is_competitive': isCompetitive,
    };
  }
}

