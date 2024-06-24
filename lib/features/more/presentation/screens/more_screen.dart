import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/more/presentation/widgets/more_item.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Container(
          //   width: 500,
          //   height: 1000,
          // ),
          Positioned(
            top: 0,
            child: Transform.scale(
              scale: 1.15,
              child: Container(
                width: 375.w,
                height: 108.h,
                child: Assets.images.topStack.image(
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  70.ph,
                  CustomText(
                    style: TextStyle(
                      color: context.primaryColor,
                    ).s26.heavy,
                    "المزيد",
                    // fontSize: 26.sp,
                    // weight: FontWeight.w800,
                  ),
                  5.ph,
                  CustomText(
                    style: TextStyle(
                      color: LightThemeColors.secondaryText,
                    ).s16.regular,
                    "مزيد من التحكم والتفاصيل",
                    // fontSize: 16.sp,
                    // weight: FontWeight.w500,
                  ),
                  26.ph,
                  Column(
                    children: List.generate(
                      titles.length,
                      (index) => MoreItem(
                        icon: icons[index],
                        title: titles[index],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List titles = [
  "الملف الشخصي",
  "إرسال طلب عضوية كابتن ( مشرف )",
  "التحكم بالإشعارات",
  "اتصل بنا",
  "عن التطبيق",
  "مشاركة التطبيق",
  "سياسة الخصوصية والإستخدام",
  "تسجيل الخروج",
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
