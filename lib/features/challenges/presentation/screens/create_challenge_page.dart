import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/config/key.dart';

import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import '../../domain/model/create_challenge_request.dart';
import '../../domain/model/user_team_model.dart';
import '../../domain/model/match_model.dart';
import '../../data/challenges_repository_impl.dart';

class CreateChallengePage extends StatefulWidget {
  const CreateChallengePage({super.key});

  @override
  State<CreateChallengePage> createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isCompetitive = true;
  bool _isLoading = false;
  bool _isLoadingTeams = true;
  bool _isLoadingMatches = true;
  UserTeamModel? _selectedTeam;
  MatchModel? _selectedMatch;
  List<UserTeamModel> _userTeams = [];
  List<MatchModel> _availableMatches = [];
  String? _teamsError;
  String? _matchesError;

  @override
  void initState() {
    super.initState();
    _fetchUserTeams();
    _fetchAvailableMatches();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchUserTeams() async {
    try {
      final repository = ChallengesRepositoryImpl();
      final teams = await repository.getUserTeams();
      setState(() {
        _userTeams = teams;
        _selectedTeam = teams.isNotEmpty ? teams.first : null;
        _isLoadingTeams = false;
      });
    } catch (e) {
      setState(() {
        _teamsError = e.toString();
        _isLoadingTeams = false;
      });
    }
  }

  Future<void> _fetchAvailableMatches() async {
    try {
      final repository = ChallengesRepositoryImpl();
      final matches = await repository.getAvailableMatches();
      setState(() {
        _availableMatches = matches;
        _selectedMatch = matches.isNotEmpty ? matches.first : null;
        _isLoadingMatches = false;
      });
    } catch (e) {
      setState(() {
        // Extract the actual error message from the exception
        String errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          errorMessage = errorMessage.replaceAll('Exception: ', '');
        }
        
        // Provide more user-friendly error messages
        if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
          errorMessage = 'Authentication failed. Please log in again.';
        } else if (errorMessage.contains('404') || errorMessage.contains('Not Found')) {
          errorMessage = 'No matches available at the moment.';
        } else if (errorMessage.contains('500') || errorMessage.contains('Internal Server Error')) {
          errorMessage = 'Server error. Please try again later.';
        } else if (errorMessage.contains('Network') || errorMessage.contains('Connection')) {
          errorMessage = 'Network error. Please check your connection and try again.';
        } else if (errorMessage.contains('No matches available')) {
          errorMessage = 'No matches available at the moment. Please check back later.';
        } else if (errorMessage.contains('Failed to parse')) {
          errorMessage = 'Error processing match data. Please try again.';
        }
        
        _matchesError = errorMessage;
        _isLoadingMatches = false;
      });
    }
  }

  Future<void> _createChallenge() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedTeam == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_userTeams.isEmpty 
                ? 'No teams available. Please create a team first.'
                : 'Please select a team'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedMatch == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_availableMatches.isEmpty 
                ? LocaleKeys.challenge_no_matches_available.tr()
                : 'Please select a match'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final request = CreateChallengeRequest(
        teamId: _selectedTeam!.id,
        matchId: _selectedMatch!.id,
        isCompetitive: _isCompetitive,
      );

      final repository = ChallengesRepositoryImpl();
      final response = await repository.createChallenge(request);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.status) {
          // Success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          // Error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating challenge: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          LocaleKeys.challenge_create_challenge.tr(),
          color: darkBlue,
          weight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkBlue),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team Selection
                  CustomText(
                    LocaleKeys.challenge_team_id.tr(),
                    color: darkBlue,
                    weight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 8),
                  if (_isLoadingTeams)
                    const Center(child: CircularProgressIndicator())
                  else if (_teamsError != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        _teamsError!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    )
                  else if (_userTeams.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Text(
                        'No teams available. Please create a team first.',
                        style: TextStyle(color: Colors.orange.shade700),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<UserTeamModel>(
                          value: _selectedTeam,
                          isExpanded: true,
                          hint: Text(LocaleKeys.challenge_team_id.tr()),
                          items: _userTeams.map((team) {
                            return DropdownMenuItem<UserTeamModel>(
                              value: team,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.grey.shade300,
                                    backgroundImage: team.logo != null && team.logo!.isNotEmpty
                                        ? NetworkImage('${ConstKeys.baseUrl}/storage/${team.logo}')
                                        : null,
                                    child: team.logo == null || team.logo!.isEmpty
                                        ? const Icon(Icons.sports_soccer, color: Colors.grey)
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      team.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (UserTeamModel? newValue) {
                            setState(() {
                              _selectedTeam = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Match Selection Field
                  CustomText(
                    LocaleKeys.challenge_match_id.tr(),
                    color: darkBlue,
                    weight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 8),
                  if (_isLoadingMatches)
                    const Center(child: CircularProgressIndicator())
                  else if (_matchesError != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${LocaleKeys.challenge_error_loading_matches.tr()}: $_matchesError',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLoadingMatches = true;
                                _matchesError = null;
                              });
                              _fetchAvailableMatches();
                            },
                            child: const Text('Retry'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_availableMatches.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        border: Border.all(color: Colors.orange.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.challenge_no_matches_available.tr(),
                            style: TextStyle(color: Colors.orange.shade700),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLoadingMatches = true;
                                _matchesError = null;
                              });
                              _fetchAvailableMatches();
                            },
                            child: const Text('Refresh'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<MatchModel>(
                        value: _selectedMatch,
                        hint: Text(LocaleKeys.challenge_match_id.tr()),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: _availableMatches.map((match) {
                          return DropdownMenuItem<MatchModel>(
                            value: match,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Match #${match.id} - ${match.date}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${match.startTime} - ${match.endTime} (${match.durationsText})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  'Amount: ${match.amount} SAR',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (MatchModel? newValue) {
                          setState(() {
                            _selectedMatch = newValue;
                          });
                        },
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Competitive Switch
                  Row(
                    children: [
                      CustomText(
                        LocaleKeys.challenge_competitive_match.tr(),
                        color: darkBlue,
                        weight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      const Spacer(),
                      Switch(
                        value: _isCompetitive,
                        onChanged: (value) {
                          setState(() {
                            _isCompetitive = value;
                          });
                        },
                        activeThumbColor: darkBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isCompetitive 
                        ? LocaleKeys.challenge_competitive_description.tr()
                        : LocaleKeys.challenge_friendly_description.tr(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Create Button
                  SizedBox(
                    width: double.infinity,
                    child: ButtonWidget(
                      title: _isLoading 
                          ? LocaleKeys.challenge_creating.tr()
                          : LocaleKeys.challenge_create_challenge.tr(),
                      onTap: _isLoading ? null : _createChallenge,
                      buttonColor: darkBlue,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
