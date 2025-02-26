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
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/matchdetails/cubit/matchdetails_cubit.dart';
import 'package:remontada/features/matchdetails/cubit/matchdetails_states.dart';
import 'package:remontada/features/matchdetails/presentaion/widgets/item_bottomshet.dart';
import 'package:remontada/features/matchdetails/presentaion/widgets/item_widget.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/edit_text_widget.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../../core/resources/gen/assets.gen.dart';

class MatchDetailsScreen extends StatefulWidget {
  const MatchDetailsScreen({
    super.key,
    this.mymatch = false,
    this.id,
    this.flagged,
    this.onreturn,
  });
  final bool? mymatch;
  final int? id;
  final bool? flagged;
  final VoidCallback? onreturn;

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  MatchModel matchModel = MatchModel();
  SubScribersModel subScribersModel = SubScribersModel();
  // bool matchowner = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MatchDetailsCubit()
        ..getMatchDetails(widget.id.toString())
        ..getSubscribers(widget.id.toString()),
      // ..getOwner(widget.id.toString()),
      child: BlocConsumer<MatchDetailsCubit, MatchDetailsState>(
        listener: (context, state) {
          if (state is MatchDetailsLoaded) {
            matchModel = state.matchDetails;
            subScribersModel = state.subScribers;
          }
          ;
          if (state is RefreshState) {
            MatchDetailsCubit.get(context).getMatchDetails(
              widget.id.toString(),
              isLoading: false,
            );
          }
          ;
          // if (state is SubScribersLoaded) subScribersModel = state.subScribers;
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
                onRefresh: () async {
                  await cubit.getMatchDetails(
                    widget.id.toString(),
                  );
                  await cubit.getSubscribers(
                    widget.id.toString(),
                  );
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
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
                            if (Utils.isSuperVisor == false)
                              if (matchModel.is_owner == true)
                                Positioned(
                                  left: 0,
                                  // bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Alerts.bottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(114),
                                            topRight: Radius.circular(36),
                                          ),
                                        ),
                                        context,
                                        child: SheetBodyAddPlayers(
                                          addPlayer: (name, phone) async {
                                            final response =
                                                await cubit.addsubscrubers(
                                              matchid:
                                                  matchModel.id.toString() ??
                                                      "",
                                              name: name,
                                              phone: phone,
                                            );
                                            // if (response == true) {
                                            //   Navigator.pop(context);
                                            // }
                                          },
                                        ),
                                      ).then((val) {
                                        cubit.getMatchDetails(
                                          widget.id.toString() ?? "",
                                        );
                                      });
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(
                                          .15,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                        ),
                                      ),
                                    ),
                                  ),
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
                        25.ph,
                        Container(
                          height: 30,
                          width: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              22,
                            ),
                            color: matchModel.isCCompleted == true
                                ? Colors.red.withOpacity(.3)
                                : Colors.green.withOpacity(
                                    .3,
                                  ),
                          ),
                          child: Center(
                            child: CustomText(
                              matchModel.isCCompleted == true
                                  ? "محجوز"
                                  : "متاح للحجز",
                              color: matchModel.isCCompleted == true
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
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
                            subtitle: matchModel.start ?? "",
                            icon: "clock",
                          ),
                          MatchDetailswidget(
                            title: LocaleKeys.match_long.tr(),
                            subtitle: matchModel.duration.toString() ?? "",
                            icon: "time",
                          ),
                          MatchDetailswidget(
                            title: LocaleKeys.price.tr(),
                            subtitle: matchModel.price ?? "",
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
                                    // CustomText(
                                    //   "${subScribersModel.subscribers?.length}",
                                    //   // "13",
                                    //   fontSize: 14,
                                    //   weight: FontWeight.w400,
                                    //   color: LightThemeColors.black,
                                    // ),
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
                                    final subscribers =
                                        (Utils.isSuperVisor == false)
                                            ? await cubit.getSubscribers(
                                                widget.id.toString(),
                                                type: matchModel.type ?? "")
                                            : null;
                                    if (subscribers != null) {
                                      subScribersModel = subscribers;
                                    }
                                    if (Utils.token != "") {
                                      Utils.isSuperVisor == true
                                          ? Navigator.pushNamed(
                                              context,
                                              Routes.PlayersScreenSupervisor,
                                              arguments:
                                                  matchModel.id.toString(),
                                            )
                                          : showPlayersheet(
                                              matchmodel: matchModel,
                                              context,
                                              subscribers: subScribersModel,
                                            );
                                    } else {
                                      Alerts.bottomSheet(context,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 25),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ButtonWidget(
                                                    onTap: () =>
                                                        Navigator.pushNamed(
                                                      context,
                                                      Routes.LoginScreen,
                                                    ),
                                                    child: CustomText(
                                                      weight: FontWeight.w600,
                                                      fontSize: 16,
                                                      "تسجيل الدخول",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                15.pw,
                                                Expanded(
                                                  child: ButtonWidget(
                                                    onTap: () =>
                                                        Navigator.pushNamed(
                                                      context,
                                                      Routes.RegisterScreen,
                                                    ),
                                                    child: CustomText(
                                                      weight: FontWeight.w600,
                                                      fontSize: 16,
                                                      " انشاء حساب",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ));
                                    }
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
                        if (Utils.isSuperVisor == false)
                          if (matchModel.isCCompleted == false)
                            matchModel.type == "group"
                                ? ButtonWidget(
                                    onTap: () => cubit.subScribe(
                                      matchModel.id ?? 0,
                                    ),
                                    radius: 33,
                                    title: "حجز بالكامل",
                                  )
                                : matchModel.isPending == true
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            align: TextAlign.center,
                                            "inWainitingList".tr(),
                                            weight: FontWeight.w500,
                                            color: Colors.red,
                                            fontSize: 16,
                                          ),
                                          20.ph,
                                          ButtonWidget(
                                              buttonColor: LightThemeColors
                                                  .warningButton,
                                              height: 65,
                                              // width: 342,
                                              fontweight: FontWeight.bold,
                                              radius: 33,
                                              textColor: context.background,
                                              child: Row(
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
                                              ),
                                              onTap: () async {
                                                // widget.onreturn?.call();

                                                final response =
                                                    await cubit.cancel(
                                                  widget.id.toString(),
                                                );
                                                if (mounted && response == true)
                                                  Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    Routes.LayoutScreen,
                                                  );
                                              })
                                        ],
                                      )
                                    : subScribersModel.isMymatch != null
                                        ? (matchModel.flag == false &&
                                                Utils.token.isNotEmpty)
                                            ? ButtonWidget(
                                                buttonColor:
                                                    cubit.isMymatch ?? false
                                                        ? LightThemeColors
                                                            .warningButton
                                                        : context.primaryColor,
                                                onTap: subScribersModel
                                                            .isMymatch ??
                                                        false
                                                    ? () async {
                                                        // widget.onreturn?.call();

                                                        final response =
                                                            await cubit.cancel(
                                                          widget.id.toString(),
                                                        );
                                                        if (mounted &&
                                                            response == true)
                                                          Navigator
                                                              .pushReplacementNamed(
                                                            context,
                                                            Routes.LayoutScreen,
                                                          );
                                                      }
                                                    : () async {
                                                        await showConfirmationSheet(
                                                          isCompleted:
                                                              matchModel
                                                                  .isCCompleted,
                                                          context,
                                                          () async {
                                                            final response =
                                                                await cubit
                                                                    .subScribe(
                                                                        widget.id ??
                                                                            0);
                                                            if (response ==
                                                                true) {
                                                              Navigator.pop(
                                                                context,
                                                                widget.onreturn,
                                                              );
                                                              showSuccessSheet(
                                                                context,
                                                                widget.id,
                                                                ontap: () {
                                                                  MatchDetailsCubit
                                                                          .get(
                                                                              context)
                                                                      .getMatchDetails(
                                                                    widget.id
                                                                        .toString(),
                                                                  );
                                                                  MatchDetailsCubit
                                                                          .get(
                                                                              context)
                                                                      .getSubscribers(
                                                                    widget.id
                                                                        .toString(),
                                                                  )(
                                                                    widget.id
                                                                        .toString(),
                                                                  );
                                                                },
                                                              );
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
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            color: context
                                                                .background,
                                                            Assets.icons.flag,
                                                          ),
                                                          9.pw,
                                                          CustomText(
                                                            LocaleKeys
                                                                .apology_take_part
                                                                .tr(),
                                                            fontSize: 16,
                                                            weight:
                                                                FontWeight.bold,
                                                            color: context
                                                                .background,
                                                          ),
                                                        ],
                                                      )
                                                    : CustomText(
                                                        matchModel.isCCompleted ??
                                                                false
                                                            ? "joinWaiting".tr()
                                                            : "SubscribeNow"
                                                                .tr(),
                                                        fontSize: 19,
                                                        weight: FontWeight.bold,
                                                        color:
                                                            context.background,
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

showConfirmationSheet(BuildContext context, VoidCallback confirm,
    {bool? isCompleted}) {
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
            isCompleted ?? false
                ? "هل تريد وضعك في قائمة الانتظار في حالة اعتذر احد المشتركين"
                : LocaleKeys.subscribe_confirmation_desciption.tr(),
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

showSuccessSheet(BuildContext context, int? id, {VoidCallback? ontap}) {
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
  ).then((val) {
    ontap?.call();
  });
}

class SheetBodyAddPlayers extends StatefulWidget {
  const SheetBodyAddPlayers({
    super.key,
    this.addPlayer,
    this.subscribe,
  });
  final Function(String? name, String? phone)? addPlayer;
  final VoidCallback? subscribe;
  @override
  State<SheetBodyAddPlayers> createState() => _SheetBodyAddPlayersState();
}

class _SheetBodyAddPlayersState extends State<SheetBodyAddPlayers> {
  List<String> names = [];
  TextEditingController? name = TextEditingController();
  TextEditingController? phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.only(
          right: 5,
          left: 5,
          top: 20,
          bottom: 24,
        ),
        decoration: BoxDecoration(
          // color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(114),
            topRight: Radius.circular(36),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // SvgPicture.asset(
                //   width: 40,
                //   height: 40,
                //   "playground_button".svg(),
                // ),
                14.36.pw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      // style: TextStyle().s16.heavy,
                      fontSize: 17,
                      "تأكيد حجز مباراة بالكامل",
                      color: LightThemeColors.primary,
                      weight: FontWeight.w800,
                    ),
                    CustomText(
                      fontSize: 14,
                      "قم بإعادة اللاعبين المشتركين",
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
                  flex: 2,
                  child: TextFormFieldWidget(
                    contentPadding: EdgeInsetsDirectional.zero,
                    type: TextInputType.name,
                    controller: name,
                    hintText: "ادخل اسم اللاعب",
                    hintSize: 12,
                    // suffixIcon: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Container(
                    //       width: 45,
                    //       height: 45,
                    //       decoration: BoxDecoration(
                    //         color: Colors.green,
                    //         shape: BoxShape.circle,
                    //       ),
                    //       child: Center(
                    //         child: Icon(
                    //           color: Colors.white,
                    //           Icons.add,
                    //         ),
                    //       ),
                    //     ),
                    //     20.pw,
                    //   ],
                    // ),
                    borderRadius: 33,
                    activeBorderColor: LightThemeColors.primary,
                  ),
                ),
                12.pw,
                Expanded(
                  flex: 2,
                  child: TextFormFieldWidget(
                    prefixIcon: null,
                    controller: phone,
                    contentPadding: EdgeInsetsDirectional.zero,
                    hintSize: 12,
                    type: TextInputType.phone,
                    hintText: "05xxxxxxxx",
                    // suffixIcon: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [

                    //     20.pw,
                    //   ],
                    // ),
                    borderRadius: 33,
                    activeBorderColor: LightThemeColors.primary,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final res = await widget.addPlayer?.call(
                        phone?.text,
                        name?.text,
                      );
                      name?.clear();
                      phone?.clear();

                      if (res == true) {
                        names.add(
                          name?.text ?? "",
                        );

                        setState(() {});
                      }
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          color: Colors.white,
                          Icons.add,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            28.ph,
            if (names.isNotEmpty == true) ...[
              CustomText(""),
              SizedBox(
                height: 200,
                child: GridView.builder(
                  itemCount: names.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 9 / 3
                      // mainAxisSpacing: 2,
                      // crossAxisSpacing: 2,
                      ),
                  itemBuilder: (context, index) => Container(
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              fit: BoxFit.fill,
                              "profile_image".png(),
                            ),
                          ),
                        ),
                        10.pw,
                        CustomText(
                          names[index],
                          fontSize: 14,
                          weight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 3,
            //       child: ButtonWidget(
            //         onTap: () {
            //           // widget.onsubmit!(id);
            //           Navigator.pop(context);
            //         },
            //         height: 65,
            //         radius: 33,
            //         child: CustomText(
            //           LocaleKeys.confirmation_button.tr(),
            //           fontSize: 16,
            //           weight: FontWeight.bold,
            //           color: context.background,
            //         ),
            //       ),
            //     ),
            //     10.pw,
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
