class CreateMatchRequest {
  final String playgroundId;
  final String supervisorId;
  final String subscribersQty;
  final String date;
  final String startTime;
  final String durations;
  final String durationsText;
  final String details;
  final String amount;
  final String type;

  CreateMatchRequest({
    required this.playgroundId,
    required this.supervisorId,
    required this.subscribersQty,
    required this.date,
    required this.startTime,
    required this.durations,
    required this.durationsText,
    required this.details,
    required this.amount,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'playground_id': playgroundId,
      'supervisor_id': supervisorId,
      'subscribers_qty': subscribersQty,
      'date': date,
      'start_time': startTime,
      'durations': durations,
      'durations_text': durationsText,
      'details': details,
      'amount': amount,
      'type': type,
    };
  }
}
