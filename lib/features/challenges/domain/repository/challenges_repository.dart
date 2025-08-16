import '../model/challenge_overview_model.dart';

abstract class ChallengesRepository {
  Future<List<ChallengeOverviewModel>> getChallengesOverview();
}
