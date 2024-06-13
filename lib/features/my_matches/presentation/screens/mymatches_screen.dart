import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/presentation/widgets/itemwidget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class MyMatchesScreen extends StatefulWidget {
  const MyMatchesScreen({super.key});

  @override
  State<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> {
  bool thereData = true;
  Widget getnoMatchesBody() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          70.ph,
          CustomText(
            "مبارياتي",
            fontSize: 26.sp,
            weight: FontWeight.w800,
            color: context.primaryColor,
          ),
          5.ph,
          CustomText(
            fontSize: 14,
            weight: FontWeight.w500,
            "تفاصيل مبارياتي المشترك فيها",
            color: LightThemeColors.secondaryText,
          ),
          Column(
            children: [
              SvgPicture.asset(""),
              20.ph,
              CustomText(
                "لا توجد مباريات",
                fontSize: 14,
                weight: FontWeight.w500,
                color: LightThemeColors.secondaryText,
              ),
              4.ph,
              CustomText(
                "لم تقم بالمشاركة بأي مباراة",
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

  getMatchesBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            70.ph,
            CustomText(
              "مبارياتي",
              fontSize: 26.sp,
              weight: FontWeight.w800,
              color: context.primaryColor,
            ),
            5.ph,
            CustomText(
              fontSize: 14,
              weight: FontWeight.w500,
              "تفاصيل مبارياتي المشترك فيها",
              color: LightThemeColors.secondaryText,
            ),
            30.ph,
            Column(
              children: List.generate(
                2,
                (index) => ItemWidget(
                  ismymatch: true,
                ),
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
      // appBar:
      // AppBar(
      //   leading: SizedBox(),
      //   title: CustomText(
      //     "مبارياتي",
      //     fontSize: 26.sp,
      //     weight: FontWeight.w800,
      //     color: context.primaryColor,
      //   ),
      // ),
      body: thereData ? getMatchesBody() : getnoMatchesBody(),
    );
  }
}
