import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/network_image.dart';

import '../../../../core/theme/light_theme.dart';

class PlayerBottomSheet extends StatelessWidget {
  const PlayerBottomSheet({super.key, this.subscriber});
  final Subscriber? subscriber;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(
            // bottom: 9.h,
            ),
        height: 60,
        width: 355,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: context.primaryColor.withOpacity(
            .09,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                        subscriber?.image != null
                            ? ClipOval(
                                child: NetworkImagesWidgets(
                                  subscriber?.image ?? "",
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
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
                                ).s16.bold,
                                subscriber?.name ?? "",
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
                                    width: 14,
                                    height: 14,
                                  ),
                                  4.pw,
                                  CustomText(
                                    style: TextStyle(
                                      color: context.primaryColor,
                                    ).s14.regular,
                                    subscriber?.location ?? "",
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
                    arguments: subscriber?.id.toString(),
                  );
                },
                icon: SvgPicture.asset(
                  width: 38,
                  height: 38,
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
