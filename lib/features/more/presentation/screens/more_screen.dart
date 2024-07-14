import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/more/cubit/more_cubit.dart';
import 'package:remontada/features/more/cubit/more_states.dart';
import 'package:remontada/features/more/presentation/widgets/more_item.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoreCubit()..checkNotificationEnabled(),
      child: BlocConsumer<MoreCubit, MoreStates>(
        listener: (context, state) {},
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
              isLoading: state is CoachLoading,
              isError: state is CoachFailed,
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
                          Column(
                            children: List.generate(
                              titles.length,
                              (index) => MoreItem(
                                cubit: cubit,
                                logOut: () async {
                                  final res = await cubit.logOut();
                                  if (res == true) {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        Routes.LoginScreen, (route) => false);
                                  }
                                },
                                icon: icons[index],
                                title: titles[index],
                              ),
                            ),
                          ),
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
  Assets.icons.calling,
  Assets.icons.information,
  Assets.icons.share,
  Assets.icons.policy_privacy,
  Assets.icons.log_out
];
