import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class MatchDetailswidget extends StatelessWidget {
  const MatchDetailswidget({
    super.key,
    this.icon,
    this.subtitle,
    this.title,
  });
  final String? title;
  final String? subtitle;
  final String? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.82.w,
      ),
      width: 341.w,
      height: 74.h,
      decoration: BoxDecoration(
        color: context.background,
        borderRadius: BorderRadius.circular(
          13,
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            color: LightThemeColors.black.withOpacity(.1),
            offset: Offset(0, 0),
            blurRadius: 30,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            (icon ?? "clock").svg(),
            width: 26.82,
            height: 26.82,
          ),
          7.36.pw,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                style: TextStyle(
                  color: LightThemeColors.black,
                ).s12.light,
                title ?? "ملعب المبارات",
                // fontSize: 12.sp,
                // weight: FontWeight.w400,
              ),
              Container(
                width: title == "لوكيشن الملعب" ? 130.w : 200.w,
                child: CustomText(
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: icon == "wallet"
                        ? LightThemeColors.pricecolor
                        : LightThemeColors.black,
                  ).s14.regular,

                  subtitle ?? "ملاعب نادي القصيم الرياضي",
                  // fontSize: icon == "location" ? 13.sp : 14.sp,
                  // weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (icon == "location")
            Row(
              children: [
                18.pw,
                Container(
                  height: 40.h,
                  width: 130.w,
                  decoration: BoxDecoration(
                    color: LightThemeColors.primary.withOpacity(.08),
                    borderRadius: BorderRadius.circular(
                      25,
                    ),
                  ),
                  child: Center(
                    child: CustomText(
                      "عرض اللوكيشن على الخريطة",
                      style: TextStyle(
                        color: context.primaryColor,
                      ).s10.regular,
                      // fontSize: 10,
                      // weight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    ).paddingBottom(7);
  }
}
