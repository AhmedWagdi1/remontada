import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remontada/core/extensions/context_extensions.dart';
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
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  80.ph,
                  CustomText(
                    "المزيد",
                    fontSize: 26.sp,
                    weight: FontWeight.w800,
                    color: context.primaryColor,
                  ),
                  5.ph,
                  CustomText(
                    "مزيد من التحكم والتفاصيل",
                    fontSize: 16.sp,
                    weight: FontWeight.w500,
                    color: LightThemeColors.secondaryText,
                  ),
                  26.ph,
                  Column(
                    children: List.generate(
                      titles.length,
                      (index) => MoreItem(
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
