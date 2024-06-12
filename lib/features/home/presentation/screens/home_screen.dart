import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/presentation/widgets/bottomsheet_item.dart';
import 'package:remontada/features/home/presentation/widgets/itemwidget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../shared/widgets/network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List dates = [
    "اليوم",
    "الثلاثاء 11-08-2024",
    "الثلاثاء 11-08-2024",
    "الثلاثاء 11-08-2024",
    "الثلاثاء 11-08-2024",
    "الثلاثاء 11-08-2024"
  ];
  List dates2 = [
    "غدا",
    "الثلاثاء 11-08-2024",
    "الثلاثاء 11-08-2024",
    "الثلاثاء 11-08-2024",
    "الثلاثاء 11-08-2024",
    "الثلاثاء 11-08-2024"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightThemeColors.scaffoldBackground,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
            ),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  54.84.ph,
                  SvgPicture.asset(
                    "logo".svg("icons"),
                    width: 90,
                    height: 60,
                    color: context.primaryColor,
                  ),
                  5.ph,
                  CustomText(
                    "مرحبا بك",
                    color: LightThemeColors.secondaryText,
                    fontSize: 14,
                    weight: FontWeight.w500,
                  ),
                  5.ph,
                  CustomText(
                    "اسم اللاعب",
                    color: LightThemeColors.surfaceSecondary,
                    fontSize: 16,
                    weight: FontWeight.w800,
                  ),
                  18.ph,
                  CarouselSlider(
                    items: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: NetworkImagesWidgets(
                            width: 400.w,
                            fit: BoxFit.fill,
                            "https://i.pinimg.com/originals/2f/6b/3a/2f6b3a4313981bad86ee1c9a9b79e399.jpg"),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: NetworkImagesWidgets(
                            width: 400.w,
                            fit: BoxFit.fill,
                            "https://i.pinimg.com/originals/b4/95/ba/b495bacd09c44beaf1f1189d25ad51f9.jpg"),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: NetworkImagesWidgets(
                            width: 400.w,
                            fit: BoxFit.fill,
                            "https://i.pinimg.com/originals/ae/5b/28/ae5b28d056c0f745a24ff67a16be4292.jpg"),
                      ),
                    ],
                    options: CarouselOptions(
                      // aspectRatio: 16 / 10,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                      autoPlayAnimationDuration: Duration(
                        seconds: 1,
                      ),
                      autoPlay: true,
                      height: 127,
                      viewportFraction: 1,
                    ),
                  ).paddingHorizontal(5),
                  18.ph,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              "المباريات المتاحة",
                              fontSize: 16.sp,
                              weight: FontWeight.w800,
                              color: context.primaryColor,
                            ),
                            3.ph,
                            CustomText(
                              "قم بالإنضمام إلى المباراة المناسبة لك الآن",
                              fontSize: 12.sp,
                              weight: FontWeight.w500,
                              color: LightThemeColors.secondaryText,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                showPlaygroungBottomSheet(context);
                              },
                              icon: SvgPicture.asset(
                                width: 40.w,
                                height: 40.h,
                                "playground_button".svg("icons"),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showClendersheet(context);
                              },
                              icon: SvgPicture.asset(
                                width: 40.w,
                                height: 40.h,
                                "cleander_button".svg("icons"),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ).paddingHorizontal(5),
                  18.ph,
                  Column(
                    children: List.generate(
                      4,
                      (index) => ItemWidget(),
                    ),
                  ),
                  140.ph,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  showPlaygroungBottomSheet(BuildContext context) {
    Alerts.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(114),
          topRight: Radius.circular(36),
        ),
      ),
      context,
      child: Container(
        padding: EdgeInsets.only(
          right: 5.w,
          left: 5.w,
          top: 50.h,
          bottom: 24.h,
        ),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  width: 40.w,
                  height: 40.h,
                  "playground_button".svg(),
                ),
                14.36.pw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      fontSize: 17.sp,
                      "فلترة المباريات حسب الملعب",
                      color: LightThemeColors.primary,
                      weight: FontWeight.w800,
                    ),
                    CustomText(
                      fontSize: 14.sp,
                      "قم بفلترة ظهور المباريات حسب الملاعب",
                      color: LightThemeColors.secondaryText,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
            42.ph,
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: List.generate(
                      3,
                      (index) => BottomSheetItem(
                            title: "ملاعب نادي القصيم الرياضي",
                          )),
                )),
                10.pw,
                Expanded(
                  child: Column(
                    children: List.generate(
                        3,
                        (index) => BottomSheetItem(
                              title: "ملاعب نادي القصيم الرياضي",
                            )),
                  ),
                ),
              ],
            ),
            28.ph,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ButtonWidget(
                    height: 65.h,
                    radius: 33,
                    title: "تأكيد الفلترة",
                    fontSize: 16,
                    fontweight: FontWeight.bold,
                  ),
                ),
                10.pw,
                Expanded(
                  flex: 2,
                  child: ButtonWidget(
                    buttonColor: LightThemeColors.secondbuttonBackground,
                    height: 65.h,
                    radius: 33.r,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          color: LightThemeColors.textSecondary,
                          size: 14.83.w,
                          Icons.refresh,
                        ),
                        6.pw,
                        CustomText(
                          color: LightThemeColors.textSecondary,
                          "استعادة",
                          fontSize: 14,
                          weight: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ).scrollable(),
    );
  }

  showClendersheet(BuildContext context) {
    Alerts.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(114),
          topRight: Radius.circular(36),
        ),
      ),
      context,
      child: Container(
        padding: EdgeInsets.only(
          right: 5.w,
          left: 5.w,
          top: 50.h,
          bottom: 24.h,
        ),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                      "فلترة المباريات حسب التاريخ",
                      color: LightThemeColors.primary,
                      weight: FontWeight.w800,
                    ),
                    CustomText(
                      fontSize: 14.sp,
                      "قم بفلترة ظهور المباريات حسب تاريخ المباراة",
                      color: LightThemeColors.secondaryText,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
            42.ph,
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: List.generate(
                    dates2.length,
                    (index) => BottomSheetItem(
                      title: dates2[index],
                    ),
                  ),
                )),
                10.pw,
                Expanded(
                  child: Column(
                    children: List.generate(
                      dates.length,
                      (index) => BottomSheetItem(
                        title: dates[index],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            28.ph,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ButtonWidget(
                    height: 65.h,
                    radius: 33,
                    title: "تأكيد الفلترة",
                    fontSize: 16,
                    fontweight: FontWeight.bold,
                  ),
                ),
                10.pw,
                Expanded(
                  flex: 2,
                  child: ButtonWidget(
                    buttonColor: LightThemeColors.secondbuttonBackground,
                    height: 65.h,
                    radius: 33.r,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          color: LightThemeColors.textSecondary,
                          size: 14.83.w,
                          Icons.refresh,
                        ),
                        6.pw,
                        CustomText(
                          color: LightThemeColors.textSecondary,
                          "استعادة",
                          fontSize: 14,
                          weight: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ).scrollable(),
    );
  }
}
