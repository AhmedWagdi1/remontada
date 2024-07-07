import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remontada/features/layout/presentation/screens/layout_screen.dart';
import 'package:remontada/features/matchdetails/presentaion/screens/matchDetails_screen.dart';
import 'package:remontada/features/player_details/presentation/screens/player_details.dart';
import 'package:remontada/features/profile/presentation/screens/edit_profile.screen.dart';
import 'package:remontada/features/staticScreens/presentation/screens/privacy_policy_screen.dart';

import '../../features/auth/presentation/screens/login/login_screen.dart';
import '../../features/auth/presentation/screens/otp/otp_screen.dart';
import '../../features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/splash/presentation/screens/on_boarding/on_boarding_screen.dart';
import '../../features/splash/presentation/screens/splash/splash.dart';
import '../../features/staticScreens/presentation/screens/about_screen.dart';

class Routes {
  static const String splashScreen = "/splashScreen";
  static const String OnboardingScreen = "/OnboardingScreen";
  static const String LoginScreen = "LoginScreen";
  static const String RegisterScreen = "RegisterScreen";
  static const String forget_passScreen = "/forgetPassScreen";
  static const String OtpScreen = "/OtpScreen";
  static const String LayoutScreen = "/LayoutScreen";
  static const String ResetPasswordScreen = "/ResetPasswordScreen";
  static const String matchDetails = "/matchDetails";
  static const String playerDetails = "/playerdetails";
  static const String profileDetails = "/profiledetails";
  static const String editProfile = "/editProfile";
  static const String aboutscreen = "/aboutScreen";
  static const String privacypolicyScreen = "/privacyPolicyScreen";
}

class RouteGenerator {
  static String currentRoute = "";

  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    currentRoute = routeSettings.name.toString();
    switch (routeSettings.name) {
      case Routes.splashScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const SplashScreen();
            });
      case Routes.OnboardingScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const OnboardingScreen();
            });
      case Routes.LoginScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const LoginScreen();
            });
      // case Routes.ResetPasswordScreen:
      //   return CupertinoPageRoute(
      //       settings: routeSettings,
      //       builder: (_) {
      //         return ResetPasswordScreen(
      //           code: (routeSettings.arguments as NewPasswordArgs).code,
      //           email: (routeSettings.arguments as NewPasswordArgs).email,
      //         );
      //       });
      case Routes.OtpScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return OtpScreen(
                onReSend: (routeSettings.arguments as OtpArguments).onReSend,
                onSubmit: (routeSettings.arguments as OtpArguments).onSubmit,
                sendTo: (routeSettings.arguments as OtpArguments).sendTo,
                init: (routeSettings.arguments as OtpArguments).init,
              );
            });
      // case Routes.forget_passScreen:
      //   return CupertinoPageRoute(
      //       settings: routeSettings,
      //       builder: (_) {
      //         return const ForgetPasswordScreen();
      //       });
      case Routes.RegisterScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const SignUpScreen();
            });

      case Routes.LayoutScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return LayoutScreen();
            });

      case Routes.matchDetails:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return MatchDetailsScreen(
                mymatch: routeSettings.arguments as bool,
              );
            });

      case Routes.playerDetails:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return PlayerDetails();
            });
      case Routes.profileDetails:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return ProfileScreen();
            });
      case Routes.editProfile:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return EditProfileScreen();
            });
      case Routes.privacypolicyScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return PrivacyScreen();
            });
      case Routes.aboutscreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return AboutScreen();
            });
      // case Routes.SplashScreen:
      //   return CupertinoPageRoute(
      //       settings: routeSettings,
      //       builder: (_) {
      //         return const SplashScreen();
      //       });

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> getNestedRoute(RouteSettings routeSettings) {
    currentRoute = routeSettings.name.toString();
    switch (routeSettings.name) {
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return CupertinoPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text("مسار غير موجود"),
              ),
              body: const Center(child: Text("مسار غير موجود")),
            ));
  }
}

class OtpArguments {
  final String sendTo;
  final bool? init;
  final dynamic Function(String) onSubmit;
  final void Function() onReSend;

  OtpArguments({
    required this.sendTo,
    required this.onSubmit,
    required this.onReSend,
    this.init,
  });
}

class NewPasswordArgs {
  final String code;
  final String email;
  const NewPasswordArgs({required this.code, required this.email});
}
