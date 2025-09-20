import 'chat_message.dart';

class TeamChat {
  final String teamId;
  final String teamName;
  final String teamAvatar;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final List<String> memberIds;
  final DateTime? lastActivity;

  TeamChat({
    required this.teamId,
    required this.teamName,
    required this.teamAvatar,
    this.lastMessage,
    this.unreadCount = 0,
    required this.memberIds,
    this.lastActivity,
  });

  factory TeamChat.fromJson(Map<String, dynamic> json) {
    return TeamChat(
      teamId: json['team_id']?.toString() ?? '',
      teamName: json['team_name']?.toString() ?? '',
      teamAvatar: json['team_avatar']?.toString() ?? '',
      lastMessage: json['last_message'] != null
          ? ChatMessage.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count']?.toInt() ?? 0,
      memberIds: List<String>.from(json['member_ids'] ?? []),
      lastActivity: json['last_activity'] != null
          ? DateTime.tryParse(json['last_activity'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_id': teamId,
      'team_name': teamName,
      'team_avatar': teamAvatar,
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'member_ids': memberIds,
      'last_activity': lastActivity?.toIso8601String(),
    };
  }

  TeamChat copyWith({
    String? teamId,
    String? teamName,
    String? teamAvatar,
    ChatMessage? lastMessage,
    int? unreadCount,
    List<String>? memberIds,
    DateTime? lastActivity,
  }) {
    return TeamChat(
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamAvatar: teamAvatar ?? this.teamAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      memberIds: memberIds ?? this.memberIds,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}
