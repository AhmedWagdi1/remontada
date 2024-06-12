import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/player_details/presentation/widgets/item_widget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../shared/widgets/customAppbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "الملف الشخصي",
      ),
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
                  CustomText(
                    "عرض تفاصيل الملف الشخصي",
                    fontSize: 14.sp,
                    weight: FontWeight.w500,
                    color: LightThemeColors.secondaryText,
                  ),
                  28.ph,
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  ),
                  13.ph,
                  CustomText(
                    "محمد نواف",
                    fontSize: 20,
                    weight: FontWeight.w600,
                    color: LightThemeColors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                          color: context.primaryColor, "wallet".svg()),
                      5.27.pw,
                      CustomText(
                        "مهاجم",
                        fontSize: 18,
                        weight: FontWeight.w500,
                        color: context.primaryColor,
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

List<String> icons = ["location", "location", "location"];
List<String> titles = ["رقم الجوال", "البريد الإلكتروني", "المدينة"];
List<String> subtitles = ["+9665505024", "Mnwaf52@gmail.com", "الرياض"];
