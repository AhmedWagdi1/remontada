import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class PlayerDetailsWidget extends StatelessWidget {
  const PlayerDetailsWidget({super.key, this.icon, this.subtitle, this.title});
  final String? icon;
  final String? title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 17.53.w, top: 17.h, bottom: 17.h),
      decoration: BoxDecoration(
        color: context.primaryColor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(
          25,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon.toSvg(
                  width: 20.7.w,
                  height: 20.7.h,
                  color: context.primaryColor,
                ),
                // SvgPicture.asset(
                //   (icon ?? "location").svg(),
                //
                // ),
                8.24.pw,
                CustomText(
                  style: TextStyle(
                    color: LightThemeColors.secondhint,
                  ).s14.regular,
                  title ?? "رقم الجوال",
                  // fontSize: 14,
                  // weight: FontWeight.w400,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: CustomText(
              style: TextStyle(
                color: context.primaryColor,
              ).s16.regular,
              subtitle ?? "+9665505024",
              // fontSize: 16,
              // weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).paddingBottom(13);
  }
}
