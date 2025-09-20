class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String message;
  final DateTime timestamp;
  final String teamId;
  final MessageType type;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.message,
    required this.timestamp,
    required this.teamId,
    this.type = MessageType.text,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      senderName: json['sender_name']?.toString() ?? '',
      senderAvatar: json['sender_avatar']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      teamId: json['team_id']?.toString() ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == (json['type'] ?? 'text'),
        orElse: () => MessageType.text,
      ),
      isRead: json['is_read'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'team_id': teamId,
      'type': type.name,
      'is_read': isRead,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? message,
    DateTime? timestamp,
    String? teamId,
    MessageType? type,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      teamId: teamId ?? this.teamId,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum MessageType {
  text,
  image,
  file,
  system,
}
