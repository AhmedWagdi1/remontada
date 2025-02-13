import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/home/presentation/widgets/itemwidget.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_cubit.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_states.dart';
import 'package:remontada/features/my_matches/presentation/screens/supervisorMatches_scree.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../../core/resources/gen/assets.gen.dart';
import '../../domain/model/myMatches_Model.dart';

class MyMatchesScreen extends StatefulWidget {
  const MyMatchesScreen({super.key});

  @override
  State<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Utils.isSuperVisor == true
        ? SupervisormatchesScree()
        : Scaffold(
            appBar: AppBar(
              leading: SizedBox(),
              title: CustomText(
                "مبارياتي",
                fontSize: 26,
                weight: FontWeight.w800,
                color: context.primaryColor,
              ),
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    fontSize: 14,
                    weight: FontWeight.w500,
                    LocaleKeys.my_matches_subtitles.tr(),
                    color: LightThemeColors.secondaryText,
                  ),
                  40.ph,
                  TabBar(
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
                          'current_matches'.tr(),
                          fontSize: 14,
                          weight: FontWeight.w500,
                          align: TextAlign.center,
                          color: DefaultTabController.of(context).index == 0
                              ? Colors.white
                              : context.primaryColor,
                        ),
                      ),
                      Tab(
                        child: CustomText(
                          'finished_matches'.tr(),
                          fontSize: 14,
                          weight: FontWeight.w500,
                          align: TextAlign.center,
                          color: DefaultTabController.of(context).index == 1
                              ? Colors.white
                              : context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        BlocProvider(
                            create: (context) =>
                                MyMatchesCubit()..getMymatches(isCurrent: true),
                            child: MatchesBody(
                              isCurrent: true,
                            )),
                        BlocProvider(
                            create: (context) => MyMatchesCubit()
                              ..getMymatches(isCurrent: false),
                            child: MatchesBody(
                              isCurrent: false,
                            ))
                      ]).expand()
                ],
              ),
            ),
          );
  }
}

class EmptyMatchesBody extends StatelessWidget {
  const EmptyMatchesBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.center,
        children: [
          // Column(
          //   children: [
          //     70.ph,
          //     CustomText(
          //       LocaleKeys.my_matches.tr(),
          //       fontSize: 28,
          //       weight: FontWeight.w800,
          //       color: context.primaryColor,
          //     ),
          //     5.ph,
          //     CustomText(
          //       fontSize: 16,
          //       weight: FontWeight.w500,
          //       LocaleKeys.my_matches_subtitles.tr(),
          //       color: LightThemeColors.secondaryText,
          //     ),
          //   ],
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.no_matches.image(
                width: 124.0,
                height: 90,
              ),
              20.ph,
              CustomText(
                LocaleKeys.no_matches.tr(),
                fontSize: 16,
                weight: FontWeight.w500,
                color: LightThemeColors.secondaryText,
              ),
              4.ph,
              CustomText(
                LocaleKeys.havnot_matches.tr(),
                fontSize: 16,
                weight: FontWeight.w500,
                color: LightThemeColors.secondaryText,
              ),
            ],
          ),
          1.ph,
        ],
      ),
    );
  }
}

class MatchesBody extends StatefulWidget {
  MatchesBody({
    super.key,
    required this.isCurrent,
  });
  final bool isCurrent;
  @override
  State<MatchesBody> createState() => _MatchesBodyState();
}

class _MatchesBodyState extends State<MatchesBody>
    with AutomaticKeepAliveClientMixin {
  MyMatches myMatches = MyMatches();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MyMatchesCubit, MyMatchesState>(
      listener: (context, state) {
        if (state is MyMatchesLoaded) myMatches = state.mymatches;
      },
      builder: (context, state) {
        final cubit = MyMatchesCubit.get(context);
        return RefreshIndicator(
          onRefresh: () async {
            await cubit.getMymatches(isCurrent: widget.isCurrent);
          },
          child: LoadingAndError(
            isLoading: state is MyMatchesLoading,
            isError: state is MyMatchesFailed,
            child: myMatches.matches?.isNotEmpty ?? false
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    itemCount: myMatches.matches?.length ?? 0,
                    itemBuilder: (context, index) => ItemWidget(
                      matchModel: myMatches.matches?[index],
                      ismymatch: true,
                    ),
                  )
                : EmptyMatchesBody(),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
