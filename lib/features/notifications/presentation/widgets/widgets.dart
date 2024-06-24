import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/resources/gen/assets.gen.dart';

class NotifyItem extends StatelessWidget {
  const NotifyItem({
    super.key,
    this.isSeen = false,
  });
  final bool? isSeen;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, right: 5.w, left: 5.w),
      child: Container(
        padding: EdgeInsets.only(
          right: 26.w,
          left: 16.w,
          top: 20.h,
          bottom: 20.h,
        ),
        decoration: BoxDecoration(
          color: context.background,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              spreadRadius: -5,
              offset: Offset.zero,
              blurRadius: 30,
              color: LightThemeColors.black.withOpacity(.1),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isSeen!
                    ? SvgPicture.asset(
                        // color: LightThemeColors.,
                        width: 44.w,
                        height: 40.h,
                        // "location".svg(),
                        Assets.icons.notifyLogo,
                      )
                    : Stack(
                        children: [
                          SvgPicture.asset(
                            color: context.primaryColor,
                            width: 44.w,
                            height: 40.h,
                            // "location".svg(),
                            Assets.icons.notifyActiveLogo,
                          ),
                          Positioned(
                            top: 0,
                            right: 10.w,
                            child: Container(
                              width: 10.w,
                              height: 10.h,
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
                        "ملاعب نادي القصيم الرياضي",
                        style: TextStyle(
                          color: isSeen!
                              ? LightThemeColors.notifytextSeen
                              : context.primaryColor,
                        ).s16.medium,
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
                          "الأربعاء 12-08-2024",
                          style: TextStyle(
                            color: LightThemeColors.black,
                          ).s12.light,

                          // fontSize: 12.sp,
                          // weight: FontWeight.w400,
                        ),
                        4.pw,
                        CustomText(
                          "09:30 مساء",
                          style: TextStyle(
                            color: LightThemeColors.black,
                          ).s12.light,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            16.ph,
            Container(
              width: 300,
              height: 40,
              child: CustomText(
                "هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي",
                style: TextStyle(
                  overflow: TextOverflow.clip,
                  color: isSeen!
                      ? LightThemeColors.subtitleNotify
                      : LightThemeColors.black,
                ).s13.light,

                // fontSize: 13.sp,
                // weight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
