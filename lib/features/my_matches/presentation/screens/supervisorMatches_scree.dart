import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/presentation/widgets/itemwidget.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_cubit.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_states.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../../core/resources/gen/assets.gen.dart';
import '../../domain/model/myMatches_Model.dart';

class SupervisormatchesScree extends StatefulWidget {
  const SupervisormatchesScree({super.key});

  @override
  State<SupervisormatchesScree> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<SupervisormatchesScree>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyMatchesCubit()..getMymatches(),
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          title: CustomText(
            "الفترات",
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
                "يمكنك التحكم بالمباريات التي قمت بإضافتها",
                color: LightThemeColors.secondaryText,
              ),
              40.ph,
              Expanded(
                child: MatchesSupervisorsBodyBody(),
              ),
              40.ph,
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            color: Colors.white,
            Icons.add,
          ),
          backgroundColor: LightThemeColors.primary,
          onPressed: () {
            Navigator.pushNamed(
              context,
              Routes.CreateMatchScreen,
              arguments: null,
            );
          },
        ),
        bottomNavigationBar: 100.ph,
      ),
    );
  }
}

class EmptySupervisorsMatchesBody extends StatelessWidget {
  const EmptySupervisorsMatchesBody({
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
                "لا توج فترات",
                fontSize: 16,
                weight: FontWeight.w500,
                color: LightThemeColors.secondaryText,
              ),
              4.ph,
              CustomText(
                "لم تقم باضافة اي فترات",
                fontSize: 16,
                weight: FontWeight.w500,
                color: LightThemeColors.secondaryText,
              ),
              30.ph,
              ButtonWidget(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.CreateMatchScreen,
                  );
                },
                width: 200,
                height: 65,
                radius: 33,
                // gradient: LightThemeColors.buttonColor,
                child: Row(
                  children: [
                    20.pw,
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    12.pw,
                    CustomText(
                      fontSize: 16,
                      "إضافة فترة جديدة",
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
          1.ph,
        ],
      ),
    );
  }
}

class MatchesSupervisorsBodyBody extends StatefulWidget {
  MatchesSupervisorsBodyBody({
    super.key,
  });
  @override
  State<MatchesSupervisorsBodyBody> createState() => _MatchesBodyState();
}

class _MatchesBodyState extends State<MatchesSupervisorsBodyBody>
    with AutomaticKeepAliveClientMixin {
  MyMatches myMatches = MyMatches();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MyMatchesCubit, MyMatchesState>(
      listener: (context, state) {
        if (state is MyMatchesLoaded) myMatches = state.mymatches;
        if (state is DeleteMatchSuccess) {
          MyMatchesCubit.get(context).getMymatches(
            isloading: false,
          );
        }
        ;
      },
      builder: (context, state) {
        final cubit = MyMatchesCubit.get(context);
        return RefreshIndicator(
          onRefresh: () async {
            await cubit.getMymatches();
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
                      delete: () {
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
                              right: 15,
                              left: 15,
                              top: 50,
                              bottom: 28,
                            ),
                            decoration: BoxDecoration(
                              color: context.background,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.delete,
                                  size: 32,
                                  color: Colors.red,
                                ),
                                11.ph,
                                CustomText(
                                  fontSize: 16,
                                  "حذف فترة",
                                  color: LightThemeColors.primary,
                                  weight: FontWeight.w800,
                                ),
                                CustomText(
                                  fontSize: 14,
                                  "هل أنت متأكد من أنك تريد حذف الفترة ؟",
                                  color: LightThemeColors.secondaryText,
                                  weight: FontWeight.w500,
                                ),
                                32.ph,
                                ButtonWidget(
                                  buttonColor: LightThemeColors.warningButton,
                                  height: 65,
                                  radius: 33,
                                  child: CustomText(
                                    "حذف",
                                    fontSize: 16,
                                    weight: FontWeight.bold,
                                    color: context.background,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    MyMatchesCubit.get(context).deletMatch(
                                      id: myMatches.matches?[index].id
                                          .toString(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      isSupervisor: true,
                      matchModel: myMatches.matches?[index],
                      ismymatch: true,
                    ),
                  )
                : EmptySupervisorsMatchesBody(),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
