import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../domain/model/team_chat.dart';

class TeamChatItem extends StatelessWidget {
  final TeamChat teamChat;
  final VoidCallback onTap;

  const TeamChatItem({
    Key? key,
    required this.teamChat,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24.r,
          backgroundImage: teamChat.teamAvatar.isNotEmpty
              ? CachedNetworkImageProvider(teamChat.teamAvatar)
              : null,
          child: teamChat.teamAvatar.isEmpty
              ? Icon(Icons.group, size: 24.r)
              : null,
        ),
        title: Text(
          teamChat.teamName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: teamChat.lastMessage != null
            ? Text(
                teamChat.lastMessage!.message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                LocaleKeys.chat_no_messages.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (teamChat.lastMessage != null)
              Text(
                _formatTime(teamChat.lastMessage!.timestamp),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                ),
              ),
            if (teamChat.unreadCount > 0) ...[
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  teamChat.unreadCount > 99 ? '99+' : teamChat.unreadCount.toString(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}