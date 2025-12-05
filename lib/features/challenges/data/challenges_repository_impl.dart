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
              .map((teamJson) => ChallengeOverviewModel.fromJson(
                  teamJson as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(
              data['message'] ?? 'Failed to fetch challenges overview');
        }
      } else {
        throw Exception(
            'Failed to fetch challenges overview: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching challenges overview: $e');
    }
  }

  @override
  Future<CreateChallengeResponse> createChallenge(
      CreateChallengeRequest request) async {
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
              .map((teamJson) =>
                  UserTeamModel.fromJson(teamJson as Map<String, dynamic>))
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
    print(
        '🔍 DEBUG: Starting getAvailableMatches() - Fetching from new challenge matches API with pagination support');

    List<MatchModel> allMatches = [];

    try {
      // Start with page 1
      int currentPage = 1;
      bool hasMorePages = true;

      while (hasMorePages) {
        final url =
            'https://pre-montada.gostcode.com/public/api/all-challange-Matches?page=$currentPage';
        print('🔍 DEBUG: Fetching page $currentPage from: $url');

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Utils.token}',
          },
        ).timeout(const Duration(seconds: 10));

        print(
            '🔍 DEBUG: Response status: ${response.statusCode} for page $currentPage');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          print(
              '🔍 DEBUG: Response has status: ${data['status']} for page $currentPage');

          if (data['status'] == true && data['data'] != null) {
            final matchesData = data['data']['matches'] as List<dynamic>? ?? [];
            print(
                '🔍 DEBUG: Found ${matchesData.length} matches in page $currentPage');

            if (matchesData.isNotEmpty) {
              print(
                  '🔍 DEBUG: Processing ${matchesData.length} matches from page $currentPage...');
              try {
                final matches = matchesData
                    .map((matchJson) =>
                        MatchModel.fromJson(matchJson as Map<String, dynamic>))
                    .toList();

                // Add matches from this page to the total list
                allMatches.addAll(matches);
                print(
                    '🔍 DEBUG: Added ${matches.length} matches from page $currentPage. Total so far: ${allMatches.length}');
              } catch (parseError) {
                print(
                    '🔍 DEBUG: Parse error on page $currentPage: $parseError');
                // Continue to next page even if parsing fails for some matches
              }
            }

            // Check pagination info
            final pagination =
                data['pagination'] as Map<String, dynamic>? ?? {};
            final totalPages = pagination['total_pages'] as int? ?? 1;
            final nextPageUrl = pagination['next_page_url'];

            print(
                '🔍 DEBUG: Pagination info - Current page: $currentPage, Total pages: $totalPages, Next page URL: $nextPageUrl');

            if (currentPage >= totalPages || nextPageUrl == null) {
              hasMorePages = false;
              print('🔍 DEBUG: No more pages to fetch');
            } else {
              currentPage++;
              print('🔍 DEBUG: Moving to next page: $currentPage');
            }
          } else {
            print(
                '🔍 DEBUG: Response status is not true or data is null for page $currentPage. Status: ${data['status']}, Data: ${data['data']}');
            hasMorePages = false;
          }
        } else {
          print(
              '🔍 DEBUG: HTTP status code is not 200 for page $currentPage: ${response.statusCode}');
          print('🔍 DEBUG: Error response: ${response.body}');
          hasMorePages = false;
        }
      }

      // Filter out reserved matches from all collected matches
      final availableMatches =
          allMatches.where((match) => match.status == 0).toList();

      print(
          '🔍 DEBUG: After filtering reserved matches, ${availableMatches.length} available matches remain out of ${allMatches.length} total');

      // Debug: Print each match's details
      for (final match in availableMatches) {
        print(
            '🔍 DEBUG: Match ID: ${match.id}, Playground: ${match.details}, Date: ${match.date}, Time: ${match.startTime}, Amount: ${match.amount}');
      }

      return availableMatches;
    } catch (e) {
      print('🔍 DEBUG: Error fetching matches: $e');
      throw Exception('Error fetching matches: $e');
    }
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

  @override
  Future<void> withdrawTeamMatch(int teamId, int matchId) async {
    final url = '${ConstKeys.baseUrl}/challenge/withdraw-team-match';
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Utils.token}',
    };
    final body = jsonEncode({
      'team_id': teamId,
      'match_id': matchId,
    });

    print('📡 API DEBUG: Withdrawing Team from Match');
    print('📡 API DEBUG: URL: $url');
    print('📡 API DEBUG: Body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('📡 API DEBUG: Response Status: ${response.statusCode}');
      print('📡 API DEBUG: Response Body: ${response.body}');

      if (response.statusCode >= 400) {
        throw Exception(
            'Failed to withdraw team from match: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      if (data['status'] != true) {
        throw Exception(
            data['message'] ?? 'Failed to withdraw team from match');
      }
    } catch (e) {
      print('📡 API DEBUG: Error withdrawing team: $e');
      rethrow;
    }
  }
}
