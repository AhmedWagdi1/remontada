import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/features/auth/domain/model/auth_model.dart';
import 'package:remontada/features/home/presentation/screens/webview.dart';
import 'package:remontada/features/layout/presentation/screens/layout_screen.dart';
import 'package:remontada/features/matchdetails/presentaion/screens/matchDetails_screen.dart';
import 'package:remontada/features/more/domain/contact_request.dart';
import 'package:remontada/features/my_matches/presentation/screens/create_match_screen.dart';
import 'package:remontada/features/challenges/presentation/screens/challenges_screen.dart';
import 'package:remontada/features/player_details/presentation/screens/player_details.dart';
import 'package:remontada/features/profile/presentation/screens/edit_profile.screen.dart';
import 'package:remontada/features/splash/cubit/splash_cubit.dart';
import 'package:remontada/features/splash/presentation/screens/splash/update_app.dart';
import 'package:remontada/features/staticScreens/presentation/screens/privacy_policy_screen.dart';

import '../../features/auth/presentation/screens/login/login_screen.dart';
import '../../features/auth/presentation/screens/otp/otp_screen.dart';
import '../../features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import '../../features/matchdetails/presentaion/screens/map_screen.dart';
import '../../features/matchdetails/presentaion/screens/players_screen_supervisor.dart';
import '../../features/more/domain/model/model.dart';
import '../../features/profile/domain/edit_request.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/splash/presentation/screens/splash/splash.dart';
import '../../features/staticScreens/presentation/screens/about_screen.dart';
import '../../features/staticScreens/presentation/screens/contact_screen.dart';

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
  static const String MapScreen = "/MAPsCREEN";
  static const String contactScreen = "/contactScreen";
  static const String webPage = "/webPage";
  static const String CreateMatchScreen = "/CreateMatchScreen";
  static const String PlayersScreenSupervisor = "/PlayersScreenSupervisor";
  static const String challengesScreen = "/ChallengesScreen";
  static const String UpdateAppScreen = "/UpdateAppScreen";
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
              return BlocProvider(
                create: (context) => SplashCubit()..getPostion(),
                child: const SplashScreen(),
              );
            });
      // case Routes.OnboardingScreen:
      //   return CupertinoPageRoute(
      //       settings: routeSettings,
      //       builder: (_) {
      //         return const OnboardingScreen();
      //       });
      case Routes.LoginScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const LoginScreen();
            });
      case Routes.UpdateAppScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const UpdateAppScreen();
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
                mymatch:
                    (routeSettings.arguments as MatchDetailsArgs).isMymatch,
                id: (routeSettings.arguments as MatchDetailsArgs).id,
                flagged: (routeSettings.arguments as MatchDetailsArgs).flagged,
              );
            });

      case Routes.playerDetails:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return PlayerDetails(
                id: routeSettings.arguments as String,
              );
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
              return EditProfileScreen(
                user: (routeSettings.arguments as EditScreenArgs).user,
                edit: (routeSettings.arguments as EditScreenArgs).edit,
                onSubmit: (routeSettings.arguments as EditScreenArgs).onSubmit,
              );
            });
      case Routes.privacypolicyScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return PrivacyScreen(
                page: routeSettings.arguments as Pages,
              );
            });
      case Routes.aboutscreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return AboutScreen(
                page: routeSettings.arguments as Pages,
              );
            });
      case Routes.MapScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return CustomMapWidget(
                lan: (routeSettings.arguments as PositionArgs).lang,
                lat: (routeSettings.arguments as PositionArgs).lat,
              );
            });
      case Routes.contactScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return ContactScreen(
                contact: routeSettings.arguments as Function(ContactRequest),
              );
            });
      case Routes.webPage:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return WebPage(
                uri: routeSettings.arguments as String,
              );
            });
      case Routes.CreateMatchScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return CreateMatchScreen(
              id: routeSettings.arguments as String?,
              // uri: routeSettings.arguments as String,
            );
          },
        );
      case Routes.PlayersScreenSupervisor:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return PlayersScreenSupervisor(
              id: routeSettings.arguments as String?,
              // id: routeSettings.arguments as String?,
              // uri: routeSettings.arguments as String,
            );
          },
        );
      case Routes.challengesScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const ChallengesScreen();
          },
        );
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

class MatchDetailsArgs {
  bool? isMymatch;
  int? id;
  bool? flagged;

  MatchDetailsArgs({
    this.id,
    this.isMymatch,
    this.flagged,
  });
}

class EditScreenArgs {
  User? user;
  Function(EditRequest edit)? edit;
  dynamic Function(String)? onSubmit;

  EditScreenArgs({
    this.edit,
    this.user,
    this.onSubmit,
  });
}

class PositionArgs {
  String? lang;
  String? lat;

  PositionArgs(this.lang, this.lat);
}
