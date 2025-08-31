class MatchModel {
  final int id;
  final int playgroundId;
  final String date;
  final String startTime;
  final String endTime;
  final int durations;
  final String durationsText;
  final String amount;
  final int subscribersQty;
  final String details;
  final int status;
  final bool isCompetitive;
  final String type;
  final int? team1Id;
  final int? team2Id;
  final int supervisorId;
  final String createdAt;
  final String updatedAt;

  MatchModel({
    required this.id,
    required this.playgroundId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.durations,
    required this.durationsText,
    required this.amount,
    required this.subscribersQty,
    required this.details,
    required this.status,
    required this.isCompetitive,
    required this.type,
    this.team1Id,
    this.team2Id,
    required this.supervisorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    try {
      // Handle new API structure for challenge matches
      if (json.containsKey('playground')) {
        // New API structure
        return MatchModel(
          id: _parseInt(json['id']),
          playgroundId: 0, // Not provided in new API
          date: json['date'] as String? ?? '',
          startTime: json['start_time'] as String? ?? '',
          endTime: json['start_time'] as String? ?? '', // Use start_time as end_time if not provided
          durations: 0, // Not provided
          durationsText: '', // Not provided
          amount: json['amount']?.toString() ?? '0',
          subscribersQty: 0, // Not provided
          details: json['playground'] as String? ?? '', // Use playground as details
          status: json['is_reserved'] == true ? 1 : 0, // Map is_reserved to status
          isCompetitive: false, // Default
          type: 'challenge', // Assume challenge
          team1Id: null,
          team2Id: null,
          supervisorId: 0, // Not provided
          createdAt: '', // Not provided
          updatedAt: '', // Not provided
        );
      } else {
        // Original API structure
        return MatchModel(
          id: _parseInt(json['id']),
          playgroundId: _parseInt(json['playground_id']),
          date: json['date'] as String? ?? '',
          startTime: json['start_time'] as String? ?? '',
          endTime: json['end_time'] as String? ?? '',
          durations: _parseInt(json['durations']),
          durationsText: json['durations_text'] as String? ?? '',
          amount: json['amount']?.toString() ?? '0',
          subscribersQty: _parseInt(json['subscribers_qty']),
          details: json['details'] as String? ?? '',
          status: _parseInt(json['status']),
          isCompetitive: json['is_competitive'] == 1 || json['is_competitive'] == true,
          type: json['type'] as String? ?? '',
          team1Id: json['team1_id'] != null ? _parseInt(json['team1_id']) : null,
          team2Id: json['team2_id'] != null ? _parseInt(json['team2_id']) : null,
          supervisorId: _parseInt(json['supervisor_id']),
          createdAt: json['created_at'] as String? ?? '',
          updatedAt: json['updated_at'] as String? ?? '',
        );
      }
    } catch (e) {
      throw Exception('Failed to parse match data: $e');
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is bool) return value ? 1 : 0;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playground_id': playgroundId,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'durations': durations,
      'durations_text': durationsText,
      'amount': amount,
      'subscribers_qty': subscribersQty,
      'details': details,
      'status': status,
      'is_competitive': isCompetitive ? 1 : 0,
      'type': type,
      'team1_id': team1Id,
      'team2_id': team2Id,
      'supervisor_id': supervisorId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

