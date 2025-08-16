import '../domain/model/chat_message.dart';
import '../domain/model/team_chat.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<TeamChat> teamChats;

  ChatLoaded(this.teamChats);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

// Team Messages States
abstract class TeamMessagesState {}

class TeamMessagesInitial extends TeamMessagesState {}

class TeamMessagesLoading extends TeamMessagesState {}

class TeamMessagesLoaded extends TeamMessagesState {
  final List<ChatMessage> messages;
  final bool hasMore;
  final bool isLoadingMore;

  TeamMessagesLoaded({
    required this.messages,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  TeamMessagesLoaded copyWith({
    List<ChatMessage>? messages,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return TeamMessagesLoaded(
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class TeamMessagesError extends TeamMessagesState {
  final String message;

  TeamMessagesError(this.message);
}

// Send Message States
abstract class SendMessageState {}

class SendMessageInitial extends SendMessageState {}

class SendMessageLoading extends SendMessageState {}

class SendMessageSuccess extends SendMessageState {
  final ChatMessage message;

  SendMessageSuccess(this.message);
}

class SendMessageError extends SendMessageState {
  final String message;

  SendMessageError(this.message);
}