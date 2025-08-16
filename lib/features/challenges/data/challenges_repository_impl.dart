import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/key.dart';
import '../../../core/utils/utils.dart';
import '../domain/model/challenge_overview_model.dart';
import '../domain/repository/challenges_repository.dart';

class ChallengesRepositoryImpl implements ChallengesRepository {
  @override
  Future<List<ChallengeOverviewModel>> getChallengesOverview() async {
    try {
      final response = await http.get(
        Uri.parse('${ConstKeys.baseUrl}/challenge/challenges-overview'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (data['status'] == true) {
          final List<dynamic> teamsData = data['data'] as List<dynamic>;
          return teamsData
              .map((teamJson) => ChallengeOverviewModel.fromJson(teamJson as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch challenges overview');
        }
      } else {
        throw Exception('Failed to fetch challenges overview: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching challenges overview: $e');
    }
  }
}
