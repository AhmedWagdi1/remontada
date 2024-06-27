import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/player_details/presentation/widgets/item_widget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../shared/back_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppbar(
      //   title: "الملف الشخصي",
      // ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 18,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  80.ph,
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: double.infinity,
                        // height: 40.h,
                      ),
                      Positioned(
                        // top: 0,
                        child: CustomText(
                          LocaleKeys.profile.tr(),
                          style: TextStyle(
                            color: context.primaryColor,
                          ).s26.heavy,
                          // fontSize: 26,
                          // weight: FontWeight.bold,
                          // color: context.colorScheme.primary,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        // bottom: 0,
                        child: BackWidget(),
                      ),
                    ],
                  ),
                  5.ph,
                  CustomText(
                    "showing_profile_details".tr(),
                    fontSize: 16,
                    weight: FontWeight.w500,
                    color: LightThemeColors.secondaryText,
                  ),
                  28.ph,
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.background,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: Assets.images.profile_image.image(
                      fit: BoxFit.contain,
                    ),
                  ),
                  13.ph,
                  CustomText(
                    style: TextStyle(
                      color: LightThemeColors.black,
                    ).s20.bold,
                    "محمد نواف",
                    // fontSize: 20,
                    // weight: FontWeight.w600,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.icons.playLocation.toSvg(),
                      // SvgPicture.asset(
                      //     color: context.primaryColor, "wallet".svg()),
                      5.27.pw,
                      CustomText(
                        style: TextStyle(
                          color: context.primaryColor,
                        ).s18.regular,
                        "مهاجم",
                        // fontSize: 18,
                        // weight: FontWeight.w500,
                      ),
                    ],
                  ),
                  38.ph,
                  Column(
                    children: List.generate(
                      icons.length,
                      (index) => PlayerDetailsWidget(
                        icon: icons[index],
                        title: titles[index],
                        subtitle: subtitles[index],
                      ),
                    ),
                  ),
                  23.ph,
                  ButtonWidget(
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.editProfile,
                    ),
                    height: 65,
                    radius: 33,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "wallet".svg(),
                          color: context.background,
                        ),
                        5.5.pw,
                        CustomText(
                          "edit_button".tr(),
                          fontSize: 16,
                          weight: FontWeight.bold,
                          color: context.background,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: context.background,
        // height: 100.h,
        width: double.infinity,
        child: SvgPicture.asset(
          fit: BoxFit.cover,
          "login_bottom".svg("images"),
        ),
      ),
    );
  }
}

List<String> icons = [
  Assets.icons.calling,
  Assets.icons.email,
  Assets.icons.fieldLocation,
];
List<String> titles = [
  LocaleKeys.auth_hint_phone.tr(),
  LocaleKeys.auth_hint_email.tr(),
  LocaleKeys.city.tr()
];
List<String> subtitles = ["+9665505024", "Mnwaf52@gmail.com", "الرياض"];
