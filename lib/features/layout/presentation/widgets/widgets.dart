import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/utils.dart';

import '../../../../core/extensions/all_extensions.dart';
import '../../../../core/resources/gen/assets.gen.dart';
import '../../../../core/utils/extentions.dart';
import '../../cubit/layout_cubit.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar(
      {super.key, required this.onTap, required this.currentIndex});
  final Function(int)? onTap;
  final int currentIndex;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            // spreadRadius: -10,
            offset: Offset(0, 0),
            blurRadius: 60,
            color: LightThemeColors.containerShadow.withOpacity(.13),
          )
        ],
      ),
      child: ClipPath(
        clipper: CustomContainer(),
        child: Container(
          height: 115.39,
          decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //     // spreadRadius: -4,

            //   ),
            // ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(33),
              topRight: Radius.circular(33),
            ),
            color: context.scaffoldBackgroundColor,
            // color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              navBarItem(
                Assets.icons.home,
                LocaleKeys.home_nav.tr(),
                0,
                Assets.icons.active_home,
              ),
              navBarItem(
                Assets.icons.myMatches,
                Utils.isSuperVisor == true
                    ? "الفترات"
                    : LocaleKeys.my_matches_nav.tr(),
                1,
                Assets.icons.myMatches_active,
              ),
              navBarItem(
                Assets.icons.notify,
                LocaleKeys.notifications_nav.tr(),
                2,
                Assets.icons.active_notify,
              ),
              navBarItem(
                Assets.icons.more,
                LocaleKeys.more_nav.tr(),
                3,
                Assets.icons.active_more,
              ),
            ],
          ),
        ),
      ),
    );
    // ),
  }

  Widget navBarItem(String path, String title, int index, String pathActive,
      {VoidCallback? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          context.read<LayoutCubit>().changeTab(index);
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              context.read<LayoutCubit>().tabController.index == index
                  ? Column(
                      children: [
                        SvgPicture.asset(
                          pathActive,
                          width: 22,
                          height: 22,
                        ),
                        6.ph,
                        Text(
                          title,
                          style: context.bodySmall?.copyWith(
                            color: context.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        3.5.ph,
                        Container(
                          width: 35,
                          padding: EdgeInsets.only(
                            top: 10.5,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 4,
                                color: LightThemeColors.primary,
                              ),
                            ),
                          ),
                        ),
                        // 25.ph,
                        // Divider(
                        //   indent: 15,
                        //   height: 10.5,
                        //   thickness: 4,
                        //   color: LightThemeColors.primary,
                        // )
                        // TextWidget(
                        //   title,
                        //   color: context.primaryColor,
                        //   fontSize: 14,
                        //   fontWeight: FontWeight.w600,
                        // ),
                      ],
                    )
                  : Column(
                      children: [
                        SvgPicture.asset(
                          path,
                          width: 22,
                          height: 22,
                          // color: context.tertiaryColor,
                        ),
                        6.ph,
                        Text(
                          title,
                          style: context.bodySmall?.copyWith(
                            color: LightThemeColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        15.ph,
                        // TextWidget(
                        //
                        //
                        //
                        // ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height); // بدء الانحناء من 75% من الارتفاع
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height * .2);
    path.arcToPoint(
      Offset(0, size.height * .2),
      radius: Radius.circular(33),
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
