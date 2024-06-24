import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
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
                          "الملف الشخصي",
                          style: TextStyle(
                            color: context.primaryColor,
                          ).s24.heavy,
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
                    "عرض تفاصيل الملف الشخصي",
                    fontSize: 14.sp,
                    weight: FontWeight.w500,
                    color: LightThemeColors.secondaryText,
                  ),
                  28.ph,
                  Container(
                    width: 90.w,
                    height: 90.h,
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
                    height: 65.h,
                    radius: 33.r,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "wallet".svg(),
                          color: context.background,
                        ),
                        5.5.pw,
                        CustomText(
                          "تعديل بياناتي",
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
      bottomNavigationBar: Transform.scale(
        scale: 1.2.dm,
        child: SvgPicture.asset(
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
List<String> titles = ["رقم الجوال", "البريد الإلكتروني", "المدينة"];
List<String> subtitles = ["+9665505024", "Mnwaf52@gmail.com", "الرياض"];
