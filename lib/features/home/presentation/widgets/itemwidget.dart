import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/matchdetails/domain/repositories/match_details_repo.dart';
import 'package:remontada/features/matchdetails/presentaion/screens/matchDetails_screen.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/Router/Router.dart';
import '../../domain/model/home_model.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget({
    super.key,
    this.ismymatch = false,
    this.matchModel,
  });
  final MatchModel? matchModel;
  final bool? ismymatch;

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  SubScribersModel? subscribers;
  MatchDetailsRepo matchDetailsRepo = locator<MatchDetailsRepo>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10,
        right: 5,
        left: 5,
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: 21,
          bottom: 14.27,
          right: 15.82,
          left: 15.82,
        ),
        decoration: BoxDecoration(
          color: context.background,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              // spreadRadius: -4,
              offset: Offset(0, 0),
              blurRadius: 30,
              color: LightThemeColors.black.withOpacity(.13),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constrains) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          width: 16.82,
                          height: 16.82,
                          Assets.icons.arena,
                        ),
                        6.36.pw,
                        Container(
                          // height: 20.h,
                          width: constrains.maxWidth >= 600 ? 200 : 140,
                          child: CustomText(
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: LightThemeColors.black,
                            ).s16.bold,
                            // color: context.primaryColor,
                            // weight: FontWeight.w600,
                            widget.matchModel?.playGround ?? "",
                            // fontSize: 16.sp,
                          ),
                        )
                      ],
                    ),
                    11.ph,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          width: 16.82,
                          height: 16.82,
                          "clender".svg("icons"),
                        ),
                        6.36.pw,
                        Container(
                          child: CustomText(
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: LightThemeColors.black,
                            ).s14.medium,
                            // overflow: TextOverflow.ellipsis,

                            // weight: FontWeight.w400,
                            widget.matchModel?.date ?? "",
                            // fontSize: 14.sp,
                          ),
                        )
                      ],
                    ),
                    11.ph,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          width: 16.82,
                          height: 16.82,
                          "clock".svg("icons"),
                        ),
                        6.36.pw,
                        Container(
                          child: CustomText(
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: LightThemeColors.black,
                            ).s14.medium,
                            // overflow: TextOverflow.ellipsis,
                            // color: LightThemeColors.secondaryText,
                            // weight: FontWeight.w400,
                            widget.matchModel?.start ?? "",
                            // fontSize: 14.sp,
                          ),
                        )
                      ],
                    ),
                    11.ph,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          width: 16.82,
                          height: 16.82,
                          "wallet".svg("icons"),
                        ),
                        6.36.pw,
                        Container(
                          child: CustomText(
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: LightThemeColors.pricecolor,
                            ).s14.bold,
                            // weight: FontWeight.w600,
                            widget.matchModel?.price ??
                                " ${LocaleKeys.rs.tr()}",
                            // fontSize: 14.sp,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              31.pw,
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 9.ph,
                    ButtonWidget(
                      onTap: () async {
                        final res = await matchDetailsRepo.getSubscribers(
                            widget.matchModel?.id.toString() ?? "");
                        if (res != null)
                          this.subscribers = SubScribersModel.fromMap(res);
                        showPlayersheet(
                          context,
                          subscribers: this.subscribers,
                        );
                      },
                      radius: 14,
                      width: 186,
                      height: 28,
                      buttonColor: LightThemeColors.surface,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            width: 16.54,
                            height: 16.54,
                            Assets.icons.tshirt,
                            color: context.background,
                          ),
                          3.87.pw,
                          CustomText(
                            style: TextStyle(
                              color: LightThemeColors.background,
                            ).s13.regular,
                            "المشتركين",
                            // fontSize: 12.sp,
                            // weight: FontWeight.w400,
                            // color: LightThemeColors.background,
                          ),
                          2.87.pw,
                          CustomText(
                            widget.matchModel?.subscribers ?? "20 / ",
                            // fontSize: 13,
                            // weight: FontWeight.w400,

                            style: TextStyle(
                              color: LightThemeColors.background,
                            ).s13.medium,
                          ),
                          // CustomText(
                          //   "13",
                          //   // fontSize: 12.sp,
                          //   // weight: FontWeight.w400,
                          //   // color: LightThemeColors.black,
                          //   style: TextStyle(
                          //     color: LightThemeColors.black,
                          //   ).s14.medium,
                          // ),
                        ],
                      ),
                    ),
                    // ButtonWidget(
                    //   width: 110.w,
                    //   height: 22.h,
                    //   buttonColor: LightThemeColors.surface,
                    // ),
                    50.79.ph,
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.matchDetails,
                          arguments: MatchDetailsArgs(
                            id: widget.matchModel?.id ?? 1,
                            isMymatch: widget.ismymatch,
                          ),
                        );
                      },
                      icon: SvgPicture.asset(
                        width: 45.94,
                        height: 45.94,
                        "forowrdButton".svg("icons"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
