import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/Router/Router.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10.h,
        right: 5.w,
        left: 5.w,
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: 21.h,
          bottom: 14.27.h,
          right: 15.82.w,
          left: 15.82.w,
        ),
        decoration: BoxDecoration(
          color: LightThemeColors.containerBackgrond,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              spreadRadius: -4,
              offset: Offset(0, 0),
              blurRadius: 30,
              color: LightThemeColors.black.withOpacity(.15),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        width: 16.82.h,
                        height: 16.82.w,
                        "clender".svg("icons"),
                      ),
                      6.36.pw,
                      Container(
                        width: 142,
                        child: CustomText(
                          overflow: TextOverflow.ellipsis,
                          color: context.primaryColor,
                          weight: FontWeight.w600,
                          "ملاعب نادي القصيم الرياضي",
                          fontSize: 16.sp,
                        ),
                      )
                    ],
                  ),
                  11.ph,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        width: 16.82.h,
                        height: 16.82.w,
                        "clender".svg("icons"),
                      ),
                      6.36.pw,
                      Container(
                        child: CustomText(
                          overflow: TextOverflow.ellipsis,
                          color: LightThemeColors.secondaryText,
                          weight: FontWeight.w400,
                          "الأربعاء 12-08-2024",
                          fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                  11.ph,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        width: 16.82.h,
                        height: 16.82.w,
                        "clock".svg("icons"),
                      ),
                      6.36.pw,
                      Container(
                        child: CustomText(
                          overflow: TextOverflow.ellipsis,
                          color: LightThemeColors.secondaryText,
                          weight: FontWeight.w400,
                          "09:30 مساء",
                          fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                  11.ph,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        width: 16.82.h,
                        height: 16.82.w,
                        "wallet".svg("icons"),
                      ),
                      6.36.pw,
                      Container(
                        child: CustomText(
                          overflow: TextOverflow.ellipsis,
                          color: LightThemeColors.pricecolor,
                          weight: FontWeight.w600,
                          "35 ر.س",
                          fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            31.pw,
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  9.ph,
                  ButtonWidget(
                    radius: 11.r,
                    width: 145.w,
                    height: 30.h,
                    buttonColor: LightThemeColors.surface,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          width: 12.54,
                          height: 12.54,
                          "wallet".svg("icons"),
                          color: context.background,
                        ),
                        2.87.pw,
                        CustomText(
                          "المشتركين",
                          fontSize: 9.sp,
                          weight: FontWeight.w400,
                          color: LightThemeColors.background,
                        ),
                        2.87.pw,
                        CustomText(
                          "20 / ",
                          fontSize: 9.sp,
                          weight: FontWeight.w400,
                          color: LightThemeColors.background,
                        ),
                        CustomText(
                          "13",
                          fontSize: 9.sp,
                          weight: FontWeight.w400,
                          color: LightThemeColors.black,
                        ),
                      ],
                    ),
                  ),
                  // ButtonWidget(
                  //   width: 110.w,
                  //   height: 22.h,
                  //   buttonColor: LightThemeColors.surface,
                  // ),
                  50.79.ph,
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.matchDetails,
                      );
                    },
                    icon: SvgPicture.asset(
                      width: 45.94,
                      height: 45.94,
                      "forowrdButton".svg("icons"),
                    ),
                  ),

                  14.27.ph,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
