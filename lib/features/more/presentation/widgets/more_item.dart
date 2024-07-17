import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/font_manager.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/core/utils/launcher.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/more/cubit/more_cubit.dart';
import 'package:remontada/features/more/cubit/more_states.dart';
import 'package:remontada/features/more/domain/contact_request.dart';
import 'package:remontada/features/more/presentation/widgets/customSwitch.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/services/alerts.dart';
import '../../domain/model/model.dart';

class MoreItem extends StatefulWidget {
  const MoreItem({
    super.key,
    this.icon,
    this.title,
    this.logOut,
    this.notificationActive,
    this.cubit,
  });
  final MoreCubit? cubit;
  final String? icon;
  final String? title;
  final VoidCallback? logOut;
  final bool? notificationActive;

  @override
  State<MoreItem> createState() => _MoreItemState();
}

class _MoreItemState extends State<MoreItem> {
  Widget cochwidget = SizedBox();
  Pages? _page;
  pressedItem(BuildContext context) async {
    if (widget.title == LocaleKeys.profile.tr()) {
      Navigator.pushNamed(
        context,
        Routes.profileDetails,
      );
    } else if (widget.title == LocaleKeys.captain_request.tr()) {
      sendCaptainrequestDialogue(context, () async {
        final res = await widget.cubit?.requestCoach();
        if (res != null)
          Alerts.snack(
            text: "request_sent".tr(),
            state: SnackState.success,
          );

        // Alerts.snack(text: "coaching_failed".tr(), state: SnackState.failed);
        Navigator.pop(context);
      });
    } else if (widget.title == LocaleKeys.contact_us.tr()) {
      Navigator.pushNamed(context, Routes.contactScreen,
          arguments: (ContactRequest request) async {
        final res = await widget.cubit?.contactRequest(request);
        if (res != null) {
          Alerts.snack(text: "request_sent".tr(), state: SnackState.success);
        }
      });
    } else if (widget.title == LocaleKeys.about.tr()) {
      final page = await widget.cubit?.getAbout();
      if (page != null) _page = page;
      Navigator.pushNamed(context, Routes.aboutscreen, arguments: _page);
    } else if (widget.title == LocaleKeys.privacy_policy.tr()) {
      final page = await widget.cubit?.getpolicy();
      if (page != null) _page = page;
      Navigator.pushNamed(context, Routes.privacypolicyScreen,
          arguments: _page);
    } else if (widget.title == LocaleKeys.logout.tr()) {
      showlogoutsheet(
        context,
        widget.logOut ?? () {},
      );
    } else if (widget.title == LocaleKeys.share.tr()) {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(
        "https://play.google.com/store/apps/details?id=com.remontada",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoreCubit(),
      child: BlocConsumer<MoreCubit, MoreStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = MoreCubit.get(context);
          return GestureDetector(
            onTap: () {
              pressedItem(context);
            },
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 21,
                  // vertical: 10.h,
                ),
                // width: 341.w,
                height: 54,
                decoration: BoxDecoration(
                  color: context.background,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset.zero,
                      blurRadius: 30,
                      color: LightThemeColors.black.withOpacity(
                        .1,
                      ),
                    ),
                  ],
                ),
                child: Builder(builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          widget.icon.toSvg(
                            color: widget.title == LocaleKeys.logout.tr()
                                ? LightThemeColors.red
                                : context.primaryColor,
                            width: 21,
                            height: 21,
                          ),
                          // SvgPicture.asset(
                          //   widget.icon ?? "location",
                          //   width: 25.w,
                          //   height: 25.h,
                          //   color: widget.title == "تسجيل الخروج"
                          //       ? LightThemeColors.red
                          //       : LightThemeColors.black,
                          // ),
                          15.pw,

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                style: TextStyle(
                                  color: widget.title == "تسجيل الخروج"
                                      ? LightThemeColors.red
                                      : LightThemeColors.black,
                                ).s14.bold,
                                widget.title ?? "الملف الشخصي",

                                // fontSize: 14,
                                // weight: FontWeight.w600,
                              ),
                              if ((state is CoachLoadedSuccess ||
                                      Utils.user.user?.coaching == "pending") &&
                                  widget.title ==
                                      LocaleKeys.captain_request.tr())
                                Row(
                                  children: [
                                    Container(
                                      width: 3.78,
                                      height: 4.06,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: LightThemeColors.red,
                                      ),
                                    ),
                                    3.pw,
                                    CustomText(
                                      "request_sent_waiting".tr(),
                                      color:
                                          LightThemeColors.red.withOpacity(.9),
                                      weight: FontWeight.w500,
                                      fontSize: FontSize.s12,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                      widget.title == "التحكم بالاشعارات"
                          ? CustomSwitchItem(
                              cubit: cubit,
                            )
                          : IconButton(
                              onPressed: () {
                                pressedItem(context);
                              },
                              icon: SvgPicture.asset(
                                "forowrdButton".svg(),
                              ),
                            ),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomSwitchItem extends StatefulWidget {
  const CustomSwitchItem({
    super.key,
    this.cubit,
  });
  final MoreCubit? cubit;

  @override
  State<CustomSwitchItem> createState() => _CustomSwitchItemState();
}

class _CustomSwitchItemState extends State<CustomSwitchItem>
    with WidgetsBindingObserver {
  bool isSwitched = false;
  getlocalnotificationPermission() async {
    bool? switched;
    switched = await widget.cubit?.checkNotificationEnabled();
    setState(() {
      isSwitched = switched ?? false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getlocalnotificationPermission();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getlocalnotificationPermission();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSwitch(
      value: isSwitched,
      onChanged: (val) {
        if (val != isSwitched) {
          LauncherHelper.openAppSettings();
        }

        setState(() {});
      },
    );
  }
}

sendCaptainrequestDialogue(BuildContext context, VoidCallback? requestCoach) {
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
        top: 25,
        bottom: 28,
      ),
      decoration: BoxDecoration(
        color: context.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            Assets.icons.dialoge_whistle,
            // width: 80.w,
            // height: 80.h,
          ),

          // SvgPicture.asset(
          //   width: 50.w,
          //   height: 50.h,
          //   "cleander_button".svg(),
          // ),
          11.ph,
          CustomText(
            fontSize: 16,
            LocaleKeys.captain_request.tr(),
            color: LightThemeColors.primary,
            weight: FontWeight.w800,
          ),
          CustomText(
            fontSize: 14,
            LocaleKeys.wanting_captain_request.tr(),
            color: LightThemeColors.secondaryText,
            weight: FontWeight.w500,
          ),
          32.ph,
          ButtonWidget(
            onTap: requestCoach,
            height: 65,
            radius: 33,
            child: CustomText(
              LocaleKeys.send_request.tr(),
              fontSize: 16,
              weight: FontWeight.bold,
              color: context.background,
            ),
          ),
        ],
      ),
    ),
  );
}

showlogoutsheet(BuildContext context, VoidCallback logOut) {
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
          Assets.icons.log_out.toSvg(
            width: 32.68,
            height: 32.68,
          ),
          11.ph,
          CustomText(
            fontSize: 16,
            LocaleKeys.logout.tr(),
            color: LightThemeColors.primary,
            weight: FontWeight.w800,
          ),
          CustomText(
            fontSize: 14,
            LocaleKeys.wanting_logout.tr(),
            color: LightThemeColors.secondaryText,
            weight: FontWeight.w500,
          ),
          32.ph,
          ButtonWidget(
            buttonColor: LightThemeColors.warningButton,
            height: 65,
            radius: 33,
            child: CustomText(
              LocaleKeys.logout.tr(),
              fontSize: 16,
              weight: FontWeight.bold,
              color: context.background,
            ),
            onTap: logOut,
          ),
        ],
      ),
    ),
  );
}
