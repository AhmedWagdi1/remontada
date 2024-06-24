import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/Router/Router.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    this.ismymatch = false,
  });
  final bool? ismymatch;
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
              color: LightThemeColors.black.withOpacity(.13),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        width: 16.82.h,
                        height: 16.82.w,
                        Assets.icons.arena,
                      ),
                      6.36.pw,
                      Container(
                        width: 142,
                        child: CustomText(
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: LightThemeColors.black,
                          ).s16.bold,
                          // color: context.primaryColor,
                          // weight: FontWeight.w600,
                          "ملاعب نادي القصيم الرياضي",
                          // fontSize: 16.sp,
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
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: LightThemeColors.black,
                          ).s13.medium,
                          // overflow: TextOverflow.ellipsis,

                          // weight: FontWeight.w400,
                          "الأربعاء 12-08-2024",
                          // fontSize: 14.sp,
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
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: LightThemeColors.black,
                          ).s13.medium,
                          // overflow: TextOverflow.ellipsis,
                          // color: LightThemeColors.secondaryText,
                          // weight: FontWeight.w400,
                          "09:30 مساء",
                          // fontSize: 14.sp,
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
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: LightThemeColors.pricecolor,
                          ).s13.bold,
                          // weight: FontWeight.w600,
                          "35 ر.س",
                          // fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            31.pw,
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  9.ph,
                  ButtonWidget(
                    radius: 15.r,
                    width: 145.w,
                    height: 30.h,
                    buttonColor: LightThemeColors.surface,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          width: 14.54,
                          height: 14.54,
                          Assets.icons.tshirt,
                          color: context.background,
                        ),
                        2.87.pw,
                        CustomText(
                          style: TextStyle(
                            color: LightThemeColors.background,
                          ).s12.regular,
                          "المشتركين",
                          // fontSize: 12.sp,
                          // weight: FontWeight.w400,
                          // color: LightThemeColors.background,
                        ),
                        2.87.pw,
                        CustomText(
                          "20 / ",
                          fontSize: 12.sp,
                          // weight: FontWeight.w400,

                          style: TextStyle(
                            color: LightThemeColors.background,
                          ).s12.medium,
                        ),
                        CustomText(
                          "13",
                          // fontSize: 12.sp,
                          // weight: FontWeight.w400,
                          // color: LightThemeColors.black,
                          style: TextStyle(
                            color: LightThemeColors.black,
                          ).s12.medium,
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
                      Navigator.pushNamed(context, Routes.matchDetails,
                          arguments: ismymatch);
                    },
                    icon: SvgPicture.asset(
                      width: 45.94,
                      height: 45.94,
                      "forowrdButton".svg("icons"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
