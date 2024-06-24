import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/core/utils/launcher.dart';
import 'package:remontada/features/more/presentation/widgets/customSwitch.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/services/alerts.dart';

class MoreItem extends StatefulWidget {
  const MoreItem({
    super.key,
    this.icon,
    this.title,
    this.ontap,
  });
  final String? icon;
  final String? title;
  final VoidCallback? ontap;

  @override
  State<MoreItem> createState() => _MoreItemState();
}

class _MoreItemState extends State<MoreItem> {
  pressedItem() {
    if (widget.title == "الملف الشخصي") {
      Navigator.pushNamed(
        context,
        Routes.profileDetails,
      );
    } else if (widget.title == "إرسال طلب عضوية كابتن ( مشرف )") {
      sendCaptainrequestDialogue(context);
    } else if (widget.title == "عن التطبيق") {
      Navigator.pushNamed(
        context,
        Routes.aboutscreen,
      );
    } else if (widget.title == "سياسة الخصوصية والإستخدام") {
      Navigator.pushNamed(
        context,
        Routes.privacypolicyScreen,
      );
    } else if (widget.title == "تسجيل الخروج") {
      showlogoutsheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pressedItem();
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 10.h,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 21.w,
            // vertical: 10.h,
          ),
          // width: 341.w,
          height: 54.h,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  widget.icon.toSvg(
                    color: widget.title == "تسجيل الخروج"
                        ? LightThemeColors.red
                        : context.primaryColor,
                    width: 21.w,
                    height: 21.h,
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
                ],
              ),
              widget.title == "التحكم بالإشعارات"
                  ? CustomSwitchItem()
                  : IconButton(
                      onPressed: () {
                        pressedItem();
                      },
                      icon: SvgPicture.asset(
                        "forowrdButton".svg(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSwitchItem extends StatefulWidget {
  const CustomSwitchItem({super.key});

  @override
  State<CustomSwitchItem> createState() => _CustomSwitchItemState();
}

class _CustomSwitchItemState extends State<CustomSwitchItem> {
  bool switched = false;
  @override
  Widget build(BuildContext context) {
    return CustomSwitch(
      value: switched,
      onChanged: (val) {
        switched = val;

        LauncherHelper.openNotificationsettings();

        setState(() {});
      },
    );
  }
}

sendCaptainrequestDialogue(BuildContext context) {
  Alerts.bottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(114.r),
        topRight: Radius.circular(36.r),
      ),
    ),
    context,
    child: Container(
      padding: EdgeInsets.only(
        right: 15.w,
        left: 15.w,
        top: 25.h,
        bottom: 28.h,
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
            fontSize: 16.sp,
            "إرسال طلب عضوية كابتن ( مشرف )",
            color: LightThemeColors.primary,
            weight: FontWeight.w800,
          ),
          CustomText(
            fontSize: 14.sp,
            "قم بفلترة ظهور المباريات حسب تاريخ المباراة",
            color: LightThemeColors.secondaryText,
            weight: FontWeight.w500,
          ),
          32.ph,
          ButtonWidget(
            fontSize: 16.sp,
            fontweight: FontWeight.bold,
            height: 65.h,
            radius: 33.r,
            title: "إرسال الطلب",
          ),
        ],
      ),
    ),
  );
}

showlogoutsheet(BuildContext context) {
  Alerts.bottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(114.r),
        topRight: Radius.circular(36.r),
      ),
    ),
    context,
    child: Container(
      padding: EdgeInsets.only(
        right: 15.w,
        left: 15.w,
        top: 50.h,
        bottom: 28.h,
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
            fontSize: 16.sp,
            "تسجيل الخروج",
            color: LightThemeColors.primary,
            weight: FontWeight.w800,
          ),
          CustomText(
            fontSize: 14.sp,
            "هل تريد تسجيل الخروج من حسابك ؟",
            color: LightThemeColors.secondaryText,
            weight: FontWeight.w500,
          ),
          32.ph,
          ButtonWidget(
            buttonColor: LightThemeColors.warningButton,
            fontSize: 16.sp,
            fontweight: FontWeight.bold,
            height: 65.h,
            radius: 33.r,
            title: "تسجيل الخروج",
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}
