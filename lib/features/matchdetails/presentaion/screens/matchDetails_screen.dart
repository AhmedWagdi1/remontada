import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/matchdetails/cubit/matchdetails_cubit.dart';
import 'package:remontada/features/matchdetails/cubit/matchdetails_states.dart';
import 'package:remontada/features/matchdetails/presentaion/widgets/item_bottomshet.dart';
import 'package:remontada/features/matchdetails/presentaion/widgets/item_widget.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../../core/resources/gen/assets.gen.dart';

class MatchDetailsScreen extends StatefulWidget {
  const MatchDetailsScreen({
    super.key,
    this.mymatch = false,
    this.id,
    this.flagged,
  });
  final bool? mymatch;
  final int? id;
  final bool? flagged;

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  MatchModel matchModel = MatchModel();
  SubScribersModel subScribersModel = SubScribersModel();
  bool matchowner = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MatchDetailsCubit()
        ..getMatchDetails(widget.id.toString())
        ..getSubscribers(widget.id.toString()),
      child: BlocConsumer<MatchDetailsCubit, MatchDetailsState>(
        listener: (context, state) {
          if (state is MatchDetailsLoaded) matchModel = state.matchDetails;
          if (state is SubScribersLoaded) subScribersModel = state.subScribers;
        },
        builder: (context, state) {
          final cubit = MatchDetailsCubit.get(context);
          // subScribersModel = cubit.getSubscribers(widget.id.toString());
          return Scaffold(
            // appBar: CustomAppbar(
            //   title: "تفاصيل المباراة",
            // ),
            body: LoadingAndError(
              isLoading: state is MatchDetailsLoading,
              isError: state is MatchDetailsFailed,
              child: RefreshIndicator(
                onRefresh: () => cubit.getMatchDetails(
                  widget.id.toString(),
                ),
                child: SingleChildScrollView(
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
                        Column(children: [
                          MatchDetailswidget(
                            title: LocaleKeys.arena.tr(),
                            subtitle: matchModel.playGround,
                            icon: "arena",
                          ),
                          MatchDetailswidget(
                            lan: matchModel.lng,
                            lat: matchModel.lat,
                            title: LocaleKeys.location.tr(),
                            subtitle: matchModel.playGround,
                            icon: "location",
                          ),
                          MatchDetailswidget(
                            title: LocaleKeys.match_date.tr(),
                            subtitle: matchModel.date,
                            icon: "clender",
                          ),
                          MatchDetailswidget(
                            title: LocaleKeys.match_time.tr(),
                            subtitle: matchModel.start,
                            icon: "clock",
                          ),
                          MatchDetailswidget(
                            title: LocaleKeys.match_long.tr(),
                            subtitle: "ساعة ونص",
                            icon: "time",
                          ),
                          MatchDetailswidget(
                            title: LocaleKeys.price.tr(),
                            subtitle: matchModel.price,
                            icon: "wallet",
                          ),
                        ]),
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
                                      "${subScribersModel.subscribers?.length}",
                                      // "13",
                                      fontSize: 14,
                                      weight: FontWeight.w400,
                                      color: LightThemeColors.black,
                                    ),
                                    1.pw,
                                    CustomText(
                                      matchModel.subscribers ?? "",
                                      fontSize: 14,
                                      weight: FontWeight.w400,
                                      color: LightThemeColors.background,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ButtonWidget(
                                  onTap: () async {
                                    final subscribers = await cubit
                                        .getSubscribers(widget.id.toString());
                                    if (subscribers != null) {
                                      subScribersModel = subscribers;
                                    }
                                    showPlayersheet(
                                        matchmodel: matchModel,
                                        context,
                                        subscribers: subScribersModel);
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
                              matchModel.details ?? "",
                              fontSize: 14,
                              weight: FontWeight.w400,
                              color: LightThemeColors.secondaryText,
                            ),
                          ),
                        ),
                        28.ph,
                        cubit.isMymatch != null
                            ? (widget.flagged == false)
                                ? ButtonWidget(
                                    buttonColor: cubit.isMymatch ?? false
                                        ? LightThemeColors.warningButton
                                        : context.primaryColor,
                                    onTap: cubit.isMymatch ?? false
                                        ? () async {
                                            Navigator.pop(context);
                                            await cubit.cancel(
                                              widget.id.toString(),
                                            );
                                          }
                                        : () async {
                                            await showConfirmationSheet(
                                              context,
                                              () async {
                                                final response = await cubit
                                                    .subScribe(widget.id ?? 0);
                                                if (response == true) {
                                                  Navigator.pop(context);
                                                  showSuccessSheet(
                                                      context, widget.id);
                                                }
                                              },
                                              // cubit.subScribe(widget.id ?? 0),
                                            );
                                          },
                                    height: 65,
                                    // width: 342,
                                    fontweight: FontWeight.bold,
                                    radius: 33,
                                    textColor: context.background,
                                    child: cubit.isMymatch ?? false
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                color: context.background,
                                                Assets.icons.flag,
                                              ),
                                              9.pw,
                                              CustomText(
                                                LocaleKeys.apology_take_part
                                                    .tr(),
                                                fontSize: 16,
                                                weight: FontWeight.bold,
                                                color: context.background,
                                              ),
                                            ],
                                          )
                                        : CustomText(
                                            "SubscribeNow".tr(),
                                            fontSize: 19,
                                            weight: FontWeight.bold,
                                            color: context.background,
                                          ),
                                    // title: ,
                                  )
                                : SizedBox()
                            : CircularProgressIndicator(
                                color: LightThemeColors.primary,
                              ),
                        // : CircularProgressIndicator(
                        //     color: Colors.blue,
                        //   ),
                        26.ph,
                      ],
                    ),
                  ).paddingHorizontal(
                    18,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

showPlayersheet(BuildContext context,
    {SubScribersModel? subscribers, MatchModel? matchmodel}) {
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
      height: 400,
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
                        "${matchmodel?.constSub ?? 0} / ",
                        fontSize: 14,
                        weight: FontWeight.w400,
                        color: LightThemeColors.background,
                      ),
                      CustomText(
                        "${subscribers?.subscribers?.length ?? 0}",
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
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: subscribers?.subscribers?.length ?? 0,
              itemBuilder: (context, i) => PlayerBottomSheet(
                subscriber: subscribers?.subscribers?[i],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

showConfirmationSheet(
  BuildContext context,
  VoidCallback confirm,
) {
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
            onTap: confirm,
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

showSuccessSheet(
  BuildContext context,
  int? id,
) {
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
          30.ph,
          SvgPicture.asset("yellow_ball".svg()),
          10.ph,
          CustomText(
            "Subscribedone".tr(),
            fontSize: 16,
            color: context.primaryColor,
            weight: FontWeight.w700,
          ),
          3.ph,
          CustomText(
            "Subscribedone_des".tr(),
            fontSize: 14,
            color: LightThemeColors.textSecondary,
            weight: FontWeight.w500,
          ),
          35.ph,
          ButtonWidget(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, Routes.matchDetails,
                  arguments: MatchDetailsArgs(
                    id: id,
                    isMymatch: false,
                  ));
            },
            height: 65,
            radius: 33,
            buttonColor: context.primaryColor.withOpacity(.08),
            child: CustomText(
              LocaleKeys.match_details.tr(),
              fontSize: 18,
              weight: FontWeight.bold,
              color: context.primaryColor,
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
