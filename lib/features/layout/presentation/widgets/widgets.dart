import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/theme/light_theme.dart';

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
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            spreadRadius: -10,
            offset: Offset(0, 0),
            blurRadius: 60,
            color: LightThemeColors.containerShadow.withOpacity(.13),
          )
        ],
      ),
      child: ClipPath(
        clipper: CustomContainer(),
        child: Container(
          height: 140.29.h,
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
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              navBarItem(Assets.icons.workspace, "الرئيسية", 0,
                  Assets.icons.workspaceOn),
              navBarItem(Assets.icons.req, "مبارياتي", 1, Assets.icons.reqOn),
              navBarItem(Assets.icons.notification, "الاشعارات", 2,
                  Assets.icons.notificationOn),
              navBarItem(
                  Assets.icons.settings, "المزيد", 3, Assets.icons.settingsOn),
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
                          width: 27.w,
                          height: 27.h,
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

                        Container(
                          width: 31,
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
                        )
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
                          width: 25.w,
                          height: 25.h,
                          color: context.tertiaryColor,
                        ),
                        6.ph,
                        Text(
                          title,
                          style: context.bodySmall?.copyWith(
                            color: LightThemeColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )
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
