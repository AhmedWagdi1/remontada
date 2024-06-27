import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/presentation/widgets/itemwidget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/resources/gen/assets.gen.dart';

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
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              70.ph,
              CustomText(
                LocaleKeys.my_matches.tr(),
                fontSize: 28,
                weight: FontWeight.w800,
                color: context.primaryColor,
              ),
              5.ph,
              CustomText(
                fontSize: 16,
                weight: FontWeight.w500,
                LocaleKeys.my_matches_subtitles.tr(),
                color: LightThemeColors.secondaryText,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.no_matches.image(
                width: 124.0,
                height: 90,
              ),
              20.ph,
              CustomText(
                LocaleKeys.no_matches.tr(),
                fontSize: 16,
                weight: FontWeight.w500,
                color: LightThemeColors.secondaryText,
              ),
              4.ph,
              CustomText(
                LocaleKeys.havnot_matches.tr(),
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

  getMatchesBody() {
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
              LocaleKeys.my_matches.tr(),
              fontSize: 26,
              weight: FontWeight.w800,
              color: context.primaryColor,
            ),
            5.ph,
            CustomText(
              fontSize: 14,
              weight: FontWeight.w500,
              LocaleKeys.my_matches_subtitles.tr(),
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
            ),
            SizedBox(
              height: 129.29,
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
