class CreateChallengeResponse {
  final bool status;
  final String message;
  final dynamic data;

  CreateChallengeResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CreateChallengeResponse.fromJson(Map<String, dynamic> json) {
    return CreateChallengeResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'],
    );
  }
}

