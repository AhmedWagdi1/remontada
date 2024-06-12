import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/notifications/presentation/widgets/widgets.dart';
import 'package:remontada/shared/widgets/customtext.dart';

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            fontSize: 14,
            weight: FontWeight.w500,
            "جميع الاشعارات الخاصة بك",
            color: LightThemeColors.secondaryText,
          ),
          Column(
            children: [
              SvgPicture.asset(""),
              20.ph,
              CustomText(
                "لا توجد اشعارات",
                fontSize: 14,
                weight: FontWeight.w500,
                color: LightThemeColors.secondaryText,
              ),
              4.ph,
              CustomText(
                "لا توجد لديك اشعارات بالوقت الحالي",
                fontSize: 14,
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
          horizontal: 8.w,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              fontSize: 14,
              weight: FontWeight.w500,
              "جميع الاشعارات الخاصة بك",
              color: LightThemeColors.secondaryText,
            ),
            27.ph,
            Column(
              children: List.generate(
                3,
                (index) => NotifyItem(),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: CustomText(
          "الاشعارات",
          fontSize: 26.sp,
          weight: FontWeight.w800,
          color: context.primaryColor,
        ),
      ),
      body: thereData ? getnotifyBody() : getnonotifyBody(),
    );
  }
}
