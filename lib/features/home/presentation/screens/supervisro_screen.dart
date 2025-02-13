import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/auth/domain/model/auth_model.dart';
import 'package:remontada/features/home/cubit/home_cubit.dart';
import 'package:remontada/features/home/cubit/home_states.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/home/presentation/widgets/clander_bottomsheet_body.dart';
import 'package:remontada/features/home/presentation/widgets/mymatch_body.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../auth/domain/repository/auth_repository.dart';

class SuperVisorScreen extends StatefulWidget {
  const SuperVisorScreen({super.key});

  @override
  State<SuperVisorScreen> createState() => _SuperVisorScreenState();
}

class _SuperVisorScreenState extends State<SuperVisorScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabcontroller;
  HomeModel homeModel = HomeModel();
  PlayGrounds playground = PlayGrounds();
  Days _days = Days();
  List<Location>? areas = [];
  int index = 0;
  List<int> ids = [];
  int? areaId;
  List<String> dates = [];
  String type = "";
  @override
  void initState() {
    tabcontroller = TabController(length: 2, vsync: this);
    if (tabcontroller?.index == 0) {
      type = "single";
    } else {
      type = "group";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                ids = [];
                dates = [];
                areaId = null;
                await cubit.getMymatches(playgrounds: [], data: []);
                setState(() {});
                // await cubit.();
              },
              child: Column(
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
                    align: TextAlign.center,
                    style: TextStyle(
                      color: LightThemeColors.secondaryText,
                    ).s16.regular,
                    LocaleKeys.hello.tr(),

                    // fontSize: 16.sp,
                    // weight: FontWeight.w500,
                  ),
                  5.ph,
                  CustomText(
                    align: TextAlign.center,
                    style: TextStyle(
                      color: LightThemeColors.surfaceSecondary,
                    ).s18.heavy,
                    Utils.user.user?.name ?? "",
                    // fontSize: 18.sp,
                    // weight: FontWeight.w800,
                  ),
                  18.ph,
                  TabBar(
                    controller: tabcontroller,
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
                    onTap: (value) {
                      if (tabcontroller?.index == 0) {
                        type = "single";
                      } else {
                        type = "group";
                      }
                      setState(() {});
                    },
                    tabs: [
                      Tab(
                        child: CustomText(
                          'مباريات الافراد',
                          fontSize: 14,
                          weight: FontWeight.w500,
                          align: TextAlign.center,
                          color: tabcontroller?.index == 0
                              ? Colors.white
                              : context.primaryColor,
                        ),
                      ),
                      Tab(
                        child: CustomText(
                          'مباريات المجموعات',
                          fontSize: 14,
                          weight: FontWeight.w500,
                          align: TextAlign.center,
                          color: tabcontroller?.index == 1
                              ? Colors.white
                              : context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  20.ph,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      ..playgrounds =
                                          playgrounds.playgrounds?.map((e) {
                                        return e..isActive = ids.contains(e.id);
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
                                      return await cubit.getMymatches(
                                        type: type,
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
                                          ..isActive = dates.contains(e.date);
                                      }).toList();
                                  showSheet(
                                    SheetType.clander,
                                    context,
                                    (dates, id, l) async {
                                      this.ids = id ?? [];
                                      this.dates = dates ?? [];
                                      await cubit.getMymatches(
                                        type: type,
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
                                  final res = (await locator<AuthRepository>()
                                          .getArreasRequest(
                                    loading: true,
                                  ))
                                      ?.areas;
                                  if (res != null) {
                                    areas = res;
                                    areas = areas
                                      ?..map((e) {
                                        return e..isActive = e.id == areaId;
                                      }).toList();
                                    showSheet(
                                      SheetType.area,
                                      context,
                                      (dates, ids, areaId) async {
                                        this.areaId = areaId;

                                        areas = areas
                                          ?..map((e) {
                                            return e..isActive = e.id == areaId;
                                          }).toList();

                                        await cubit.getMymatches(
                                          type: type,
                                          data: dates,
                                          playgrounds: [],
                                          areaId: areaId,
                                        );
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
                  ).paddingLeft(5).paddingRight(20),
                  TabBarView(
                    controller: tabcontroller,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      HomeMatchBody(
                        playgrounds: ids,
                        data: dates,
                        areaId: areaId,
                        type: "single",
                      ),
                      HomeMatchBody(
                        playgrounds: ids,
                        data: dates,
                        areaId: areaId,
                        type: "groupe",
                      )
                    ],
                  ).expand(),
                  100.ph,
                ],
              ),
            ),
            // bottomNavigationBar:
          );
        },
      ),
    );
  }
}

showSheet(
  SheetType type,
  BuildContext context,
  Function(List<String>? dates, List<int>? playgroundId, int? areaId)? onsubmit,
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
