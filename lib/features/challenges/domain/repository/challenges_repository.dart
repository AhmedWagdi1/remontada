import 'package:http/http.dart' as http;

import '../model/challenge_overview_model.dart';
import '../model/create_challenge_request.dart';
import '../model/create_challenge_response.dart';
import '../model/user_team_model.dart';
import '../model/match_model.dart';
import '../request/create_match_request.dart';

abstract class ChallengesRepository {
  Future<List<ChallengeOverviewModel>> getChallengesOverview();
  Future<CreateChallengeResponse> createChallenge(
      CreateChallengeRequest request);
  Future<List<UserTeamModel>> getUserTeams();
  Future<List<MatchModel>> getAvailableMatches();
  Future<http.Response> createMatch(CreateMatchRequest request);
}
