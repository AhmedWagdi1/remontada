import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/more/domain/model/model.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/resources/gen/assets.gen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, this.page});
  final Pages? page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Transform.scale(
              scale: 1,
              child: Container(
                // width: 375.w,
                // height: 290.h,
                child: Assets.images.aboutSstack.image(
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
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
                          LocaleKeys.about.tr(),
                          fontSize: 26,
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
                  LocaleKeys.version.tr(),
                  color: LightThemeColors.surface,
                  fontSize: 15,
                  weight: FontWeight.w600,
                ),
                15.ph,
                Container(
                  height: 1000,
                  child: ListView(
                    children: [
                      Container(
                        height: 100,
                        child: CustomText(
                            align: TextAlign.center,
                            overflow: TextOverflow.clip,
                            color: LightThemeColors.black,
                            weight: FontWeight.w400,
                            fontSize: 14,
                            (page?.content) != ""
                                ? page?.content ?? ""
                                : "هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي"),
                      ).paddingBottom(12)
                    ],
                  ),
                )
                // Column(
                //   children: List.generate(2, (index) => HeavytextAboutWiget()),
                // ),
                // 32.ph,
                // Column(
                //   children: List.generate(1, (index) => LightTextAboutWidget()),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
