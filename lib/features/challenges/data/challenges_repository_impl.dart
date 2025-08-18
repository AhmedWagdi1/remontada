import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/key.dart';
import '../../../core/utils/utils.dart';
import '../domain/model/challenge_overview_model.dart';
import '../domain/model/create_challenge_request.dart';
import '../domain/model/create_challenge_response.dart';
import '../domain/model/user_team_model.dart';
import '../domain/model/match_model.dart';
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

  @override
  Future<CreateChallengeResponse> createChallenge(CreateChallengeRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${ConstKeys.baseUrl}/challenge/book-match'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
        body: jsonEncode(request.toJson()),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return CreateChallengeResponse.fromJson(data);
    } catch (e) {
      throw Exception('Error creating challenge: $e');
    }
  }

  @override
  Future<List<UserTeamModel>> getUserTeams() async {
    try {
      final response = await http.get(
        Uri.parse('${ConstKeys.baseUrl}/team/user-teams'),
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
              .map((teamJson) => UserTeamModel.fromJson(teamJson as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch user teams');
        }
      } else {
        throw Exception('Failed to fetch user teams: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user teams: $e');
    }
  }

  @override
  Future<List<MatchModel>> getAvailableMatches() async {
    // Try multiple endpoints to get available matches
    final endpoints = [
      '/home',
      '/group-matches',
      '/matches',
    ];

    for (final endpoint in endpoints) {
      try {
        final response = await http.get(
          Uri.parse('${ConstKeys.baseUrl}$endpoint'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Utils.token}',
          },
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          
          if (data['status'] == true && data['data'] != null) {
            List<dynamic> matchesData = [];
            
            // Handle different response structures
            if (endpoint == '/home') {
              final homeData = data['data'] as Map<String, dynamic>;
              matchesData = homeData['matches'] as List<dynamic>? ?? [];
            } else if (endpoint == '/group-matches') {
              final groupData = data['data'] as Map<String, dynamic>;
              matchesData = groupData['matches'] as List<dynamic>? ?? [];
            } else {
              // Direct matches endpoint
              if (data['data'] is List) {
                matchesData = data['data'] as List<dynamic>;
              } else {
                matchesData = [];
              }
            }
            
            // If we found matches, return them
            if (matchesData.isNotEmpty) {
              try {
                final matches = matchesData
                    .map((matchJson) => MatchModel.fromJson(matchJson as Map<String, dynamic>))
                    .toList();
                
                // Filter out invalid matches
                final validMatches = matches.where((match) => 
                  match.id > 0 && 
                  match.date.isNotEmpty && 
                  match.startTime.isNotEmpty
                ).toList();
                
                if (validMatches.isNotEmpty) {
                  return validMatches;
                }
              } catch (parseError) {
                // If parsing fails, continue to next endpoint
                continue;
              }
            }
          }
        }
      } catch (e) {
        // Continue to next endpoint if this one fails
        continue;
      }
    }
    
    // If all endpoints fail, throw a generic error
    throw Exception('No matches available at the moment. Please check back later or contact support if the issue persists.');
  }
}
