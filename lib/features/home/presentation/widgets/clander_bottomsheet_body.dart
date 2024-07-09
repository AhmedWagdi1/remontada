import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/customtext.dart';

class ClanderBottomsheet extends StatefulWidget {
  const ClanderBottomsheet({
    super.key,
    this.days,
    this.onsubmit,
    this.refresh,
  });
  final Days? days;
  final VoidCallback? refresh;
  final Function(String?)? onsubmit;
  @override
  State<ClanderBottomsheet> createState() => _ClanderBottomsheetState();
}

class _ClanderBottomsheetState extends State<ClanderBottomsheet> {
  String date = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      padding: EdgeInsets.only(
        right: 5,
        left: 5,
        top: 20,
        bottom: 24,
      ),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                width: 40,
                height: 40,
                "cleander_button".svg(),
              ),
              14.36.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    fontSize: 17,
                    LocaleKeys.match_filter_clender.tr(),
                    color: LightThemeColors.primary,
                    weight: FontWeight.w800,
                  ),
                  CustomText(
                    fontSize: 14,
                    LocaleKeys.match_filter_playground_description.tr(),
                    color: LightThemeColors.secondaryText,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
          42.ph,
          SizedBox(
            height: 300,
            child: GridView.builder(
              // controller: ,
              itemCount: widget.days?.days?.length ?? 0,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 5 / 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    widget.days?.days?[i].isActive = true;

                    if (widget.days?.days?[i].isActive == true) {
                      date = widget.days?.days?[i].date ?? "";
                    }
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    width: double.infinity,
                    height: 42,
                    decoration: BoxDecoration(
                      color: widget.days?.days?[i].isActive ?? false
                          ? LightThemeColors.surface
                          : context.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 1,
                        color: widget.days?.days?[i].isActive ?? false
                            ? Colors.transparent
                            : LightThemeColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.days?.days?[i].isActive ?? false
                            ? SvgPicture.asset("checked".svg())
                            : SizedBox(),
                        widget.days?.days?[i].isActive ?? false
                            ? 5.pw
                            : SizedBox(),
                        CustomText(
                          weight: FontWeight.w400,
                          widget.days?.days?[i].text ?? "",
                          fontSize: 12,
                          color: widget.days?.days?[i].isActive ?? false
                              ? context.background
                              : LightThemeColors.black,
                        ),
                      ],
                    ).paddingBottom(5.5),
                  ),
                );
              },
            ),
          ),
          28.ph,
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ButtonWidget(
                  onTap: () {
                    widget.onsubmit!(date);
                    Navigator.pop(context);
                  },
                  height: 65,
                  radius: 33,
                  child: CustomText(
                    LocaleKeys.confirmation_button.tr(),
                    fontSize: 16,
                    weight: FontWeight.bold,
                    color: context.background,
                  ),
                ),
              ),
              10.pw,
              Expanded(
                flex: 2,
                child: ButtonWidget(
                  onTap: widget.refresh,
                  buttonColor: LightThemeColors.secondbuttonBackground,
                  height: 65,
                  radius: 33,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        color: LightThemeColors.textSecondary,
                        size: 14.83,
                        Icons.refresh,
                      ),
                      6.pw,
                      CustomText(
                        color: LightThemeColors.textSecondary,
                        LocaleKeys.refresh_button.tr(),
                        fontSize: 14,
                        weight: FontWeight.w500,
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
