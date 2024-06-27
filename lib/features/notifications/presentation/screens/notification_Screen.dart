import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/notifications/presentation/widgets/widgets.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/app_strings/locale_keys.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool thereData = true;
  Widget getnonotifyBody() {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              70.ph,
              CustomText(
                LocaleKeys.notifications.tr(),
                fontSize: 26,
                weight: FontWeight.w800,
                color: context.primaryColor,
              ),
              5.ph,
              CustomText(
                fontSize: 16,
                weight: FontWeight.w500,
                LocaleKeys.notifications_sub.tr(),
                color: LightThemeColors.secondaryText,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.bell.image(),
              20.ph,
              CustomText(
                LocaleKeys.no_notify.tr(),
                fontSize: 16,
                weight: FontWeight.w500,
                color: LightThemeColors.secondaryText,
              ),
              4.ph,
              CustomText(
                LocaleKeys.having_nonotify.tr(),
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

  getnotifyBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            70.ph,
            CustomText(
              style: TextStyle(
                color: context.primaryColor,
              ).s26.heavy,
              LocaleKeys.notifications.tr(),
              // fontSize: 26.sp,
              // weight: FontWeight.w800,
            ),
            5.ph,
            CustomText(
              style: TextStyle(
                color: LightThemeColors.secondaryText,
              ).s16.medium,
              // fontSize: 14,
              // weight: FontWeight.w500,
              LocaleKeys.notifications_sub.tr(),
            ),
            27.ph,
            Column(
              children: List.generate(
                3,
                (index) => NotifyItem(),
              ),
            ),
            SizedBox(
              height: 129.29,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: SizedBox(),
      //   title: CustomText(
      //     "الاشعارات",
      //     fontSize: 26.sp,
      //     weight: FontWeight.w800,
      //     color: context.primaryColor,
      //   ),
      // ),
      body: thereData ? getnotifyBody() : getnonotifyBody(),
    );
  }
}
