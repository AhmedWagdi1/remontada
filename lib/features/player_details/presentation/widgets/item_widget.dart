import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
                SvgPicture.asset(
                  (icon ?? "location").svg(),
                  width: 20.7.w,
                  height: 20.7.h,
                ),
                8.24.pw,
                CustomText(
                  title ?? "رقم الجوال",
                  fontSize: 14,
                  weight: FontWeight.w400,
                  color: LightThemeColors.secondhint,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: CustomText(
              subtitle ?? "+9665505024",
              fontSize: 16,
              weight: FontWeight.w500,
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    ).paddingBottom(13);
  }
}
