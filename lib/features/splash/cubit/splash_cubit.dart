import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remontada/core/utils/firebase_remote_confige.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/auth/domain/model/auth_model.dart';

import '../../../core/Router/Router.dart';
import '../../../core/data_source/dio_helper.dart';
import '../../../core/utils/Locator.dart';
import '../../../core/utils/firebase_message.dart';
import '../domain/repository/splash_repository.dart';
import 'splash_states.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitial());
  static SplashCubit get(context) => BlocProvider.of(context);

  SplashRepository splashRepository = SplashRepository(locator<DioService>());

//   List<OnBoardingModel> onboardingModel = [
//     OnBoardingModel(
//       stackUrl: "Assets.icons.firstOnboardingCover.path",
//       imageUrl: 'Assets.icons.bannerImg.path',
//       title: "AppStrings.onboarding1",
//       subTitle: "AppStrings.onboardingSubtitle1"
//     ),
//     OnBoardingModel(
//       stackUrl: "Assets.icons.secondOnBoardingCover.path",
//       imageUrl: "Assets.icons.meat.path",
//       title: "AppStrings.onboarding2",
//       subTitle: "AppStrings.onboardingSubtitle2"
//     ),
//     OnBoardingModel(
//       stackUrl: "Assets.icons.thirdOnboradingCover.path",
//       imageUrl: "Assets.icons.meats.path",
//       title: "AppStrings.onboarding3",
//       subTitle:  "AppStrings.onboardingSubtitle2"
//     ),
//   ];
//   int sliderIndex = 0;
//  late  PageController controller;
//   void updateSliderIndex(int index) {
//     sliderIndex = index;
//     emit(ChangeIntroState());
//   }
  getUserData() async {
    final res = await splashRepository.getProfileData();
    if (res != null) {
      Utils.user = User.fromMap(res);
      Utils.isSuperVisor = Utils.user.user?.type == "supervisor" ? true : false;
      return true;
    } else {
      null;
    }
  }

  String? route;
  checkLogin() async {
    await getAppversion();
    await FBMessging.initUniLink();
    await Utils.dataManager.getUserData();

    // await Utils.deleteUserData();
    // await splashRepository.chechShowSubScribe();

    if (Utils.token.isNotEmpty) {
      final res = await getUserData();
      if (res == null) {
        Utils.dataManager.deleteUserData();
      }
      // await dynamicLink();
      route = res == true ? Routes.LayoutScreen : Routes.LoginScreen;
      // route = Routes.LayoutScreen;
      return route;
    } else {
      // await dynamicLink();
      // route = Utils.fromNotification == true ? null : Routes.LoginScreen;
      route = Routes.LoginScreen;
      return route;
    }
  }

  Future<Position?> getLocation() async {
    try {
      final status = await Permission.location.request();

      if (status.isGranted) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } else if (status.isDenied || status.isPermanentlyDenied) {
        emit(LocationDeniedstate());
        return null;
      }
    } catch (e) {
      log(e.toString(), name: "error");
    }
    return null;
  }

  Future<void> getPostion() async {
    Position? position = await getLocation();

    Utils.lng = position?.longitude.toString() ?? "";
    Utils.lat = position?.latitude.toString() ?? "";
    log(Utils.lng);
    log(Utils.lat);
    emit(LocationAcceptedState());
  }

  bool isLastversion = false;
  getAppversion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    // Utils.appVersion = "1.0.13";
    Utils.appVersion = packageInfo.version;
    // print("app version ${Utils.appVersion}");
    isLastversion = Utils.appVersion
            .compareTo(FireBaseRemoteService.getString("app_version")) <
        0;
    // print(
    //     "FireBaseRemoteService.getString( ${FireBaseRemoteService.getString("app_version")}");

    if (isLastversion) {
      emit(
        LastVersionSuccessState(
          isLastversion,
        ),
      );
    }
  }
}
