import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../domain/model/chat_message.dart';

class MessageItem extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onDelete;

  const MessageItem({
    Key? key,
    required this.message,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMyMessage = message.senderId == Utils.userId;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage) ...[
            CircleAvatar(
              radius: 16.r,
              backgroundImage: message.senderAvatar.isNotEmpty
                  ? CachedNetworkImageProvider(message.senderAvatar)
                  : null,
              child: message.senderAvatar.isEmpty
                  ? Icon(Icons.person, size: 16.r)
                  : null,
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress:
                  isMyMessage ? () => _showDeleteDialog(context) : null,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: isMyMessage
                      ? Theme.of(context).primaryColor
                      : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                    bottomLeft: isMyMessage
                        ? Radius.circular(16.r)
                        : Radius.circular(4.r),
                    bottomRight: isMyMessage
                        ? Radius.circular(4.r)
                        : Radius.circular(16.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMyMessage)
                      Text(
                        message.senderName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    if (!isMyMessage) SizedBox(height: 2.h),
                    Text(
                      message.message,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isMyMessage ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color:
                                isMyMessage ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                        if (isMyMessage) ...[
                          SizedBox(width: 4.w),
                          Icon(
                            message.isRead ? Icons.done_all : Icons.done,
                            size: 12.r,
                            color: message.isRead
                                ? Colors.blue[300]
                                : Colors.white70,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isMyMessage) ...[
            SizedBox(width: 8.w),
            CircleAvatar(
              radius: 16.r,
              backgroundImage: message.senderAvatar.isNotEmpty
                  ? CachedNetworkImageProvider(message.senderAvatar)
                  : null,
              child: message.senderAvatar.isEmpty
                  ? Icon(Icons.person, size: 16.r)
                  : null,
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (now.difference(messageDate).inDays == 1) {
      return LocaleKeys.chat_yesterday.tr();
    } else if (now.difference(messageDate).inDays < 7) {
      final weekdays = [
        LocaleKeys.chat_monday.tr(),
        LocaleKeys.chat_tuesday.tr(),
        LocaleKeys.chat_wednesday.tr(),
        LocaleKeys.chat_thursday.tr(),
        LocaleKeys.chat_friday.tr(),
        LocaleKeys.chat_saturday.tr(),
        LocaleKeys.chat_sunday.tr(),
      ];
      return weekdays[dateTime.weekday - 1];
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.chat_delete_message.tr()),
        content: Text(LocaleKeys.chat_delete_message_confirm.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.chat_cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete(message.id);
            },
            child: Text(
              LocaleKeys.chat_delete.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
