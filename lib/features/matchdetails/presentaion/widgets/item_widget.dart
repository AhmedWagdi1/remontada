import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class MatchDetailswidget extends StatelessWidget {
  const MatchDetailswidget({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.lan,
    this.lat,
  });
  final String? lat;
  final String? lan;
  final String? icon;
  final String? title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 11,
        horizontal: 10.82,
      ),
      // width: 341,
      // height: 54,
      decoration: BoxDecoration(
        color: context.background,
        borderRadius: BorderRadius.circular(
          13,
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            color: LightThemeColors.black.withOpacity(.13),
            offset: Offset(0, 0),
            blurRadius: 30,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                (icon ?? "clock").svg(),
                width: 22.82,
                height: 22.82,
              ),
              7.36.pw,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    style: TextStyle(
                      color: LightThemeColors.black,
                    ).s14.light,
                    title ?? "ملعب المبارات",
                    // fontSize: 12.sp,
                    // weight: FontWeight.w400,
                  ),
                  Container(
                    width: title == "لوكيشن الملعب" ? 130 : 200,
                    child: CustomText(
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: icon == "wallet"
                            ? LightThemeColors.pricecolor
                            : LightThemeColors.black,
                      ).s16.bold,

                      subtitle ?? "ملاعب نادي القصيم الرياضي",
                      // fontSize: icon == "location" ? 13.sp : 14.sp,
                      // weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (icon == "location")
            Row(
              children: [
                20.pw,
                Container(
                  height: 40,
                  width: 155,
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
                      ).s12.regular,
                      // fontSize: 10,
                      // weight: FontWeight.w500,
                    ),
                  ),
                ).onTap(
                  () => Navigator.pushNamed(
                    context,
                    Routes.MapScreen,
                    arguments: PositionArgs(lan, lat),
                  ),
                ),
              ],
            )
        ],
      ),
    ).paddingBottom(7);
  }
}
