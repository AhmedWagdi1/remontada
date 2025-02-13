import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/more/presentation/screens/more_screen.dart';
import 'package:remontada/features/my_matches/presentation/screens/mymatches_screen.dart';
import 'package:remontada/features/notifications/presentation/screens/notification_Screen.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/resources/gen/assets.gen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../cubit/layout_cubit.dart';
import '../../cubit/layout_states.dart';
import '../widgets/widgets.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, this.index});
  final int? index;
  static void Function()? updateScreen;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit()..initTabBar(this, widget.index ?? 0),
      child: BlocConsumer<LayoutCubit, LayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = LayoutCubit.get(context);
          return Scaffold(
            body: TabBarView(
              controller: cubit.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HomeScreen(),
                Utils.token == ""
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.icons.logo,
                                // width: 100,
                                // height: 70,
                                color: context.primaryColor,
                              ),
                              20.ph,
                              Row(
                                children: [
                                  Expanded(
                                    child: ButtonWidget(
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        Routes.LoginScreen,
                                      ),
                                      child: CustomText(
                                        weight: FontWeight.w600,
                                        fontSize: 16,
                                        "تسجيل الدخول",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  15.pw,
                                  Expanded(
                                    child: ButtonWidget(
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        Routes.RegisterScreen,
                                      ),
                                      child: CustomText(
                                        weight: FontWeight.w600,
                                        fontSize: 16,
                                        " انشاء حساب",
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : DefaultTabController(
                        length: 2, initialIndex: 0, child: MyMatchesScreen()),
                Utils.token == ""
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.icons.logo,
                                // width: 100,
                                // height: 70,
                                color: context.primaryColor,
                              ),
                              20.ph,
                              Row(
                                children: [
                                  Expanded(
                                    child: ButtonWidget(
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        Routes.LoginScreen,
                                      ),
                                      child: CustomText(
                                        weight: FontWeight.w600,
                                        fontSize: 16,
                                        "تسجيل الدخول",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  15.pw,
                                  Expanded(
                                    child: ButtonWidget(
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        Routes.RegisterScreen,
                                      ),
                                      child: CustomText(
                                        weight: FontWeight.w600,
                                        fontSize: 16,
                                        " انشاء حساب",
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : NotificationScreen(),
                Utils.token == ""
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.icons.logo,
                                // width: 100,
                                // height: 70,
                                color: context.primaryColor,
                              ),
                              20.ph,
                              Row(
                                children: [
                                  Expanded(
                                    child: ButtonWidget(
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        Routes.LoginScreen,
                                      ),
                                      child: CustomText(
                                        weight: FontWeight.w600,
                                        fontSize: 16,
                                        "تسجيل الدخول",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  15.pw,
                                  Expanded(
                                    child: ButtonWidget(
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        Routes.RegisterScreen,
                                      ),
                                      child: CustomText(
                                        weight: FontWeight.w600,
                                        fontSize: 16,
                                        " انشاء حساب",
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : MoreScreen(),
              ],
            ),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: cubit.tabController.index,
              onTap: cubit.changeTab,
            ),
            extendBody: true,
          );
        },
      ),
    );
  }
}

// class DiagonalLinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 4.0;

//     final startPoint = Offset(378, 0); // نقطة البداية
//     final endPoint = Offset(129.39, 681.61); // نقطة النهاية

//     canvas.drawLine(startPoint, endPoint, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
