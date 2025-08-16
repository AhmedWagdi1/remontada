import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/model/chat_message.dart';
import '../domain/repository/chat_repository.dart';
import '../domain/request/send_message_request.dart';
import 'chat_states.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;

  ChatCubit(this._repository) : super(ChatInitial());

  Future<void> loadTeamChats() async {
    try {
      emit(ChatLoading());
      final teamChats = await _repository.getUserTeamChats();
      emit(ChatLoaded(teamChats));
    } catch (e) {
      log('Error loading team chats: $e');
      emit(ChatError('Failed to load team chats'));
    }
  }

  Future<void> refreshTeamChats() async {
    try {
      final teamChats = await _repository.getUserTeamChats();
      emit(ChatLoaded(teamChats));
    } catch (e) {
      log('Error refreshing team chats: $e');
    }
  }
}

class TeamMessagesCubit extends Cubit<TeamMessagesState> {
  final ChatRepository _repository;
  final String teamId;
  StreamSubscription<ChatMessage>? _messageSubscription;
  List<ChatMessage> _messages = [];
  int _currentPage = 1;
  static const int _pageSize = 20;

  TeamMessagesCubit(this._repository, this.teamId) : super(TeamMessagesInitial()) {
    _listenToNewMessages();
  }

  Future<void> loadMessages({bool refresh = false}) async {
    try {
      if (refresh) {
        _currentPage = 1;
        _messages.clear();
        emit(TeamMessagesLoading());
      } else if (state is TeamMessagesLoaded) {
        final currentState = state as TeamMessagesLoaded;
        emit(currentState.copyWith(isLoadingMore: true));
      } else {
        emit(TeamMessagesLoading());
      }

      final request = GetMessagesRequest(
        teamId: teamId,
        page: _currentPage,
        limit: _pageSize,
      );

      final newMessages = await _repository.getTeamMessages(request);
      
      if (refresh) {
        _messages = newMessages;
      } else {
        _messages.addAll(newMessages);
      }

      _currentPage++;
      
      emit(TeamMessagesLoaded(
        messages: List.from(_messages),
        hasMore: newMessages.length == _pageSize,
        isLoadingMore: false,
      ));

      // Mark messages as read
      await _repository.markMessagesAsRead(teamId);
    } catch (e) {
      log('Error loading messages: $e');
      emit(TeamMessagesError('Failed to load messages'));
    }
  }

  Future<void> loadMoreMessages() async {
    if (state is TeamMessagesLoaded) {
      final currentState = state as TeamMessagesLoaded;
      if (currentState.hasMore && !currentState.isLoadingMore) {
        await loadMessages();
      }
    }
  }

  void _listenToNewMessages() {
    _messageSubscription = _repository.listenToNewMessages(teamId).listen(
      (message) {
        _addNewMessage(message);
      },
      onError: (error) {
        log('Error listening to new messages: $error');
      },
    );
  }

  void _addNewMessage(ChatMessage message) {
    if (state is TeamMessagesLoaded) {
      final currentState = state as TeamMessagesLoaded;
      final updatedMessages = [message, ...currentState.messages];
      _messages = updatedMessages;
      emit(TeamMessagesLoaded(
        messages: updatedMessages,
        hasMore: currentState.hasMore,
        isLoadingMore: currentState.isLoadingMore,
      ));
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await _repository.deleteMessage(messageId);
      
      if (state is TeamMessagesLoaded) {
        final currentState = state as TeamMessagesLoaded;
        final updatedMessages = currentState.messages
            .where((message) => message.id != messageId)
            .toList();
        _messages = updatedMessages;
        emit(TeamMessagesLoaded(
          messages: updatedMessages,
          hasMore: currentState.hasMore,
          isLoadingMore: currentState.isLoadingMore,
        ));
      }
    } catch (e) {
      log('Error deleting message: $e');
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}

class SendMessageCubit extends Cubit<SendMessageState> {
  final ChatRepository _repository;

  SendMessageCubit(this._repository) : super(SendMessageInitial());

  Future<void> sendMessage(SendMessageRequest request) async {
    try {
      emit(SendMessageLoading());
      final message = await _repository.sendMessage(request);
      emit(SendMessageSuccess(message));
    } catch (e) {
      log('Error sending message: $e');
      emit(SendMessageError('Failed to send message'));
    }
  }

  void resetState() {
    emit(SendMessageInitial());
  }
}