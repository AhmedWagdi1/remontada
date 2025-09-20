import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../cubit/chat_cubit.dart';
import '../../cubit/chat_states.dart';
import '../widgets/team_chat_item.dart';

class TeamChatsScreen extends StatefulWidget {
  const TeamChatsScreen({Key? key}) : super(key: key);

  @override
  State<TeamChatsScreen> createState() => _TeamChatsScreenState();
}

class _TeamChatsScreenState extends State<TeamChatsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadTeamChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.chat_team_chats.tr()),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ChatCubit>().refreshTeamChats();
        },
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ChatError) {
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
                      LocaleKeys.chat_error_loading.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ChatCubit>().loadTeamChats();
                      },
                      child: Text(LocaleKeys.chat_retry.tr()),
                    ),
                  ],
                ),
              );
            }

            if (state is ChatLoaded) {
              if (state.teamChats.isEmpty) {
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
                        LocaleKeys.chat_no_teams_available.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: state.teamChats.length,
                itemBuilder: (context, index) {
                  final teamChat = state.teamChats[index];
                  return TeamChatItem(
                    teamChat: teamChat,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.TeamMessagesScreen,
                        arguments: {
                          'teamId': teamChat.teamId,
                          'teamName': teamChat.teamName,
                          'teamAvatar': teamChat.teamAvatar,
                        },
                      );
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
