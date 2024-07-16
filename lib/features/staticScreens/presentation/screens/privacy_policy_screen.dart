import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/more/domain/model/model.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/theme/light_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({
    super.key,
    this.page,
  });
  final Pages? page;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        LocaleKeys.privacy_policy.tr(),
                        fontSize: 19,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
              44.ph,
              Column(
                children: [
                  SingleChildScrollView(
                    // height: 85,
                    child: (page?.content) != ""
                        ? Center(
                            child: Align(
                              // alignment: Alignment.center,
                              child: HtmlWidget(
                                  textStyle: TextStyle(), page?.content ?? ""),
                            ),
                          )
                        : CustomText(
                            align: TextAlign.center,
                            "هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها.إفتراضي",
                            overflow: TextOverflow.clip,
                            fontSize: 14,
                            color: LightThemeColors.black,
                            weight: FontWeight.w400,
                          ),
                  ).paddingBottom(
                    19,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
