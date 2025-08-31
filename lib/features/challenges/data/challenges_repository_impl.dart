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
import '../domain/request/create_match_request.dart';

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
      final url = '${ConstKeys.baseUrl}/challenge/book-match';
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Utils.token}',
      };
      final body = jsonEncode(request.toJson());

      print('📡 API DEBUG: Creating Challenge');
      print('📡 API DEBUG: URL: $url');
      print('📡 API DEBUG: Method: POST');
      print('📡 API DEBUG: Headers: $headers');
      print('📡 API DEBUG: Request Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('📡 API DEBUG: Response Status: ${response.statusCode}');
      print('📡 API DEBUG: Response Headers: ${response.headers}');
      print('📡 API DEBUG: Response Body: ${response.body}');

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return CreateChallengeResponse.fromJson(data);
    } catch (e) {
      print('📡 API DEBUG: Error creating challenge: $e');
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
    print('🔍 DEBUG: Starting getAvailableMatches() - Looking for challenge matches');
    
    // Try multiple endpoints to get available matches
    final endpoints = [
      '/home',
      '/group-matches',
      '/matches',
    ];

    for (final endpoint in endpoints) {
      print('🔍 DEBUG: Trying endpoint: $endpoint');
      try {
        final fullUrl = '${ConstKeys.baseUrl}$endpoint';
        print('🔍 DEBUG: Full URL: $fullUrl');
        
        final response = await http.get(
          Uri.parse(fullUrl),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Utils.token}',
          },
        ).timeout(const Duration(seconds: 10));

        print('🔍 DEBUG: Response status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          print('🔍 DEBUG: Response has status: ${data['status']}');
          
          if (data['status'] == true && data['data'] != null) {
            List<dynamic> matchesData = [];
            
            // Handle different response structures
            if (endpoint == '/home') {
              final homeData = data['data'] as Map<String, dynamic>;
              matchesData = homeData['matches'] as List<dynamic>? ?? [];
              print('🔍 DEBUG: Home endpoint - found ${matchesData.length} matches in data.matches');
            } else if (endpoint == '/group-matches') {
              final groupData = data['data'] as Map<String, dynamic>;
              matchesData = groupData['matches'] as List<dynamic>? ?? [];
              print('🔍 DEBUG: Group-matches endpoint - found ${matchesData.length} matches in data.matches');
            } else {
              // Direct matches endpoint
              if (data['data'] is List) {
                matchesData = data['data'] as List<dynamic>;
                print('🔍 DEBUG: Matches endpoint - found ${matchesData.length} direct matches');
              } else {
                matchesData = [];
                print('🔍 DEBUG: Matches endpoint - data is not a list, it\'s: ${data['data'].runtimeType}');
              }
            }
            
            // If we found matches, return them
            if (matchesData.isNotEmpty) {
              print('🔍 DEBUG: Processing ${matchesData.length} matches...');
              try {
                final matches = matchesData
                    .map((matchJson) => MatchModel.fromJson(matchJson as Map<String, dynamic>))
                    .toList();
                
                print('🔍 DEBUG: Successfully parsed ${matches.length} matches');
                
                // Filter out invalid matches
                final validMatches = matches.where((match) => 
                  match.id > 0 && 
                  match.date.isNotEmpty && 
                  match.startTime.isNotEmpty
                ).toList();
                
                print('🔍 DEBUG: After validation, ${validMatches.length} valid matches remain');
                
                // Debug: Print all match types
                final matchTypes = validMatches.map((m) => m.type).toSet();
                print('🔍 DEBUG: Available match types: $matchTypes');
                
                // Debug: Print each match's details
                for (final match in validMatches) {
                  print('🔍 DEBUG: Match ID: ${match.id}, Type: "${match.type}", Date: ${match.date}, Time: ${match.startTime}');
                }
                
                if (validMatches.isNotEmpty) {
                  // For group-matches endpoint, treat all matches as challenges
                  // since this endpoint specifically returns challenge matches
                  if (endpoint == '/group-matches') {
                    print('🔍 DEBUG: Group-matches endpoint - treating all matches as challenges');
                    return validMatches;
                  }
                  
                  print('🔍 DEBUG: Returning ${validMatches.length} matches from endpoint: $endpoint');
                  return validMatches;
                } else {
                  print('🔍 DEBUG: No valid matches after filtering - all matches failed validation');
                }
              } catch (parseError) {
                print('🔍 DEBUG: Parse error: $parseError');
                // If parsing fails, continue to next endpoint
                continue;
              }
            } else {
              print('🔍 DEBUG: No matches data found in response from $endpoint');
            }
          } else {
            print('🔍 DEBUG: Response status is not true or data is null. Status: ${data['status']}, Data: ${data['data']}');
          }
        } else {
          print('🔍 DEBUG: HTTP status code is not 200: ${response.statusCode}');
          print('🔍 DEBUG: Error response: ${response.body}');
        }
      } catch (e) {
        print('🔍 DEBUG: Error with endpoint $endpoint: $e');
        // Continue to next endpoint if this one fails
        continue;
      }
    }
    
    print('🔍 DEBUG: All endpoints failed, throwing exception');
    // If all endpoints fail, throw a generic error
    throw Exception('No matches available at the moment. Please check back later or contact support if the issue persists.');
  }

  @override
  Future<http.Response> createMatch(CreateMatchRequest request) async {
    final response = await http.post(
      Uri.parse('${ConstKeys.baseUrl}/matches'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Utils.token}',
      },
      body: jsonEncode(request.toMap()),
    );
    return response;
  }
}
