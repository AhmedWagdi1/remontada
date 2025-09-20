class SendMessageRequest {
  final String teamId;
  final String message;

  SendMessageRequest({
    required this.teamId,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'team_id': int.parse(teamId),
      'content': message,
    };
  }
}

class GetMessagesRequest {
  final String teamId;
  final int page;
  final int limit;
  final String? lastMessageId;

  GetMessagesRequest({
    required this.teamId,
    this.page = 1,
    this.limit = 20,
    this.lastMessageId,
  });

  Map<String, String> toQueryParams() {
    final params = <String, String>{
      'team_id': teamId,
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (lastMessageId != null) {
      params['last_message_id'] = lastMessageId!;
    }

    return params;
  }
}
