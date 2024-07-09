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
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/utils/utils.dart';
import '../widgets/clander_bottomsheet_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeModel homeModel = HomeModel();
  playGrounds playground = playGrounds();
  Days _days = Days();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getHomeData(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeDataLoaded) homeModel = state.homeModel;
        },
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
                image: AssetImage('assets/images/about_stack.png'),
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: LoadingAndError(
                isLoading: state is HomeDataLoading,
                isError: state is HomeDataFailed,
                child: RefreshIndicator(
                  onRefresh: () async => await cubit.getHomeData(),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
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
                                enlargeStrategy: CenterPageEnlargeStrategy.zoom,
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
                                      onPressed: () async {
                                        final playgrounds =
                                            await cubit.getplayground();
                                        if (playgrounds != null)
                                          playground = playgrounds;
                                        showPlaygroungBottomSheet(
                                          context,
                                          playground,
                                          state,
                                          () async {
                                            await cubit.getplayground();
                                            // setState(() {});
                                          },
                                          (value) async =>
                                              await cubit.getHomeData(
                                            playground: value,
                                          ),
                                        );
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
                                      onPressed: () async {
                                        final days = await cubit.getclander();
                                        if (days != null) _days = days;
                                        showClendersheet(
                                          context,
                                          _days,
                                          refresh: () async {
                                            await cubit.getclander();
                                          },
                                          onSubmit: (value) async =>
                                              await cubit.getHomeData(
                                            date: value,
                                          ),
                                        );
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  showPlaygroungBottomSheet(
    BuildContext context,
    playGrounds playground,
    HomeState state,
    VoidCallback refresh,
    Function(int?) onSubmit,
  ) {
    Alerts.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(114),
          topRight: Radius.circular(36),
        ),
      ),
      context,
      child: BottomSheetItem(
        playground: playground,
        state: state,
        refresh: refresh,
        onsubmit: onSubmit,
      ),
    );
  }

  showClendersheet(
    BuildContext context,
    Days days, {
    VoidCallback? refresh,
    Function(String?)? onSubmit,
  }) {
    String date;
    Alerts.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(114),
          topRight: Radius.circular(36),
        ),
      ),
      context,
      child: ClanderBottomsheet(
        refresh: refresh,
        onsubmit: onSubmit,
        days: days,
      ),
    );
  }
}
