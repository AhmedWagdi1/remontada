import 'package:animated_widgets_flutter/widgets/opacity_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remontada/core/theme/light_theme.dart';

import '../../../../../core/utils/extentions.dart';
import '../../../cubit/splash_cubit.dart';
import '../../../cubit/splash_states.dart';

///// put it in routes
///  import '../../modules/splash/presentation/splash.dart';
/// static const String splashScreen = "/splashScreen";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        SplashCubit.get(context).getPostion();
      }
      // setState(() {});
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashCubit, SplashStates>(
        listener: (context, state) async {
          if (state is LocationDeniedstate)
            showLocationPermissionDialog(context);

          // Navigator.pushNamed(
          //   context,
          //   route,
          // );

          if (state is LocationAcceptedState) {
            final route = await SplashCubit.get(context).checkLogin();
            Future.delayed(Duration(milliseconds: 3000));
            Navigator.pushNamedAndRemoveUntil(
              context,
              route,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final cubit = SplashCubit.get(context);
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  "Splash".png("images"),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OpacityAnimatedWidget.tween(
                  opacityEnabled: 1,
                  opacityDisabled: 0,
                  duration: const Duration(milliseconds: 3000),
                  enabled: true,
                  // animationFinished: (finished) async {
                  //   // if (state is LocationAcceptedState) {
                  //   //   final route = await SplashCubit.get(context).checkLogin();
                  //   //   Navigator.pushNamedAndRemoveUntil(
                  //   //     context,
                  //   //     route,
                  //   //     (route) => false,
                  //   //   );
                  //   // }
                  // },
                  child: SvgPicture.asset(
                    "logo".svg('icons'),
                    // width: 200,
                    // height: 250,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// showLocatioDialog(BuildContext context) {
//   Alerts.dialog(
//     context,
//     child: LocationDialogeBody(),
//   );
// }

// class LocationDialogeBody extends StatelessWidget {
//   const LocationDialogeBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300,
//       width: 50,
//       decoration: BoxDecoration(
//         color: Colors.grey,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CustomText(
//             align: TextAlign.center,
//             "يجب عليك تشغيل الموقع لتتمكن من الدخول للتطبيق",
//             color: LightThemeColors.primary,
//             weight: FontWeight.w600,
//             fontSize: 16,
//           ),
//           10.ph,
//           TextButton(
//             style: ButtonStyle(
//               shape: WidgetStatePropertyAll(
//                 RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(
//                     10,
//                   ),
//                 ),
//               ),
//               backgroundColor: WidgetStateProperty.all(
//                 LightThemeColors.primary,
//               ),
//             ),
//             onPressed: () async {
//               await openAppSettings();
//             },
//             child: CustomText(
//               "تفعيل الموقع",
//               color: Colors.white,
//               fontSize: 14,
//               weight: FontWeight.w500,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

void showLocationPermissionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "إذن الموقع مطلوب",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'يتطلب هذا التطبيق الوصول إلى الموقع لتزويدك بخدمات أفضل. '
          "الرجاء تمكين أذونات الموقع من الإعدادات.",
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'الغاء',
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: LightThemeColors.primary, // لون الزر
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('الذهاب للاعدادات'),
            onPressed: () async {
              await openAppSettings();
              // يفتح إعدادات التطبيق
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
