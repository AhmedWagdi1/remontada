import '../model/chat_message.dart';
import '../model/team_chat.dart';
import '../request/send_message_request.dart';

abstract class ChatRepository {
  Future<List<TeamChat>> getUserTeamChats();
  Future<List<ChatMessage>> getTeamMessages(GetMessagesRequest request);
  Future<ChatMessage> sendMessage(SendMessageRequest request);
  Future<void> markMessagesAsRead(String teamId);
  Future<void> deleteMessage(String messageId);
  Stream<ChatMessage> listenToNewMessages(String teamId);
}
