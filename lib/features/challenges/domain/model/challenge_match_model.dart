/// Model for challenge match data from the challenges-index API.
class ChallengeMatch {
  final int id;
  final String playground;
  final String date;
  final String startTime;
  final String amount;
  final bool isReserved;
  final Map<String, dynamic>? team1;
  final Map<String, dynamic>? team2;

  ChallengeMatch({
    required this.id,
    required this.playground,
    required this.date,
    required this.startTime,
    required this.amount,
    required this.isReserved,
    this.team1,
    this.team2,
  });

  factory ChallengeMatch.fromJson(Map<String, dynamic> json) {
    return ChallengeMatch(
      id: json['id'] ?? 0,
      playground: json['playground'] ?? '',
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      isReserved: json['is_reserved'] == true,
      team1: json['team1'],
      team2: json['team2'],
    );
  }

  /// Parses the date string to extract DateTime.
  DateTime get parsedDate {
    final datePart = date.split(' ')[1]; // Extract "2025-11-19"
    return DateTime.parse(datePart);
  }

  /// Checks if the match is in the past.
  bool get isPast => parsedDate.isBefore(DateTime.now());
}
