import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      // height: 54,
      padding: EdgeInsets.only(right: 37.53, top: 17, bottom: 17),
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
                  icon ?? "",
                  height: 18.47,
                  width: 18.47,
                  color: context.primaryColor,
                ),
                10.pw,
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
