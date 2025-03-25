import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
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
      PermissionStatus status = await Permission.location.status;
      await Permission.location.request;
      // Permission.location.onDeniedCallback(() async {
      //   await Permission.location.request();
      // });
      if (status.isDenied == true) {
        await Permission.location.request();

        // showLocationPermissionDialog(
        //   context,
        // );
        emit(LocationDeniedstate());
      } else if (status.isPermanentlyDenied == true) {
        // await Permission.location.request();
        // showLocationPermissionDialog(
        //   context,
        // );
        emit(LocationDeniedstate());
      } else if (status.isGranted == true) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }
    } catch (e) {
      log(e.toString(), name: "error");
    }
    // print("status $status");
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getPostion() async {
    Position? position = await getLocation();

    Utils.lng = position?.longitude.toString() ?? "";
    Utils.lat = position?.latitude.toString() ?? "";
    log(Utils.lng);
    log(Utils.lat);
    emit(LocationAcceptedState());
  }
}
