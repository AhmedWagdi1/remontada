import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/core/config/key.dart';
import 'package:remontada/core/translations/locale_keys.g.dart';
import 'package:remontada/core/Router/Router.dart';
import '../../domain/model/challenge_request_details_model.dart';

class ChallengeRequestDetailsScreen extends StatefulWidget {
  final int requestId;

  const ChallengeRequestDetailsScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<ChallengeRequestDetailsScreen> createState() =>
      _ChallengeRequestDetailsScreenState();
}

class _ChallengeRequestDetailsScreenState
    extends State<ChallengeRequestDetailsScreen> {
  ChallengeRequestDetails? _challengeDetails;
  bool _isLoading = true;
  bool _isResponding = false;
  List<dynamic> _teamPlayers = [];

  @override
  void initState() {
    super.initState();
    _loadChallengeDetails();
  }

  Future<void> _loadChallengeDetails() async {
    try {
      setState(() => _isLoading = true);

      final response = await http.get(
        Uri.parse('${ConstKeys.baseUrl}/challenge/team-match-invites'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['status'] == true) {
          final List<dynamic> requestsData = data['data'] as List<dynamic>;
          final requestData = requestsData.firstWhere(
            (request) => request['id'] == widget.requestId,
            orElse: () => null,
          );

          if (requestData != null) {
            setState(() {
              _challengeDetails = ChallengeRequestDetails.fromJson(requestData);
              _isLoading = false;
            });
          } else {
            setState(() => _isLoading = false);
            _showError('Challenge request not found');
          }
        } else {
          setState(() => _isLoading = false);
          _showError(
              data['message'] ?? LocaleKeys.challenges_failed_to_load.tr());
        }
      } else {
        setState(() => _isLoading = false);
        _showError(LocaleKeys.challenges_failed_to_load.tr());
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(LocaleKeys.challenges_error_loading.tr(args: [e.toString()]));
    }
  }

  Future<void> _respondToChallenge(String action, {List<int>? playerIds}) async {
    if (_challengeDetails == null) return;

    try {
      setState(() => _isResponding = true);

      final body = {
        'request_id': widget.requestId,
        'action': action,
      };

      if (playerIds != null && playerIds.isNotEmpty) {
        body['players'] = playerIds;
      }

      final response = await http.post(
        Uri.parse('${ConstKeys.baseUrl}/challenge/respond-team-match-request'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['status'] == true) {
        _showSuccess(
            data['message'] ?? LocaleKeys.challenges_response_sent.tr());
        // Navigate back to challenges screen after successful response
        await Future.delayed(
            const Duration(seconds: 1)); // Brief delay to show success message
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.challengesScreen,
            (route) => route.isFirst,
          );
        }
      } else {
        _showError(data['message'] ??
            LocaleKeys.challenges_error_responding.tr(args: ['']));
      }
    } catch (e) {
      _showError(
          LocaleKeys.challenges_error_responding.tr(args: [e.toString()]));
    } finally {
      setState(() => _isResponding = false);
    }
  }

  Future<void> _handleAcceptChallenge() async {
    if (_challengeDetails == null) return;

    // Check if players are required
    if (_challengeDetails!.players_required == 1) {
      // Load team players and show bottom sheet
      await _loadTeamPlayers();
      if (_teamPlayers.isNotEmpty && mounted) {
        _showPlayerSelectionBottomSheet();
      } else {
        _showError('Failed to load team players');
      }
    } else {
      // Players not required, accept directly
      await _respondToChallenge('accept');
    }
  }

  Future<void> _loadTeamPlayers() async {
    if (_challengeDetails == null) return;

    try {
      // Get the current user's team ID (the team receiving the challenge)
      final teamId = _challengeDetails!.toTeamId;

      final response = await http.get(
        Uri.parse('${ConstKeys.baseUrl}/team/show/$teamId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['status'] == true) {
          final teamData = data['data'] as Map<String, dynamic>;
          setState(() {
            _teamPlayers = teamData['users'] as List<dynamic>? ?? [];
          });
        }
      }
    } catch (e) {
      print('Error loading team players: $e');
    }
  }

  void _showSuccess(String message) {
    Alerts.snack(text: message, state: SnackState.success);
  }

  void _showError(String message) {
    Alerts.snack(text: message, state: SnackState.failed);
  }

  void _showPlayerSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PlayerSelectionBottomSheet(
        players: _teamPlayers,
        onConfirm: (selectedPlayerIds) {
          _respondToChallenge('accept', playerIds: selectedPlayerIds.toList());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: context.primaryColor,
        title: CustomText(
          LocaleKeys.challenges_request_details.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _challengeDetails == null
              ? _buildErrorView()
              : _buildDetailsView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: LightThemeColors.secondaryText,
          ),
          SizedBox(height: 16),
          CustomText(
            LocaleKeys.challenges_failed_to_load.tr(),
            style: TextStyle(
              color: LightThemeColors.secondaryText,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadChallengeDetails,
            child: CustomText(LocaleKeys.challenges_retry.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsView() {
    final details = _challengeDetails!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Challenge Header
          _buildChallengeHeader(details),

          SizedBox(height: 24),

          // Teams Information
          _buildTeamsSection(details),

          SizedBox(height: 24),

          // Challenge Status
          _buildStatusSection(details),

          SizedBox(height: 24),

          // Action Buttons (only show if pending)
          if (details.isPending) _buildActionButtons(),

          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildChallengeHeader(ChallengeRequestDetails details) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor.withOpacity(0.1),
            context.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.sports_soccer,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Challenge Request',
                  style: TextStyle(
                    color: context.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                CustomText(
                  'Received ${details.formattedDate}',
                  style: TextStyle(
                    color: LightThemeColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsSection(ChallengeRequestDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          LocaleKeys.challenges_teams.tr(),
          style: TextStyle(
            color: context.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),

        // To Team (Your Team) - The team receiving the challenge
        _buildTeamCard(
          LocaleKeys.challenges_your_team.tr(),
          details.toTeamName,
          details.toTeam,
          Icons.arrow_downward,
          Colors.green,
        ),

        SizedBox(height: 12),

        // From Team (Challenging Team) - The team sending the challenge
        _buildTeamCard(
          LocaleKeys.challenges_challenging_team.tr(),
          details.fromTeamName,
          details.fromTeam,
          Icons.arrow_upward,
          context.primaryColor,
        ),
      ],
    );
  }

  Widget _buildTeamCard(String label, String teamName,
      Map<String, dynamic>? teamData, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      label,
                      style: TextStyle(
                        color: LightThemeColors.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    CustomText(
                      teamName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (teamData != null) ...[
            SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey.shade300),
            SizedBox(height: 8),

            // Team Leader
            if (teamData['leader'] != null) ...[
              Row(
                children: [
                  Icon(Icons.person,
                      color: LightThemeColors.secondaryText, size: 16),
                  SizedBox(width: 8),
                  CustomText(
                    '${LocaleKeys.challenges_team_leader.tr()}: ${(teamData['leader'] as Map<String, dynamic>)['name'] ?? 'N/A'}',
                    style: TextStyle(
                      color: LightThemeColors.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
            ],

            // Team Members Count
            if (teamData['members_count'] != null) ...[
              Row(
                children: [
                  Icon(Icons.group,
                      color: LightThemeColors.secondaryText, size: 16),
                  SizedBox(width: 8),
                  CustomText(
                    '${LocaleKeys.challenges_team_members.tr()}: ${teamData['members_count']}',
                    style: TextStyle(
                      color: LightThemeColors.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
            ],

            // Team Bio
            if (teamData['bio'] != null &&
                teamData['bio'].toString().isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline,
                      color: LightThemeColors.secondaryText, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: CustomText(
                      '${LocaleKeys.challenges_team_bio.tr()}: ${teamData['bio']}',
                      style: TextStyle(
                        color: LightThemeColors.secondaryText,
                        fontSize: 14,
                      ),
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildStatusSection(ChallengeRequestDetails details) {
    Color statusColor;
    String statusText;

    switch (details.status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        statusText = LocaleKeys.challenges_pending.tr();
        break;
      case 'accepted':
        statusColor = Colors.green;
        statusText = LocaleKeys.challenges_accepted.tr();
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = LocaleKeys.challenges_rejected.tr();
        break;
      default:
        statusColor = Colors.grey;
        statusText = details.status;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            details.status.toLowerCase() == 'pending'
                ? Icons.schedule
                : details.status.toLowerCase() == 'accepted'
                    ? Icons.check_circle
                    : Icons.cancel,
            color: statusColor,
            size: 24,
          ),
          SizedBox(width: 12),
          CustomText(
            '${LocaleKeys.challenges_status.tr()} $statusText',
            style: TextStyle(
              color: statusColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(
          LocaleKeys.challenges_respond_to_challenge.tr(),
          style: TextStyle(
            color: context.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed:
                    _isResponding ? null : () => _handleAcceptChallenge(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isResponding
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : CustomText(
                        LocaleKeys.challenges_accept.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed:
                    _isResponding ? null : () => _respondToChallenge('reject'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isResponding
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : CustomText(
                        LocaleKeys.challenges_reject.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Bottom sheet widget for selecting team players
class _PlayerSelectionBottomSheet extends StatefulWidget {
  final List<dynamic> players;
  final Function(Set<int>) onConfirm;

  const _PlayerSelectionBottomSheet({
    required this.players,
    required this.onConfirm,
  });

  @override
  State<_PlayerSelectionBottomSheet> createState() =>
      _PlayerSelectionBottomSheetState();
}

class _PlayerSelectionBottomSheetState
    extends State<_PlayerSelectionBottomSheet> {
  Set<int> _selectedPlayerIds = {};

  @override
  Widget build(BuildContext context) {
    final selectedCount = _selectedPlayerIds.length;
    final canConfirm = selectedCount >= 10;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        'Select Players',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        'Select at least 10 players from your team',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Selection counter
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: canConfirm ? Colors.green.shade50 : Colors.orange.shade50,
            child: Row(
              children: [
                Icon(
                  canConfirm ? Icons.check_circle : Icons.info,
                  color: canConfirm ? Colors.green : Colors.orange,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: CustomText(
                    canConfirm
                        ? '$selectedCount players selected'
                        : '$selectedCount/10 players selected (${10 - selectedCount} more needed)',
                    style: TextStyle(
                      color: canConfirm
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Players list
          Expanded(
            child: widget.players.isEmpty
                ? Center(
                    child: CustomText(
                      'No players available',
                      style: TextStyle(
                        color: LightThemeColors.secondaryText,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: widget.players.length,
                    itemBuilder: (context, index) {
                      final player =
                          widget.players[index] as Map<String, dynamic>;
                      final playerId = player['id'] as int? ?? 0;
                      final playerName = player['name'] as String? ?? 'Unknown';
                      final playerPhone = player['mobile'] as String? ??
                          player['phone'] as String? ??
                          '';
                      final isSelected = _selectedPlayerIds.contains(playerId);

                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? context.primaryColor
                                : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: CheckboxListTile(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedPlayerIds.add(playerId);
                              } else {
                                _selectedPlayerIds.remove(playerId);
                              }
                            });
                          },
                          title: CustomText(
                            playerName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: playerPhone.isNotEmpty
                              ? CustomText(
                                  playerPhone,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: LightThemeColors.secondaryText,
                                  ),
                                )
                              : null,
                          secondary: CircleAvatar(
                            backgroundColor: isSelected
                                ? context.primaryColor
                                : Colors.grey.shade300,
                            child: Icon(
                              Icons.person,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                          ),
                          activeColor: context.primaryColor,
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      );
                    },
                  ),
          ),

          // Confirm button
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: canConfirm
                  ? () {
                      Navigator.pop(context);
                      widget.onConfirm(_selectedPlayerIds);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: CustomText(
                canConfirm
                    ? 'Confirm Selection ($selectedCount players)'
                    : 'Select at least 10 players',
                style: TextStyle(
                  color: canConfirm ? Colors.white : Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
