import '../domain/model/chat_message.dart';
import '../domain/model/team_chat.dart';
import '../domain/repository/chat_repository.dart';
import '../domain/request/send_message_request.dart';
import 'chat_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _dataSource;

  ChatRepositoryImpl(this._dataSource);

  @override
  Future<List<TeamChat>> getUserTeamChats() async {
    return await _dataSource.getUserTeamChats();
  }

  @override
  Future<List<ChatMessage>> getTeamMessages(GetMessagesRequest request) async {
    return await _dataSource.getTeamMessages(request);
  }

  @override
  Future<ChatMessage> sendMessage(SendMessageRequest request) async {
    final message = await _dataSource.sendMessage(request);
    if (message == null) {
      throw Exception('Failed to send message');
    }
    return message;
  }

  @override
  Future<void> markMessagesAsRead(String teamId) async {
    await _dataSource.markMessagesAsRead(teamId);
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await _dataSource.deleteMessage(messageId);
  }

  @override
  Stream<ChatMessage> listenToNewMessages(String teamId) {
    return _dataSource.listenToNewMessages(teamId);
  }
}
