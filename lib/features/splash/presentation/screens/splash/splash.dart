import 'package:animated_widgets_flutter/widgets/opacity_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/Router/Router.dart';
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
          if (state is LastVersionSuccessState) {
            SplashCubit.get(context).isLastversion = state.isLastVersion;
          }
          // final cubit = context.read<SplashCubit>();

          // if (state is LocationDeniedstate) {
          //   firstDialog(context, cubit);
          // }
          // Navigator.pushNamed(
          //   context,
          //   route,
          // );

          if (state is LocationAcceptedState || state is LocationDeniedstate) {
            final route = await SplashCubit.get(context).checkLogin();
            Future.delayed(Duration(milliseconds: 3000));
            SplashCubit.get(context).isLastversion
                ?
                /* Alerts.dialog(
                    Utils.navigatorKey().currentState!.context,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10)
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.system_update,
                              size: 50, color: Colors.blue),
                          SizedBox(height: 15),
                          Text(
                            'تحديث جديد متاح!',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'يرجى تحديث التطبيق للحصول على آخر الميزات وتحسينات الأداء.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextButton(
                                  child: Text('لاحقاً'),
                                  onPressed: () =>
                                      Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    route,
                                    (route) => false,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  onPressed: () {
                                    launchUrl(
                                      Platform.isAndroid
                                          ? Uri.parse(
                                              "https://play.google.com/store/apps/details?id=com.masader.remontada",
                                            )
                                          : Uri.parse(
                                              "https://apps.apple.com/us/app/6550914902",
                                            ),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  child: Text(
                                    'تحديث الآن',
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ) */

                Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.UpdateAppScreen,
                    (route) => false,
                  )
                : Navigator.pushNamedAndRemoveUntil(
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

//   Future<dynamic> firstDialog(BuildContext context, SplashCubit cubit) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Text(
//             "location_req".tr(),
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: Text(
//             'location_req1'.tr() + 'location_req3'.tr(),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text(
//                 'settings.cancel'.tr(),
//                 style: TextStyle(color: Colors.grey),
//               ),
//               onPressed: () async {
//                 // SystemNavigator.pop();
//                 Navigator.of(context).pop();
//                 final route = await cubit.checkLogin();
//                 Future.delayed(Duration(milliseconds: 3000));
//                 Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   route,
//                   (route) => false,
//                 );
//               },
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: LightThemeColors.primary, // لون الزر
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text('enableReq'.tr()),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 showLocationPermissionDialog(
//                   context,
//                   cubit,
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

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

// void showLocationPermissionDialog(BuildContext context, SplashCubit cubit) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Text(
//           "location_req".tr(),
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: Text(
//           'location_req1'.tr() + 'location_req2'.tr() + 'location_req3'.tr(),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text(
//               'settings.cancel'.tr(),
//               style: TextStyle(color: Colors.grey),
//             ),
//             onPressed: () async {
//               // SystemNavigator.pop();
//               final route = await cubit.checkLogin();
//               Future.delayed(Duration(milliseconds: 3000));
//               Navigator.pushNamedAndRemoveUntil(
//                 context,
//                 route,
//                 (route) => false,
//               );
//             },
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: LightThemeColors.primary, // لون الزر
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text('openSetting'.tr()),
//             onPressed: () async {
//               Platform.isAndroid
//                   ? await Geolocator.openAppSettings()
//                   : await Geolocator
//                       .openLocationSettings(); // يفتح إعدادات التطبيق
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
}
