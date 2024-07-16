import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/notifications/cubit/notifications_cubit.dart';
import 'package:remontada/features/notifications/cubit/notifications_states.dart';
import 'package:remontada/features/notifications/presentation/widgets/widgets.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../domain/model/notify_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool thereData = false;
  Widget getnonotifyBody() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotifyCubit()..addPageLisnter(),
      child: BlocConsumer<NotifyCubit, NotificationsState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = NotifyCubit.get(context);
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
            body: Column(
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

                // Column(
                //   children: List.generate(
                //     3,
                //     (index) => NotifyItem(),
                //   ),
                // ),

                Expanded(
                  child: PagedListView(
                    padding: const EdgeInsets.all(16),
                    pagingController: cubit.notificationController,
                    builderDelegate:
                        PagedChildBuilderDelegate<NotificationModel?>(
                      noItemsFoundIndicatorBuilder: (context) =>
                          getnonotifyBody(),
                      itemBuilder: (context, item, index) =>
                          NotifyItem(notificationModel: item),
                    ),
                  ),
                ),
                // Container(
                //   color: Colors.transparent,
                //   height: 129.29,
                // ),
                129.29.ph,
              ],
            ),
          );
        },
      ),
    );
  }
}
