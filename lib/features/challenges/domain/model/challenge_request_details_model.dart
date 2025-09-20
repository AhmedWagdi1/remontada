/// Model for challenge request details
class ChallengeRequestDetails {
  final int id;
  final int fromTeamId;
  final int toTeamId;
  final String fromTeamName;
  final String toTeamName;
  final String status;
  final String createdAt;
  final Map<String, dynamic>? fromTeam;
  final Map<String, dynamic>? toTeam;
  final Map<String, dynamic>? matchDetails;

  ChallengeRequestDetails({
    required this.id,
    required this.fromTeamId,
    required this.toTeamId,
    required this.fromTeamName,
    required this.toTeamName,
    required this.status,
    required this.createdAt,
    this.fromTeam,
    this.toTeam,
    this.matchDetails,
  });

  factory ChallengeRequestDetails.fromJson(Map<String, dynamic> json) {
    return ChallengeRequestDetails(
      id: json['id'] ?? 0,
      fromTeamId: json['requester_team_id'] ?? json['from_team_id'] ?? 0,
      toTeamId: json['invited_team_id'] ?? json['to_team_id'] ?? 0,
      fromTeamName:
          json['requester_team']?['name'] ?? json['from_team_name'] ?? '',
      toTeamName: json['invited_team']?['name'] ?? json['to_team_name'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
      fromTeam: json['requester_team'] ?? json['from_team'],
      toTeam: json['invited_team'] ?? json['to_team'],
      matchDetails: json['match_details'],
    );
  }

  /// Check if this request is pending (not accepted, rejected, or cancelled)
  bool get isPending => status == 'pending';

  /// Get formatted date
  String get formattedDate {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return createdAt;
    }
  }
}
