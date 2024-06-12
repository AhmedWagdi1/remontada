import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/matchdetails/presentaion/widgets/item_bottomshet.dart';
import 'package:remontada/features/matchdetails/presentaion/widgets/item_widget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customAppbar.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class MatchDetailsScreen extends StatefulWidget {
  const MatchDetailsScreen({super.key});

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "تفاصيل المباراة",
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              CustomText(
                "عرض لجميع تفاصيل المباراة",
                fontSize: 14.sp,
                weight: FontWeight.w500,
                color: LightThemeColors.secondaryText,
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
                  horizontal: 18.w,
                ),
                width: 342.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: LightThemeColors.surface,
                  borderRadius: BorderRadius.circular(25.r),
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
                            "wallet".svg("icons"),
                            color: context.background,
                          ),
                          5.87.pw,
                          CustomText(
                            "المشتركين",
                            fontSize: 14.sp,
                            weight: FontWeight.w400,
                            color: LightThemeColors.background,
                          ),
                          2.87.pw,
                          CustomText(
                            "20 / ",
                            fontSize: 14.sp,
                            weight: FontWeight.w400,
                            color: LightThemeColors.background,
                          ),
                          CustomText(
                            "13",
                            fontSize: 14.sp,
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
                        radius: 15.r,
                        height: 35.h,
                        width: 148.w,
                        buttonColor: context.background,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "عرض تفاصيل المشتركين",
                              color: context.primaryColor,
                              weight: FontWeight.w500,
                              fontSize: 13.sp,
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
                  "تفاصيل المباراة",
                  fontSize: 15,
                  weight: FontWeight.w600,
                  color: context.primaryColor,
                ),
              ),
              7.ph,
              Container(
                width: 342.w,
                height: 45.h,
                child: CustomText(
                  overflow: TextOverflow.clip,
                  "هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي",
                  fontSize: 13.sp,
                  weight: FontWeight.w400,
                  color: LightThemeColors.secondaryText,
                ),
              ),
              28.ph,
              ButtonWidget(
                onTap: () => showConfirmationSheet(context),
                height: 65,
                width: 342,
                fontweight: FontWeight.bold,
                radius: 33,
                textColor: context.background,
                title: "إشترك الان",
              ),
              26.ph,
            ],
          ),
        ).paddingHorizontal(
          18.w,
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
      height: 623.h,
      padding: EdgeInsets.only(
        right: 15.w,
        left: 15.w,
        top: 50.h,
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
                      width: 40.w,
                      height: 40.h,
                      "cleander_button".svg(),
                    ),
                    14.36.pw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          fontSize: 17.sp,
                          "قائمة المشتركين",
                          color: LightThemeColors.primary,
                          weight: FontWeight.w800,
                        ),
                        CustomText(
                          fontSize: 14.sp,
                          "قائمة اللاعبين المشتركيين بالمباراة",
                          color: LightThemeColors.secondaryText,
                          weight: FontWeight.w500,
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
                        fontSize: 14.sp,
                        weight: FontWeight.w400,
                        color: LightThemeColors.background,
                      ),
                      CustomText(
                        "13",
                        fontSize: 14.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      // width: ,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.ph,
          CustomText(
            "تاكيد الاشتراك",
            fontSize: 16,
            color: context.primaryColor,
            weight: FontWeight.w700,
          ),
          3.ph,
          CustomText(
            "هل أنت متأكد من الإشتراك والإنضمام إلى هذه المباراة ؟",
            fontSize: 14,
            color: LightThemeColors.textSecondary,
            weight: FontWeight.w500,
          ),
          35.ph,
          ButtonWidget(
            height: 65.h,
            radius: 33,
            title: "تاكيد",
            fontSize: 16,
            fontweight: FontWeight.bold,
          ),
          26.ph,
        ],
      ),
    ),
  );
}

List icons = [
  "clender",
  "location",
  "clender",
  "clock",
  "time",
  "wallet",
];
List titles = [
  "ملعب المباراة",
  "لوكيشن الملعب",
  "تاريخ المباراة",
  "توقيت المباراة",
  "مدة المباراة",
  "القطة",
];
List subtitles = [
  "ملاعب نادي القصيم الرياضي",
  "القصيم , نادي القصيم الرياضي",
  "الأربعاء 12-08-2024",
  "09:30 مساء",
  "ساعة ونصف",
  "35 ر.س",
];
