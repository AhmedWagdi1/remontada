import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/theme/light_theme.dart';

class PlayerBottomSheet extends StatelessWidget {
  const PlayerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(
            // bottom: 9.h,
            ),
        height: 60.h,
        width: 355.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
          color: context.primaryColor.withOpacity(
            .09,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: Assets.images.profile_image.image(
                            fit: BoxFit.contain,
                          ),
                        ),
                        13.pw,
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                style: TextStyle(
                                  color: LightThemeColors.black,
                                ).s14.bold,
                                "محمد نواف",
                                // fontSize: 14.sp,
                                // weight: FontWeight.w600,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Assets.icons.playLocation.toSvg(
                                  //   width: 9,
                                  //   height: 9,
                                  // ),
                                  SvgPicture.asset(
                                    Assets.icons.playLocation,
                                    width: 11.w,
                                    height: 11.h,
                                  ),
                                  4.pw,
                                  CustomText(
                                    style: TextStyle(
                                      color: context.primaryColor,
                                    ).s12.regular,
                                    "مهاجم",
                                    // fontSize: 12.sp,

                                    // weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.playerDetails,
                  );
                },
                icon: SvgPicture.asset(
                  width: 36.w,
                  height: 36.h,
                  "forowrdButton".svg(),
                ),
              ),
            )
          ],
        ),
      ),
    ).paddingBottom(10);
  }
}
