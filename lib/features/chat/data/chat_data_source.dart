import 'dart:async';
import 'dart:developer';

import '../../../core/data_source/dio_helper.dart';
import '../domain/model/chat_message.dart';
import '../domain/model/team_chat.dart';
import '../domain/request/send_message_request.dart';

class ChatDataSource {
  final DioService _dioService;
  final StreamController<ChatMessage> _messageStreamController =
      StreamController<ChatMessage>.broadcast();

  ChatDataSource(this._dioService);

  Future<List<TeamChat>> getUserTeamChats() async {
    try {
      final response = await _dioService.getData(
        url: '/team/user-teams',
        loading: false,
      );

      if (!response.isError && response.response?.data != null) {
        final List<dynamic> data = response.response!.data ?? [];
        return data
            .map((json) => TeamChat.fromJson({
                  'team_id': json['id'].toString(),
                  'team_name': json['name'],
                  'team_avatar': json['logo_url'] ?? '',
                  'last_message':
                      null, // We'll need to get this separately if needed
                  'unread_count': 0,
                  'member_ids':
                      [], // We'll need to get this from team details if needed
                  'last_activity': json['updated_at'],
                }))
            .toList();
      }
      return [];
    } catch (e) {
      log('Error getting team chats: $e');
      return [];
    }
  }

  Future<List<ChatMessage>> getTeamMessages(GetMessagesRequest request) async {
    try {
      final response = await _dioService.getData(
        url: '/messages/team/${request.teamId}',
        query: {
          'page': request.page.toString(),
          'per_page': request.limit.toString(),
        },
        loading: false,
      );

      if (!response.isError && response.response?.data != null) {
        final data = response.response!.data['data'];
        final List<dynamic> messages = data['messages'] ?? [];
        return messages
            .map((json) => ChatMessage.fromJson({
                  'id': json['id'].toString(),
                  'sender_id': json['user']['id'].toString(),
                  'sender_name': json['user']['name'],
                  'sender_avatar': json['user']['image'] ?? '',
                  'message': json['content'],
                  'timestamp': json['created_at'],
                  'team_id': request.teamId,
                  'type': 'text',
                  'is_read': true, // Assume read for now
                }))
            .toList();
      }
      return [];
    } catch (e) {
      log('Error getting team messages: $e');
      return [];
    }
  }

  Future<ChatMessage?> sendMessage(SendMessageRequest request) async {
    try {
      final response = await _dioService.postData(
        url: '/messages/send',
        body: {
          'team_id': int.parse(request.teamId),
          'content': request.message,
        },
        loading: false,
      );

      if (!response.isError && response.response?.data != null) {
        final messageData = response.response!.data['data']['message'];
        final message = ChatMessage.fromJson({
          'id': messageData['id'].toString(),
          'sender_id': messageData['user']['id'].toString(),
          'sender_name': messageData['user']['name'],
          'sender_avatar': messageData['user']['image'] ?? '',
          'message': messageData['content'],
          'timestamp': messageData['created_at'],
          'team_id': request.teamId,
          'type': 'text',
          'is_read': false,
        });

        // Emit the new message to the stream
        _messageStreamController.add(message);

        return message;
      }
      return null;
    } catch (e) {
      log('Error sending message: $e');
      return null;
    }
  }

  Future<bool> markMessagesAsRead(String teamId) async {
    // This endpoint doesn't exist in your API, so we'll just return true
    // You can implement this later if needed
    return true;
  }

  Future<bool> deleteMessage(String messageId) async {
    try {
      final response = await _dioService.postData(
        url: '/messages/delete/$messageId',
        body: {},
        loading: false,
      );

      return !response.isError;
    } catch (e) {
      log('Error deleting message: $e');
      return false;
    }
  }

  Stream<ChatMessage> listenToNewMessages(String teamId) {
    // In a real implementation, you might use WebSocket or Server-Sent Events
    // For now, we'll return the broadcast stream
    return _messageStreamController.stream
        .where((message) => message.teamId == teamId);
  }

  void dispose() {
    _messageStreamController.close();
  }
}
