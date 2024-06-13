import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/staticScreens/presentation/widgets/widgets.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 18,
        ),
        child: Column(
          children: [
            80.ph,
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: BackWidget(),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    // width: 140,
                    child: CustomText(
                      color: context.primaryColor,
                      weight: FontWeight.w800,
                      align: TextAlign.center,
                      "عن التطبيق",
                      fontSize: 24.sp,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
            25.ph,
            SvgPicture.asset(
              "logo".svg(),
              color: context.primaryColor,
            ),
            5.ph,
            CustomText(
              "1.0.0",
              color: LightThemeColors.surface,
              fontSize: 14.sp,
              weight: FontWeight.w600,
            ),
            Column(
              children: List.generate(2, (index) => HeavytextAboutWiget()),
            ),
            32.ph,
            Column(
              children: List.generate(1, (index) => LightTextAboutWidget()),
            )
          ],
        ),
      ),
    );
  }
}
