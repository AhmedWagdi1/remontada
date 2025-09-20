import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../cubit/chat_cubit.dart';
import '../../cubit/chat_states.dart';
import '../../domain/request/send_message_request.dart';
import '../widgets/message_item.dart';
import '../widgets/message_input.dart';

class TeamMessagesScreen extends StatefulWidget {
  final String teamId;
  final String teamName;
  final String teamAvatar;

  const TeamMessagesScreen({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamAvatar,
  }) : super(key: key);

  @override
  State<TeamMessagesScreen> createState() => _TeamMessagesScreenState();
}

class _TeamMessagesScreenState extends State<TeamMessagesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  late TeamMessagesCubit _messagesCubit;
  late SendMessageCubit _sendMessageCubit;

  @override
  void initState() {
    super.initState();
    _messagesCubit = context.read<TeamMessagesCubit>();
    _sendMessageCubit = context.read<SendMessageCubit>();

    _messagesCubit.loadMessages(refresh: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _messagesCubit.loadMoreMessages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _sendMessageCubit.sendMessage(
        SendMessageRequest(
          teamId: widget.teamId,
          message: message,
        ),
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teamName),
        centerTitle: true,
        actions: [
          CircleAvatar(
            radius: 16.r,
            backgroundImage: widget.teamAvatar.isNotEmpty
                ? NetworkImage(widget.teamAvatar)
                : null,
            child: widget.teamAvatar.isEmpty
                ? Icon(Icons.group, size: 16.r)
                : null,
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<TeamMessagesCubit, TeamMessagesState>(
              builder: (context, state) {
                if (state is TeamMessagesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is TeamMessagesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.r,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          LocaleKeys.chat_failed_to_load.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            _messagesCubit.loadMessages(refresh: true);
                          },
                          child: Text(LocaleKeys.chat_retry.tr()),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TeamMessagesLoaded) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64.r,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            LocaleKeys.chat_no_messages.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            LocaleKeys.chat_start_conversation.tr(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await _messagesCubit.loadMessages(refresh: true);
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: EdgeInsets.all(16.w),
                      itemCount:
                          state.messages.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.messages.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final message = state.messages[index];
                        return MessageItem(
                          message: message,
                          onDelete: (messageId) {
                            _messagesCubit.deleteMessage(messageId);
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          BlocListener<SendMessageCubit, SendMessageState>(
            listener: (context, state) {
              if (state is SendMessageError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(LocaleKeys.chat_failed_to_send.tr()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: MessageInput(
              controller: _messageController,
              onSend: _sendMessage,
              isLoading:
                  context.watch<SendMessageCubit>().state is SendMessageLoading,
            ),
          ),
        ],
      ),
    );
  }
}
