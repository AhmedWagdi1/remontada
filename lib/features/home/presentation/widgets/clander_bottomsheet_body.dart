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

enum SheetType {
  clander,
  playground,
}

class ClanderBottomsheet extends StatefulWidget {
  const ClanderBottomsheet({
    super.key,
    this.days,
    this.onsubmit,
    this.type,
    this.playground,
    // this.playgroundSubmit,
  });
  final Days? days;
  final SheetType? type;
  final PlayGrounds? playground;
  // final Function()? playgroundSubmit;
  final Function(List<String>? dates, List<int>? playgroundId)? onsubmit;
  @override
  State<ClanderBottomsheet> createState() => _ClanderBottomsheetState();
}

class _ClanderBottomsheetState extends State<ClanderBottomsheet> {
  List<String> dates = [];
  List<int> id = [];

  bool? sheetType() {
    if (widget.type == SheetType.playground) {
      return true;
    } else if (widget.type == SheetType.clander) {
      return false;
    }
    return null;
  }

  @override
  void initState() {
    if (widget.type == SheetType.playground) {
      id = widget.playground!.playgrounds!
          .where((e) => e.isActive == true)
          .map((e) => e.id ?? 0)
          .toList();
    } else if (widget.type == SheetType.clander) {
      dates = widget.days!.days!
          .where((e) => e.isActive == true)
          .map((e) => e.date ?? "")
          .toList();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (sheetType() != null) {
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
            sheetType() == false
                ? Row(
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
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        width: 40,
                        height: 40,
                        "playground_button".svg(),
                      ),
                      14.36.pw,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            // style: TextStyle().s16.heavy,
                            fontSize: 17,
                            LocaleKeys.match_filter_playground.tr(),
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
                itemCount: sheetType() == false
                    ? widget.days?.days?.length ?? 0
                    : widget.playground?.playgrounds?.length ?? 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 5 / 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      // widget.days?.days?.forEach((day) {
                      //   day.isActive = false;
                      // });
                      if (sheetType() == false) {
                        widget.days?.days?[i].isActive =
                            !(widget.days?.days?[i].isActive)!;

                        if (widget.days?.days?[i].isActive == true) {
                          dates.add(widget.days?.days?[i].date ?? "");
                          // map?["date"].add(widget.days?.days?[i].date ?? "");
                        } else {
                          dates.remove(widget.days?.days?[i].date ?? "");
                          // widget.days?.days?[i].isActive = false;
                        }
                      } else if (sheetType() == true) {
                        widget.playground?.playgrounds?[i].isActive =
                            !(widget.playground?.playgrounds?[i].isActive)!;

                        if (widget.playground?.playgrounds?[i].isActive ==
                            true) {
                          id.add(widget.playground?.playgrounds?[i].id ?? 0);
                        } else {
                          id.remove(widget.playground?.playgrounds?[i].id ?? 0);
                        }
                      }
                      setState(() {});
                    },
                    child: sheetType() == false
                        ? Container(
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
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            width: double.infinity,
                            height: 42,
                            decoration: BoxDecoration(
                              color:
                                  widget.playground?.playgrounds?[i].isActive ??
                                          true
                                      ? LightThemeColors.surface
                                      : context.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 1,
                                color: widget.playground?.playgrounds?[i]
                                            .isActive ??
                                        false
                                    ? Colors.transparent
                                    : LightThemeColors.border,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                widget.playground?.playgrounds?[i].isActive ??
                                        false
                                    ? SvgPicture.asset("checked".svg())
                                    : SizedBox(),
                                widget.playground?.playgrounds?[i].isActive ??
                                        false
                                    ? 5.pw
                                    : SizedBox(),
                                CustomText(
                                  weight: FontWeight.w400,
                                  widget.playground?.playgrounds?[i].name ?? "",
                                  fontSize: 12,
                                  color: widget.playground?.playgrounds?[i]
                                              .isActive ??
                                          false
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
                      // id = [];
                      // widget.days?.days?.forEach((e) {
                      //   e.isActive = false;
                      // });
                      widget.onsubmit!(dates, id);
                      // widget.playgroundSubmit!(id);
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
                    onTap: () {
                      widget.onsubmit!([], []);
                      Navigator.pop(context);
                    },
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
    } else {
      return Container();
    }
  }
}
