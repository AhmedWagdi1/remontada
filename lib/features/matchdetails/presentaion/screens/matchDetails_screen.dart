import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/matchdetails/presentaion/widgets/item_bottomshet.dart';
import 'package:remontada/features/matchdetails/presentaion/widgets/item_widget.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/resources/gen/assets.gen.dart';

class MatchDetailsScreen extends StatefulWidget {
  const MatchDetailsScreen({super.key, this.mymatch = false});
  final bool? mymatch;

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppbar(
      //   title: "تفاصيل المباراة",
      // ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              80.ph,
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: double.infinity,
                    // height: 40.h,
                  ),
                  Positioned(
                    // top: 0,
                    child: CustomText(
                      LocaleKeys.match_details.tr(),
                      style: TextStyle(
                        color: context.primaryColor,
                      ).s24.heavy,
                      // fontSize: 26,
                      // weight: FontWeight.bold,
                      // color: context.colorScheme.primary,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    // bottom: 0,
                    child: BackWidget(),
                  ),
                ],
              ),
              5.ph,
              CustomText(
                style: TextStyle(
                  color: LightThemeColors.secondaryText,
                ).s14.regular,
                LocaleKeys.match_details_subtitle.tr(),
                // fontSize: 14.sp,
                // weight: FontWeight.w500,
              ),
              31.ph,
              Column(
                children: List.generate(
                  titles.length,
                  (index) => MatchDetailswidget(
                    title: titles[index],
                    subtitle: subtitles[index],
                    icon: icons[index],
                  ),
                ),
              ),
              24.ph,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                // width: 350,
                height: 60,
                decoration: BoxDecoration(
                  color: LightThemeColors.surface,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            width: 20.54,
                            height: 20.54,
                            Assets.icons.tshirt,
                            color: context.background,
                          ),
                          5.87.pw,
                          CustomText(
                            LocaleKeys.subscribers.tr(),
                            fontSize: 14,
                            weight: FontWeight.w400,
                            color: LightThemeColors.background,
                          ),
                          2.87.pw,
                          CustomText(
                            "20 / ",
                            fontSize: 14,
                            weight: FontWeight.w400,
                            color: LightThemeColors.background,
                          ),
                          CustomText(
                            "13",
                            fontSize: 14,
                            weight: FontWeight.w400,
                            color: LightThemeColors.black,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ButtonWidget(
                        onTap: () {
                          showPlayersheet(context);
                        },
                        radius: 15,
                        height: 35,
                        width: 150,
                        buttonColor: context.background,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              LocaleKeys.subscribers_details.tr(),
                              color: context.primaryColor,
                              weight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            3.pw,
                            Icon(
                              size: 14,
                              Icons.arrow_forward,
                              color: context.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              16.ph,
              Align(
                alignment: AlignmentDirectional.topStart,
                child: CustomText(
                  LocaleKeys.match_details.tr(),
                  fontSize: 16,
                  weight: FontWeight.w600,
                  color: context.primaryColor,
                ),
              ),
              7.ph,
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Container(
                  // width: 342,
                  height: 45,
                  child: CustomText(
                    // align: TextAlign.start,
                    overflow: TextOverflow.clip,
                    "هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي",
                    fontSize: 14,
                    weight: FontWeight.w400,
                    color: LightThemeColors.secondaryText,
                  ),
                ),
              ),
              28.ph,
              ButtonWidget(
                buttonColor: widget.mymatch!
                    ? LightThemeColors.warningButton
                    : context.primaryColor,
                onTap: () => showConfirmationSheet(context),
                height: 65,
                // width: 342,
                fontweight: FontWeight.bold,
                radius: 33,
                textColor: context.background,
                child: widget.mymatch!
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            color: context.background,
                            Assets.icons.flag,
                          ),
                          9.pw,
                          CustomText(
                            LocaleKeys.apology_take_part.tr(),
                            fontSize: 16,
                            weight: FontWeight.bold,
                            color: context.background,
                          ),
                        ],
                      )
                    : CustomText(
                        LocaleKeys.confirmation_button.tr(),
                        fontSize: 19,
                        weight: FontWeight.bold,
                        color: context.background,
                      ),
                // title: ,
              ),
              26.ph,
            ],
          ),
        ).paddingHorizontal(
          18,
        ),
      ),
    );
  }
}

showPlayersheet(BuildContext context) {
  Alerts.bottomSheet(
    // height: 623.h,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(114),
        topRight: Radius.circular(36),
      ),
    ),
    context,
    child: Container(
      height: 623,
      padding: EdgeInsets.only(
        right: 18,
        left: 18,
        top: 50,
        // bottom: 24.h,
      ),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      color: context.primaryColor,
                      width: 40,
                      height: 40,
                      Assets.icons.tshirt,
                    ),
                    14.36.pw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          style: TextStyle(
                            color: LightThemeColors.primary,
                          ).s18.extrabold,
                          // fontSize: 17.sp,
                          LocaleKeys.subscribers_list.tr(),

                          // weight: FontWeight.w800,
                        ),
                        4.ph,
                        CustomText(
                          style: TextStyle(
                            color: LightThemeColors.secondaryText,
                          ).s14.regular,
                          // fontSize: 14.sp,
                          LocaleKeys.subscribers_list_sub.tr(),
                          //
                          // weight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: 79,
                  height: 46,
                  decoration: BoxDecoration(
                    color: LightThemeColors.surface,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        "20 / ",
                        fontSize: 14,
                        weight: FontWeight.w400,
                        color: LightThemeColors.background,
                      ),
                      CustomText(
                        "13",
                        fontSize: 14,
                        weight: FontWeight.w400,
                        color: LightThemeColors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          42.ph,
          Expanded(
            child: ListView(
              children: List.generate(
                15,
                (index) => PlayerBottomSheet(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

showConfirmationSheet(BuildContext context) {
  Alerts.bottomSheet(
    context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(114),
        topRight: Radius.circular(36),
      ),
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      // width: ,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.ph,
          CustomText(
            LocaleKeys.subscribe_confirmation.tr(),
            fontSize: 16,
            color: context.primaryColor,
            weight: FontWeight.w700,
          ),
          3.ph,
          CustomText(
            LocaleKeys.subscribe_confirmation_desciption.tr(),
            fontSize: 14,
            color: LightThemeColors.textSecondary,
            weight: FontWeight.w500,
          ),
          35.ph,
          ButtonWidget(
            height: 65,
            radius: 33,
            child: CustomText(
              LocaleKeys.confirm.tr(),
              fontSize: 18,
              weight: FontWeight.bold,
              color: context.background,
            ),
            // title: "تاكيد",
            // // fontSize: 16,
            // // fontweight: FontWeight.bold,
          ),
          26.ph,
        ],
      ),
    ),
  );
}

List icons = [
  "arena",
  "location",
  "clender",
  "clock",
  "time",
  "wallet",
];
List titles = [
  LocaleKeys.arena.tr(),
  LocaleKeys.location.tr(),
  LocaleKeys.match_date.tr(),
  LocaleKeys.match_time.tr(),
  LocaleKeys.match_long.tr(),
  LocaleKeys.price.tr(),
];
List subtitles = [
  "ملاعب نادي القصيم الرياضي",
  "القصيم , نادي القصيم الرياضي",
  "الأربعاء 12-08-2024",
  "09:30 مساء",
  "ساعة ونصف",
  "35 ر.س",
];
