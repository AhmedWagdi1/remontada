import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 18,
            ),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  54.84.ph,
                  SvgPicture.asset(
                    "logo".svg("icons"),
                    width: 90,
                    height: 60,
                    color: context.primaryColor,
                  ),
                  5.ph,
                  CustomText(
                    "مرحبا بك",
                    color: LightThemeColors.secondaryText,
                    fontSize: 16,
                    weight: FontWeight.w500,
                  ),
                  5.ph,
                  CustomText(
                    "اسم اللاعب",
                    color: LightThemeColors.surfaceSecondary,
                    fontSize: 18,
                    weight: FontWeight.w800,
                  ),
                  18.ph,
                  CarouselSlider(
                    items: [
                      SvgPicture.asset("slider".svg("images")),
                      SvgPicture.asset("slider".svg("images")),
                      SvgPicture.asset("slider".svg("images")),
                    ],
                    options: CarouselOptions(
                      autoPlayAnimationDuration: Duration(
                        seconds: 1,
                      ),
                      autoPlay: true,
                      height: 127,
                      padEnds: false,
                      viewportFraction: 1,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
