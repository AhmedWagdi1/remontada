import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/more/cubit/more_cubit.dart';
import 'package:remontada/features/more/cubit/more_states.dart';
import 'package:remontada/features/more/presentation/widgets/more_item.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../../core/resources/font_manager.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String coaching = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoreCubit()
        ..checkNotificationEnabled()
        ..getProfile(),
      child: BlocConsumer<MoreCubit, MoreStates>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            coaching = state.coaching ?? "";
          }
        },
        builder: (context, state) {
          final cubit = MoreCubit.get(context);
          return Scaffold(
            // appBar :  AppBar(
            //     leading: SizedBox(),
            //     title: CustomText(
            //       "الاشعارات",
            //       fontSize: 26.sp,
            //       weight: FontWeight.w800,
            //       color: context.primaryColor,
            //     ),
            //   ),
            body: LoadingAndError(
              isLoading: (state is ProfileLoad),
              isError: state is ProfileFailed,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Container(
                  //   width: 500,
                  //   height: 1000,
                  // ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      width: double.infinity,
                      height: 108,
                      child: Assets.images.topStack.image(
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          70.ph,
                          CustomText(
                            style: TextStyle(
                              color: context.primaryColor,
                            ).s26.heavy,
                            LocaleKeys.more_nav.tr(),
                            // fontSize: 26.sp,
                            // weight: FontWeight.w800,
                          ),
                          5.ph,
                          CustomText(
                            style: TextStyle(
                              color: LightThemeColors.secondaryText,
                            ).s16.regular,
                            LocaleKeys.more_subtitle.tr(),
                            // fontSize: 16.sp,
                            // weight: FontWeight.w500,
                          ),
                          26.ph,
                          Column(children: [
                            ...List.generate(
                              titles.length,
                              (index) => MoreItem(
                                cochtitle: coaching,
                                cubit: cubit,
                                logOut: () async {
                                  final res = await cubit.logOut();
                                  if (res == true) {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        Routes.LoginScreen, (route) => false);
                                    Alerts.snack(
                                      text: "تم تسجيل الخروج بنجاح",
                                      state: SnackState.success,
                                    );
                                  }
                                },
                                icon: icons[index],
                                title: titles[index],
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(
                            //     bottom: 10,
                            //   ),
                            //   child: Container(
                            //     padding: EdgeInsets.symmetric(
                            //       horizontal: 21,
                            //       // vertical: 10.h,
                            //     ),
                            //     // width: 341.w,
                            //     height: 54,
                            //     decoration: BoxDecoration(
                            //       color: context.background,
                            //       borderRadius: BorderRadius.circular(13),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           offset: Offset.zero,
                            //           blurRadius: 30,
                            //           color: LightThemeColors.black.withOpacity(
                            //             .1,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     child: Builder(builder: (context) {
                            //       return Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Row(
                            //             children: [
                            //               "location".svg().toSvg(
                            //                     color: context.primaryColor,
                            //                     width: 21,
                            //                     height: 21,
                            //                   ),
                            //               15.pw,
                            //               Column(
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.start,
                            //                 mainAxisSize: MainAxisSize.min,
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.center,
                            //                 children: [
                            //                   Row(
                            //                     children: [
                            //                       CustomText(
                            //                         "enableLocation".tr(),
                            //                         style: TextStyle(
                            //                           color:
                            //                               context.primaryColor,
                            //                         ).s14.bold,
                            //                       ),
                            //                     ],
                            //                   )
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //           CustomSwitchLocation(
                            //             cubit: cubit,
                            //           )
                            //         ],
                            //       );
                            //     }),
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () async {
                                showDeletesheet(context, () async {
                                  final res = await cubit.deleteAccount();
                                  if (res == true) {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        Routes.LoginScreen, (route) => false);
                                    Alerts.snack(
                                      text: "تم حذف حسابك بنجاح",
                                      state: SnackState.success,
                                    );
                                  }
                                });
                              },
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline,
                                          color: LightThemeColors.red,
                                          size: 21,
                                        ),
                                        15.pw,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              style: TextStyle(
                                                color: LightThemeColors.red,
                                              ).s14.bold,
                                              "حذف الحساب",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: null,
                                      icon: SvgPicture.asset(
                                        "forowrdButton".svg(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: 129.29,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

List titles = [
  LocaleKeys.profile.tr(),
  LocaleKeys.captain_request.tr(),
  LocaleKeys.notification.tr(),
  "enableLocation".tr(),
  LocaleKeys.contact_us.tr(),
  LocaleKeys.about.tr(),
  LocaleKeys.share.tr(),
  LocaleKeys.privacy_policy.tr(),
  LocaleKeys.logout.tr(),
];

List icons = [
  Assets.icons.name,
  Assets.icons.whistle,
  Assets.icons.notify,
  "location".svg(),
  Assets.icons.calling,
  Assets.icons.information,
  Assets.icons.share,
  Assets.icons.policy_privacy,
  Assets.icons.log_out
];
showDeletesheet(BuildContext context, VoidCallback deleteAcoount) {
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
            "هل تريد حذف الحساب",
            color: LightThemeColors.primary,
            weight: FontWeight.w800,
          ),
          CustomText(
            fontSize: 14,
            "هل انت متاكد من انك تريد حذف الحساب الخاص بك",
            color: LightThemeColors.secondaryText,
            weight: FontWeight.w500,
          ),
          32.ph,
          ButtonWidget(
            buttonColor: LightThemeColors.warningButton,
            height: 65,
            radius: 33,
            child: CustomText(
              "حذف الحساب",
              fontSize: 16,
              weight: FontWeight.bold,
              color: context.background,
            ),
            onTap: deleteAcoount,
          ),
        ],
      ),
    ),
  );
}
