class CreateChallengeRequest {
  final int teamId;
  final int matchId;
  final bool isCompetitive;
  final List<int>? players;

  CreateChallengeRequest({
    required this.teamId,
    required this.matchId,
    required this.isCompetitive,
    this.players,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'team_id': teamId,
      'match_id': matchId,
      'is_competitive': isCompetitive,
    };
    
    if (players != null && players!.isNotEmpty) {
      json['players'] = players!;
    }
    
    return json;
  }
}
