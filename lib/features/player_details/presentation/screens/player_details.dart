import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/player_details/presentation/widgets/item_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../shared/widgets/customAppbar.dart';

class PlayerDetails extends StatefulWidget {
  const PlayerDetails({super.key});

  @override
  State<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "تفاصيل اللاعب",
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
                    "تفاصيل اللاعب المشارك بالمباراة",
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

List<String> icons = ["location", "location"];
List<String> titles = ["رقم الجوال", "المدينة"];
List<String> subtitles = ["+9665505024", "الرياض"];
