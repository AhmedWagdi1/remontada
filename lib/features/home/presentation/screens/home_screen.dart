import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/cubit/home_cubit.dart';
import 'package:remontada/features/home/cubit/home_states.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/home/presentation/widgets/custom_dots.dart';
import 'package:remontada/features/home/presentation/widgets/group_body.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/network_image.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/utils/Locator.dart';
import '../../../../core/utils/utils.dart';
import '../../../auth/domain/model/auth_model.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../widgets/clander_bottomsheet_body.dart';
import '../widgets/homebody.dart';
import 'supervisro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomeModel homeModel = HomeModel();
  PlayGrounds playground = PlayGrounds();
  Days _days = Days();
  List<Location>? areas = [];
  int index = 0;
  List<int> ids = [];
  int? areaId;
  List<String> dates = [];
  TabController? controller;
  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    controller = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
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
            child: Utils.isSuperVisor == true
                ? SuperVisorScreen()
                : Scaffold(
                    backgroundColor: Colors.transparent,
                    body: RefreshIndicator(
                      onRefresh: () async {
                        ids = [];
                        dates = [];
                        controller?.index == 0
                            ? await cubit.getHomeData(playgrounds: [], data: [])
                            : await cubit
                                .getGroupeMatches(playgrounds: [], data: []);
                      },
                      child: CustomScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        slivers: [
                          54.84.ph.SliverBox,
                          SvgPicture.asset(
                            Assets.icons.logo,
                            width: 100,
                            height: 70,
                            color: context.primaryColor,
                          ).SliverBox,
                          5.ph.SliverBox,
                          CustomText(
                            align: TextAlign.center,
                            style: TextStyle(
                              color: LightThemeColors.secondaryText,
                            ).s16.regular,
                            LocaleKeys.hello.tr(),

                            // fontSize: 16.sp,
                            // weight: FontWeight.w500,
                          ).SliverBox,
                          5.ph.SliverBox,
                          CustomText(
                            align: TextAlign.center,
                            style: TextStyle(
                              color: LightThemeColors.surfaceSecondary,
                            ).s18.heavy,
                            Utils.user.user?.name ?? "",
                            // fontSize: 18.sp,
                            // weight: FontWeight.w800,
                          ).SliverBox,
                          18.ph.SliverBox,
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              if (Utils.isSuperVisor == false)
                                CarouselSlider(
                                  items: List.generate(
                                    homeModel.slider?.length ?? 0,
                                    (index) => ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (homeModel.slider?[index].link !=
                                                  "" &&
                                              homeModel.slider?[index].link !=
                                                  null)
                                            Navigator.pushNamed(
                                                context, Routes.webPage,
                                                arguments: homeModel
                                                        .slider?[index].link ??
                                                    "");
                                        },
                                        child: NetworkImagesWidgets(
                                          homeModel.slider?[index].image ?? "",
                                          width: 400,
                                          fit: BoxFit.fill,
                                        ),
                                        //  Image.asset(
                                        //   "slider".png(),
                                        // ),
                                        // SvgPicture.network(
                                        //   // height: 150.h,
                                        //   // homeModel.slider?[index].image ??
                                        //   "https://match.almasader.net/storage/2/Group-175261.svg",
                                        //   width: 400,
                                        //   fit: BoxFit.fill,
                                        //   // images[index],
                                        // ),
                                      ),
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
                              if (Utils.isSuperVisor == false)
                                Positioned(
                                  bottom: 30,
                                  child: CustomSliderDots(
                                    length: homeModel.slider?.length ?? 0,
                                    indexItem: index,
                                  ),
                                ),
                            ],
                          ).SliverBox,
                          18.ph.SliverBox,
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
                                flex: 3,
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
                                            playground = playgrounds
                                              ..playgrounds = playgrounds
                                                  .playgrounds
                                                  ?.map((e) {
                                                return e
                                                  ..isActive =
                                                      ids.contains(e.id);
                                              }).toList();

                                          // print(ids);
                                          // playground.playgrounds
                                          //     ?.forEach((element) {
                                          //   print(element.isActive);
                                          //   // print(ids.contains(element.id));
                                          // });

                                          showSheet(
                                            SheetType.playground,
                                            context,
                                            (date, id, j) async {
                                              this.dates = date ?? [];
                                              this.ids = id ?? [];
                                              return controller?.index == 0
                                                  ? await cubit.getHomeData(
                                                      playgrounds: id,
                                                      data: [],
                                                    )
                                                  : cubit.getGroupeMatches(
                                                      playgrounds: id,
                                                      data: [],
                                                    );
                                            },
                                            this.playground,
                                            _days,
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
                                          if (days != null)
                                            _days = days
                                              ..days = days.days?.map((e) {
                                                return e
                                                  ..isActive =
                                                      dates.contains(e.date);
                                              }).toList();
                                          showSheet(
                                            SheetType.clander,
                                            context,
                                            (dates, id, l) async {
                                              this.ids = id ?? [];
                                              this.dates = dates ?? [];
                                              await controller?.index == 0
                                                  ? cubit.getHomeData(
                                                      data: dates,
                                                      playgrounds: [],
                                                    )
                                                  : cubit.getGroupeMatches(
                                                      data: dates,
                                                      playgrounds: [],
                                                    );
                                            },
                                            playground,
                                            _days,
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          width: 40,
                                          height: 40,
                                          "cleander_button".svg("icons"),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        // padding: EdgeInsets.
                                        // zero,
                                        onPressed: () async {
                                          final res =
                                              (await locator<AuthRepository>()
                                                      .getArreasRequest(
                                            loading: true,
                                          ))
                                                  ?.areas;
                                          if (res != null) {
                                            areas = res;
                                            areas = areas
                                              ?..map((e) {
                                                return e
                                                  ..isActive = e.id == areaId;
                                              }).toList();
                                            showSheet(
                                              SheetType.area,
                                              context,
                                              (dates, ids, areaId) async {
                                                this.areaId = areaId;

                                                areas = areas
                                                  ?..map((e) {
                                                    return e
                                                      ..isActive =
                                                          e.id == areaId;
                                                  }).toList();

                                                await controller?.index == 0
                                                    ? cubit.getHomeData(
                                                        data: dates,
                                                        playgrounds: [],
                                                        areaId: areaId)
                                                    : cubit.getGroupeMatches(
                                                        data: dates,
                                                        playgrounds: [],
                                                        areaId: areaId);
                                              },
                                              playground,
                                              _days,
                                              areas: areas,
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          Icons.location_city_outlined,
                                          color: LightThemeColors.secondary,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ).paddingLeft(5).paddingRight(20).SliverBox,
                          18.ph.SliverBox,
                          TabBar(
                            controller: controller,
                            labelPadding: EdgeInsets.symmetric(horizontal: 44),
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            indicatorColor: Colors.black,
                            dividerColor: Colors.transparent,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(33),
                              color: context.primaryColor,
                            ),
                            tabAlignment: TabAlignment.center,
                            physics: const NeverScrollableScrollPhysics(),
                            isScrollable: false,
                            onTap: (value) => setState(() {}),
                            tabs: [
                              Tab(
                                child: CustomText(
                                 "مباريات فردية" ,// 'current_matches'.tr(),
                                  fontSize: 14,
                                  weight: FontWeight.w500,
                                  align: TextAlign.center,
                                  color: controller?.index == 0
                                      ? Colors.white
                                      : context.primaryColor,
                                ),
                              ),
                              Tab(
                                child: CustomText(
                                 "مباريات جماعية", // 'finished_matches'.tr(),
                                  fontSize: 14,
                                  weight: FontWeight.w500,
                                  align: TextAlign.center,
                                  color: controller?.index == 1
                                      ? Colors.white
                                      : context.primaryColor,
                                ),
                              ),
                            ],
                          ).SliverBox,
                          20.ph.SliverBox,
                          SliverFillRemaining(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: controller,
                              children: [
                                Homebody(
                                  playgroundId: ids,
                                  data: dates,
                                  areaId: areaId,
                                ),
                                GroupBody(
                                  playgroundId: ids,
                                  data: dates,
                                  areaId: areaId,
                                ),
                              ],
                            ),
                          ),
                          129.29.ph.SliverBox,
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  showSheet(
    SheetType type,
    BuildContext context,
    Function(List<String>? dates, List<int>? playgroundId, int? areaId)?
        onsubmit,
    PlayGrounds? playground,
    Days? days, {
    List<Location>? areas,
  }) {
    Alerts.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(114),
          topRight: Radius.circular(36),
        ),
      ),
      context,
      child: ClanderBottomsheet(
        playground: playground,
        type: type,
        onsubmit: onsubmit,
        days: days,
        areas: areas,
      ),
    );
  }

  // showPlaygroungBottomSheet(
  //   BuildContext context,
  //   PlayGrounds playground,
  //   Function(List<String>? dates, List<int>? playgroundId)? onsubmit,
  // ) {
  //   Alerts.bottomSheet(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(114),
  //         topRight: Radius.circular(36),
  //       ),
  //     ),
  //     context,
  //     child: ClanderBottomsheet(
  //       type: SheetType.playground,
  //       onsubmit: onsubmit,
  //       playground: playground,
  //     ),
  //   );
  // }
}
