import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/cubit/home_cubit.dart';
import 'package:remontada/features/home/cubit/home_states.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/home/presentation/widgets/bottomsheet_item.dart';
import 'package:remontada/features/home/presentation/widgets/custom_dots.dart';
import 'package:remontada/features/home/presentation/widgets/itemwidget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeModel homeModel = HomeModel();
  int index = 0;
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
    return BlocProvider(
      create: (context) => HomeCubit()..getHomeData(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeDataLoaded) homeModel = state.homeModel;
        },
        builder: (context, state) {
          return Scaffold(
            body: LoadingAndError(
              isLoading: state is HomeDataLoading,
              isError: state is HomeDataFailed,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Transform.scale(
                      scale: 1,
                      child: Container(
                        // width: 375.w,
                        // height: 290,
                        child: Assets.images.aboutSstack.image(
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          54.84.ph,
                          SvgPicture.asset(
                            Assets.icons.logo,
                            width: 100,
                            height: 70,
                            color: context.primaryColor,
                          ),
                          5.ph,
                          CustomText(
                            style: TextStyle(
                              color: LightThemeColors.secondaryText,
                            ).s16.regular,
                            LocaleKeys.hello.tr(),

                            // fontSize: 16.sp,
                            // weight: FontWeight.w500,
                          ),
                          5.ph,
                          CustomText(
                            style: TextStyle(
                              color: LightThemeColors.surfaceSecondary,
                            ).s18.heavy,
                            Utils.user.user?.name ?? "",
                            // fontSize: 18.sp,
                            // weight: FontWeight.w800,
                          ),
                          18.ph,
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CarouselSlider(
                                items: List.generate(
                                  homeModel.slider?.length ?? 0,
                                  (index) => ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: SvgPicture.network(
                                        // height: 150.h,
                                        homeModel.slider?[index].image ?? "",
                                        width: 400.w,
                                        fit: BoxFit.fill,
                                      )
                                      // NetworkImagesWidgets(
                                      //   // height: 150.h,
                                      //   homeModel.slider?[index].image ?? "",
                                      //   width: 400.w,
                                      //   fit: BoxFit.fill,
                                      //   // images[index],
                                      // ),
                                      ),
                                ),
                                options: CarouselOptions(
                                  onPageChanged: (index, reason) {
                                    this.index = index;
                                    setState(() {});
                                  },
                                  enlargeCenterPage: true,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.zoom,
                                  autoPlayAnimationDuration: Duration(
                                    seconds: 1,
                                  ),
                                  autoPlay: true,
                                  height: 170,
                                  viewportFraction: 1,
                                ),
                              ).paddingHorizontal(5),
                              Positioned(
                                bottom: 30,
                                child: CustomSliderDots(
                                  length: homeModel.slider?.length ?? 0,
                                  indexItem: index,
                                ),
                              ),
                            ],
                          ),
                          18.ph,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      style: TextStyle(
                                        color: context.primaryColor,
                                      ).s16.heavy,
                                      LocaleKeys.available_matches.tr(),
                                      // fontSize: 16.sp,
                                      // weight: FontWeight.w800,
                                    ),
                                    3.ph,
                                    CustomText(
                                      style: TextStyle(
                                        color: LightThemeColors.secondaryText,
                                      ).s14.regular,
                                      LocaleKeys.home_describtion.tr(),
                                      // fontSize: 13.sp,
                                      // weight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        // padding: EdgeInsets.zero,
                                        onPressed: () {
                                          showPlaygroungBottomSheet(context);
                                        },
                                        icon: SvgPicture.asset(
                                          width: 40,
                                          height: 40,
                                          "playground_button".svg("icons"),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        // padding: EdgeInsets.zero,
                                        onPressed: () {
                                          showClendersheet(context);
                                        },
                                        icon: SvgPicture.asset(
                                          width: 40,
                                          height: 40,
                                          "cleander_button".svg("icons"),
                                        ),
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
                              homeModel.match?.length ?? 1,
                              (index) => ItemWidget(
                                matchModel: homeModel.match?[index],
                                ismymatch: false,
                              ),
                            ),
                          ),
                          140.ph,
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
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
          right: 5,
          left: 5,
          top: 20,
          bottom: 24,
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
                  width: 40,
                  height: 40,
                  "playground_button".svg(),
                ),
                14.36.pw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      // style: TextStyle().s16.heavy,
                      fontSize: 17,
                      LocaleKeys.match_filter_playground.tr(),
                      color: LightThemeColors.primary,
                      weight: FontWeight.w800,
                    ),
                    CustomText(
                      fontSize: 14,
                      LocaleKeys.match_filter_playground_description.tr(),
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
                    height: 65,
                    radius: 33,
                    child: CustomText(
                      LocaleKeys.confirmation_button.tr(),
                      fontSize: 16,
                      weight: FontWeight.bold,
                      color: context.background,
                    ),
                  ),
                ),
                10.pw,
                Expanded(
                  flex: 2,
                  child: ButtonWidget(
                    buttonColor: LightThemeColors.secondbuttonBackground,
                    height: 65,
                    radius: 33,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          color: LightThemeColors.textSecondary,
                          size: 14.83,
                          Icons.refresh,
                        ),
                        6.pw,
                        CustomText(
                          color: LightThemeColors.textSecondary,
                          LocaleKeys.refresh_button.tr(),
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
        // width: double.infinity,
        padding: EdgeInsets.only(
          right: 5,
          left: 5,
          top: 20,
          bottom: 24,
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
                  width: 40,
                  height: 40,
                  "cleander_button".svg(),
                ),
                14.36.pw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      fontSize: 17,
                      LocaleKeys.match_filter_clender.tr(),
                      color: LightThemeColors.primary,
                      weight: FontWeight.w800,
                    ),
                    CustomText(
                      fontSize: 14,
                      LocaleKeys.match_filter_playground_description.tr(),
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
                    height: 65,
                    radius: 33,
                    child: CustomText(
                      LocaleKeys.confirmation_button.tr(),
                      fontSize: 16,
                      weight: FontWeight.bold,
                      color: context.background,
                    ),
                  ),
                ),
                10.pw,
                Expanded(
                  flex: 2,
                  child: ButtonWidget(
                    buttonColor: LightThemeColors.secondbuttonBackground,
                    height: 65,
                    radius: 33,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          color: LightThemeColors.textSecondary,
                          size: 14.83,
                          Icons.refresh,
                        ),
                        6.pw,
                        CustomText(
                          color: LightThemeColors.textSecondary,
                          LocaleKeys.refresh_button.tr(),
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

List images = [
  "https://i.pinimg.com/originals/ae/5b/28/ae5b28d056c0f745a24ff67a16be4292.jpg",
  "https://i.pinimg.com/originals/b4/95/ba/b495bacd09c44beaf1f1189d25ad51f9.jpg",
  "https://i.pinimg.com/originals/2f/6b/3a/2f6b3a4313981bad86ee1c9a9b79e399.jpg",
];
