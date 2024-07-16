import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/resources/gen/assets.gen.dart';
import '../../domain/model/notify_model.dart';

class NotifyItem extends StatefulWidget {
  const NotifyItem({
    super.key,
    this.isSeen = false,
    this.notificationModel,
  });
  final bool? isSeen;
  final NotificationModel? notificationModel;

  @override
  State<NotifyItem> createState() => _NotifyItemState();
}

class _NotifyItemState extends State<NotifyItem>
    with SingleTickerProviderStateMixin {
  double height = 40;
  bool isExpand = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      // only(bottom: 10, right: 5, left: 5),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
              right: 26,
              left: 20,
              top: 25,
              bottom: 25,
            ),
            decoration: BoxDecoration(
              color: context.background,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  // spreadRadius: -5,
                  offset: Offset.zero,
                  blurRadius: 30,
                  color: LightThemeColors.black.withOpacity(.13),
                ),
              ],
            ),
            child: ExpansionTile(
              onExpansionChanged: (value) {
                isExpand = value;
                setState(() {});
              },
              trailing: SizedBox(
                height: 0,
              ),
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(side: BorderSide.none),
              title: Container(
                // padding: EdgeInsets.only(
                //   right: 26,
                //   left: 20,
                //   top: 25,
                //   bottom: 25,
                // ),
                // decoration: BoxDecoration(
                //   color: context.background,
                //   borderRadius: BorderRadius.circular(13),
                //   boxShadow: [
                //     BoxShadow(
                //       // spreadRadius: -5,
                //       offset: Offset.zero,
                //       blurRadius: 30,
                //       color: LightThemeColors.black.withOpacity(.13),
                //     ),
                //   ],
                // ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.notificationModel?.isread ?? false
                            ? SvgPicture.asset(
                                // color: LightThemeColors.,
                                width: 44,
                                height: 40,
                                // "location".svg(),
                                Assets.icons.notifyLogo,
                              )
                            : Stack(
                                children: [
                                  SvgPicture.asset(
                                    color: context.primaryColor,
                                    width: 44,
                                    height: 40,
                                    // "location".svg(),
                                    Assets.icons.notifyActiveLogo,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 10,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        12.79.pw,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: CustomText(
                                widget.notificationModel?.data?.title ?? "",
                                style: TextStyle(
                                  color:
                                      widget.notificationModel?.isread ?? false
                                          ? LightThemeColors.notifytextSeen
                                          : context.primaryColor,
                                ).s18.medium,
                                // fontSize: 14.sp,
                                // weight: FontWeight.w600,
                              ),
                            ),
                            7.ph,
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "clock".svg(),
                                  width: 18.91,
                                  height: 18.91,
                                ),
                                4.pw,
                                CustomText(
                                  widget.notificationModel?.createdAt ?? "",
                                  style: TextStyle(
                                    color: LightThemeColors.black,
                                  ).s12.light,

                                  // fontSize: 12.sp,
                                  // weight: FontWeight.w400,
                                ),
                                // 4.pw,
                                // CustomText(
                                //   "09:30 مساء",
                                //   style: TextStyle(
                                //     color: LightThemeColors.black,
                                //   ).s12.light,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    12.79.ph,
                    if (isExpand == false)
                      Container(
                        // width: 300,
                        height: height,
                        child: CustomText(
                          widget.notificationModel?.data?.message ?? '',
                          style: TextStyle(
                            overflow: TextOverflow.clip,
                            color: widget.notificationModel?.isread ?? false
                                ? LightThemeColors.subtitleNotify
                                : LightThemeColors.black,
                          ).s14.light,

                          // fontSize: 13.sp,
                          // weight: FontWeight.w400,
                        ),
                      )
                  ],
                ),
              ),
              children: [
                if (isExpand == true)
                  Container(
                    // width: 300,
                    // height: height,
                    child: CustomText(
                      widget.notificationModel?.data?.message ?? '',
                      style: TextStyle(
                        overflow: TextOverflow.clip,
                        color: widget.notificationModel?.isread ?? false
                            ? LightThemeColors.subtitleNotify
                            : LightThemeColors.black,
                      ).s14.light,

                      // fontSize: 13.sp,
                      // weight: FontWeight.w400,
                    ),
                  )
              ],
            ),
          ),
          12.ph
        ],
      ),
    );
  }
}
