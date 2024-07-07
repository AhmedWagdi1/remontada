import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/cubit/home_states.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/loadinganderror.dart';

class BottomSheetItem extends StatefulWidget {
  const BottomSheetItem(
      {super.key, this.playground, this.state, this.refresh, this.onsubmit});
  final playGrounds? playground;
  final HomeState? state;
  final VoidCallback? refresh;
  final Function(int?)? onsubmit;

  @override
  State<BottomSheetItem> createState() => _BottomSheetItemState();
}

class _BottomSheetItemState extends State<BottomSheetItem> {
  int? id;
  @override
  Widget build(BuildContext context) {
    return Container(
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
          LoadingAndError(
            isError: widget.state is PlayGroundLoading,
            isLoading: widget.state is PlayGroundLoading,
            child: SizedBox(
              height: 200,
              child: GridView.builder(
                // controller: ,
                itemCount: widget.playground?.playgrounds?.length ?? 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 5 / 1,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      id = widget.playground?.playgrounds?[i].id ?? 0;

                      widget.playground?.playgrounds?[i].isActive =
                          !(widget.playground?.playgrounds?[i].isActive)!;
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
                        color:
                            widget.playground?.playgrounds?[i].isActive ?? false
                                ? LightThemeColors.surface
                                : context.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 1,
                          color: widget.playground?.playgrounds?[i].isActive ??
                                  false
                              ? Colors.transparent
                              : LightThemeColors.border,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.playground?.playgrounds?[i].isActive ?? false
                              ? SvgPicture.asset("checked".svg())
                              : SizedBox(),
                          widget.playground?.playgrounds?[i].isActive ?? false
                              ? 5.pw
                              : SizedBox(),
                          CustomText(
                            weight: FontWeight.w400,
                            widget.playground?.playgrounds?[i].name ?? "",
                            fontSize: 12,
                            color:
                                widget.playground?.playgrounds?[i].isActive ??
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
          ),

          // Row(
          //   children: [
          //     Expanded(
          //         child: Column(
          //       children: List.generate(
          //           3,
          //           (index) => BottomSheetItem(
          //                 title: "ملاعب نادي القصيم الرياضي",
          //               )),
          //     )),
          //     10.pw,
          //     Expanded(
          //       child: Column(
          //         children: List.generate(
          //             3,
          //             (index) => BottomSheetItem(
          //                   title: "ملاعب نادي القصيم الرياضي",
          //                 )),
          //       ),
          //     ),
          //   ],
          // ),
          28.ph,
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ButtonWidget(
                  onTap: () {
                    widget.onsubmit!(id);
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

// class PlayGroundGrid extends StatelessWidget {
//   const PlayGroundGrid({
//     super.key,
//     this.playground,
//     this.state,
//   });
//   final playGrounds? playground;
//   final HomeState? state;
//   @override
//   Widget build(BuildContext context) {
//     return LoadingAndError(
//       isError: state is PlayGroundFailed,
//       isLoading: state is PlayGroundLoading,
//       child: SizedBox(
//           height: 200,
//           child: GridView.builder(
//               // controller: ,
//               itemCount: playground?.playgrounds?.length ?? 0,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 childAspectRatio: 5 / 1,
//                 crossAxisSpacing: 10,
//                 crossAxisCount: 2,
//               ),
//               itemBuilder: (context, i) {
//                 return BottomSheetItem(
//                   title: playground?.playgrounds?[i].name ?? "",
//                 );
//               })),
//     );
//   }
// }
